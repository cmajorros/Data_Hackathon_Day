setwd("C:/Users/User/Documents/Hackathon")

Transaction <- read.csv("application_txn.csv")
Users <- read.csv("user.csv")
prize <- read.csv("prize.csv")
redeem_req <- read.csv("redeemrequest.csv")
feed <- read.csv("feed.csv")
artist <- read.csv("artist.csv")

### Check Duplication
head(Transaction)
CheckDup <- Transaction[duplicated(Transaction), ]
CheckDup
nrow(CheckDup)
nrow(Transaction)
## remove Duplication
Transaction <- Transaction[!duplicated(Transaction),]
nrow(Transaction)
## Check Duplication of other tables
nrow(Users)
Dup_User <- Users[duplicated(Users), ]
nrow(Dup_User)

Dup_prize <- prize[duplicated(prize), ]
nrow(Dup_prize)

Dup_redeem <- redeem_req[duplicated(redeem_req), ]
nrow(Dup_redeem)

Dup_feed <- feed[duplicated(feed), ]
nrow(feed)
nrow(Dup_feed)

Dup_artist<- artist[duplicated(artist), ]
nrow(Dup_artist)


##Maptable
str(Transaction)
str(Users)
##Join Transaction with User Info


new_tran <- merge(x = Transaction, y = Users, by = "userid", all.x = TRUE)
head(new_tran)
str(new_tran)

##Join data with artist
str(artist)
##rename X_id to artistid
colnames(artist)[1] <- "artistid"
str(artist)
new_tran <- merge(x = new_tran, y = artist, by= "artistid" , all.x = TRUE)
str(new_tran)

#rename field
colnames(new_tran)[17] <- "label"
str(new_tran)
#Convert date data to Date format

new_tran$actionDate <-as.Date(new_tran$time_stamp2, format = "%Y-%m-%d")
new_tran$openAccDate <- as.Date(new_tran$createdtm, format = "%Y-%m-%d")
new_tran$actionDateTime <- as.POSIXct(new_tran$time_stamp2,format="%Y-%m-%d %H:%M:%S",tz=Sys.timezone())
str(new_tran)
new_tran$Birth_Conv <- as.numeric(new_tran$birth_year)

#Convert birth year to age

library(sqldf)
library(RSQLite)

df <- sqldf(" select * FROM new_tran LIMIT 10")

new_tran<- sqldf("select * ,
                 (CASE WHEN birth_year like '% 2520' THEN '40 up' WHEN birth_year like '% 2545%' THEN 'below 15' ELSE 
                 (CASE 
                 WHEN birth_year IN ('2540', '2541','2542','2543','2544','2545') THEN '15-20'  
                 WHEN birth_year IN ('2535','2536', '2537', '2588','2539') THEN '21-25' 
                 WHEN birth_year IN ('2530','2531', '2532', '2533','2534') THEN '26-30' 
                 WHEN birth_year IN ('2525','2526', '2527', '2528','2529') THEN '31-35' 
                 WHEN birth_year IN ('2520', '2521', '2522','2523', '2524' ) THEN '36-40' 
                 ELSE 'UNKNOWN' END) END)  AS user_age from new_tran ")


str(new_tran)

As_of_Date <- as.Date("2016-07-25", format = "%Y-%m-%d")
new_tran$Acc_Age <- difftime( new_tran$openAccDate ,As_of_Date, units = "days") 

str(new_tran)

library(ggplot2)
ggplot(data = new_tran, aes(x = user_age))+
         geom_bar()



#subsetdata
Base <- new_tran


Base$actionDate_Char <- as.character(as.Date(as.character(Base$actionDate, format = "%Y-%m-%d")))
str(Base)

Base_daily <- sqldf(" select distinct userid, actionDate, openAccDate, 
from Base WHERE actionDate_Char <> '2017-07-25' ORDER BY actionDate DESC")
head(Base_daily)
Base_daily$Acc_Age <- difftime(Base_daily$actionDate, Base_daily$openAccDate, units = "days")

Base_daily$key <- paste(Base_daily$userid,"-", Base_daily$actionDate-1 )

head(Base_daily)

Base_Next_day <- sqldf(" select distinct userid, actionDate, openAccDate,  from Base WHERE actionDate_Char <> '2017-07-01' ORDER BY actionDate DESC")

head(Base_Next_day,10)
Base_Next <-sqldf("select DISTINCT userid ,actionDate FROM Base_Next_day")
Base_Next$key <- paste(Base_Next$userid, "-", Base_Next$actionDate)


Base_daily <- merge(x = Base_daily, y = Base_Next, by = "key", all.x = TRUE)
colnames(Base_daily)[6] <- "UserNextday"
colnames(Base_daily)[7] <- "ActionDateNextDay"

colnames(Base_daily)[2] <- "userid"
colnames(Base_daily)[3] <- "actionDate"
Base_daily2 <- sqldf("select key, (CASE WHEN UserNextday IS 'NA' THEN 0 ELSE 1 END) AS Status from Base_daily ")
 str(Base_daily2)
 Base_daily <- merge(x = Base_daily, y = Base_daily2, by = "key", all.x = TRUE)

summary(Base_daily)

Base_daily$Status <- is.na(Base_daily$ActionDateNextDay)
Base_daily$Status <- ifelse(Base_daily$Status == TRUE, 1,0)

Last <- sqldf("SELECT userid, IDBase, action, objecttype, exp, coin, max(time_stamp2) AS time,(case WHEN exp > 0 OR coin > 0 THEN  'Get Reward' ELSE 'No Reward'  END) AS Have_Reward
      FROM Base GROUP BY IDBase") 
str(Last)

Base_daily3 <- merge(x = Base_daily, y = Last, by.x = "key", by.y= "IDBase", all.x = TRUE)
str(Base_daily2)
Base_daily3
