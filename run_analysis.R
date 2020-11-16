#Week4 assignment
#Initialize tools needed 
library(data.table)
library(dplyr)
#load and download the dataset
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dataname <- "Week4assignment.zip"
if (!file.exists(dataname)){
  download.file(url, destfile = dataname, mode='wb')
}
if (!file.exists("./UCI HAR Dataset")){
  unzip(dataname)
}
#enter the newly unzipped folder
setwd("./UCI HAR Dataset")

#read the files needed.Some files are in test and train folders
labels<-read.table("activity_labels.txt")
features<-read.table("features.txt")
trainsub<-read.table("./train/subject_train.txt")
featrain<-read.table("./train/X_train.txt")
activtrain<-read.table("./train/y_train.txt")
testsub<-read.table("./test/subject_test.txt")
featest<-read.table("./test/X_test.txt")
activtest<-read.table("./test/y_test.txt")

#merge first all the test and training sets and then merge the combined sets

traindata<-cbind(trainsub,featrain,activtrain)
testdata<-cbind(testsub,featest,activtest)
mergedata<-rbind(traindata,testdata)

# str(mergedata,n=3) just to look at the data
#add the column names to the new dataframe
colnames(mergedata)<-c("subject",features$V2,"activity")

# head(mergedata,n=1)
#filter out the names with mean and std deviation
select<-grepl("subject|mean|std|activity",colnames(mergedata))
newerdata<-mergedata[,select]
names(newerdata)
#organize the dataset by activity
newerdata$activity<-factor(newerdata$activity, levels=labels[,1],labels=labels[,2])
newerdata$subject<-as.factor(newerdata$subject)
# names(newerdata)
#change some of the names 
colnames(newerdata)<-gsub("^t", "time", names(newerdata))
colnames(newerdata)<-gsub("^f", "frequency", names(newerdata))
colnames(newerdata)<-gsub("Freq", "frequency", names(newerdata))
colnames(newerdata)<-gsub("Mag", "magnitude", names(newerdata))
colnames(newerdata)<-gsub("BodyBody", "Body", names(newerdata))
#make the final dataset organized by average of subject &activity 
Finaldata<-aggregate(. ~subject + activity, newerdata, mean)
#output the tidy dataset
write.table(Finaldata, file = "tidydata.txt",row.name=FALSE)
