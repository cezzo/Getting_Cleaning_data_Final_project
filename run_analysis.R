# Download the data from this url "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# Unzip the data into a folder called UCI HAR Dataset

setwd("~/UCI HAR Dataset/test")

##Import Test and Train data
X_test<-read.table("X_test.txt")
Y_test<-read.table("y_test.txt")
Subject_test<-read.table("subject_test.txt")

setwd("~/UCI HAR Dataset/train")
X_train<-read.table("X_train.txt")
Y_train<-read.table("y_train.txt")
Subject_train<-read.table("subject_train.txt")

## Merge Train and Test data files and add feature labels
require(plyr)
X_data<-rbind(X_test, X_train)
Y_data<-rbind(Y_test,Y_train)
Subject_data<-rbind(Subject_test, Subject_train)

setwd("~/UCI HAR Dataset")
featurenames<-readLines("features.txt")
colnames(X_data) <- (featurenames)
Alldata<-cbind(Subject_data, Y_data)
Alldata<-cbind(Alldata, X_data)
colnames(Alldata)[1]<-c("Subject ID")
colnames(Alldata)[2]<-c("Activity")

## Extract mean and sd measurements
require(dplyr)
msbst<-select(Alldata,contains("mean("))
sdsbst<-select(Alldata,contains("std"))
selected_measurements<-cbind(Alldata$`Subject ID`, Alldata$Activity,msbst,sdsbst)

## Name activities in the dataset
colnames(selected_measurements)[1]<-c("Subject ID")
colnames(selected_measurements)[2]<-c("Activity")
selected_measurements$Activity[selected_measurements$Activity==1]<-"Walking"
selected_measurements$Activity[selected_measurements$Activity==2]<-"Walking_Upstairs"
selected_measurements$Activity[selected_measurements$Activity==3]<-"Walking_Downstairs"  
selected_measurements$Activity[selected_measurements$Activity==4]<-"Sitting"
selected_measurements$Activity[selected_measurements$Activity==5]<-"Standing"
selected_measurements$Activity[selected_measurements$Activity==6]<-"Laying"

## create tidy data set with means for each variable by activity and subject
require(data.table)
Final_data = data.table(selected_measurements)
Final_data = Final_data[, lapply(.SD,mean), by=c('Subject ID', 'Activity')]
write.table(Final_data, 'Tidy_data.txt', row.names=FALSE, sep=',', quote=FALSE)