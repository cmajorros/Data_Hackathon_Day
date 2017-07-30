# Data_Hackathon_Day

Hello ! 

This was such an exciting project for data scientist called "Data Cafe Fellowship" and I am so happy to be here and Thanks for having me. 
It was really good experience. I dont know I will pass to final selection or not, I promise I will keep practicing. Okay, Let's start talking 
about the project. The case study is about an application for and artists and their fans and the company wants to increase thier daily users 
and increase the users. Thus, I decide to apply a predictive model which I think it can help the to do the churn analysis. 
Transaction from July 1st - July 25th are used in this study.From the data, I found that most of users do not active or use the 
application (they uses approximately 5 days (for users who download more than 25 days)).  The assumption of this project is "Will custormer
keep using the apps tomorrow?" . So the target variable is 1 = Users will use the apps tommorrow and 2 = they wont use it. I prepared some 
code for data preparation and for randomforrest. For Random_forrest.R, I included the following steps:
1) Data Importing (I prepared data and do some cleansing at data_prep.R)
2) Recheck the structure and replace the missing value.
3) Data Sampling: I have seperate the data into 2 sets (Training and Testing) with proportion 70:30. 
4) Build the model by using Random Forrest Technique. From this step, the model did not generate any outcome. I think It because insufficient of the data.
the unique user are approximately 4000 users and factor which is used are quite limited do to the limitation of time. I thinks some factors
can be improved by adding some factors like categories of contents the users views in past 7 day, last 2 week, last 30 day, the pattern or the squence of using the app,
average time spent per visit yesterday, last 7 days last month, or do they used to exit the quit before completing? ect.
5) Testing the result : This step could not be done because of the error from the previous step. However, I have prepare the code for testing the data
6) Tuning the model: I have adds some code for generating the tree plot which will help us to consider the optimal number of tree used in random forest.
7) Final Testing : This step shows how to calculate confusion matrix and shows the variable importants of this models like How many times they are used. 

I think my code quite work well. I have applied Random Forrest with HR_Analytic before (It can be found at my projects repository). 

Thanks and Have a wonderful day.
Siroros


