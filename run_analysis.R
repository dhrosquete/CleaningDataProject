# Cleaning Data Project
# Author: Daniel Rosquete
# Repo: https://github.com/dhrosquete/CleaningDataProject
# Documentation: https://github.com/dhrosquete/CleaningDataProject/blob/master/CodeBook.md

# PLEASE If you need further Comments and explanation, check the 
# Documentation linked Above

#****** Setting the libraries, file and folder to work
setwd("C:/Users/Daniel/MachineLearning/Data Science/2 - LimpiandoDataConR/Proyecto/")

fileURL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL,destfile="Dataset.zip",method="curl")

unzip(zipfile="Dataset.zip")

library(data.table)
library(reshape2)


#****** Loading the Data, Labels and names
dataFeaturesTrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
dataFeaturesTest  <- read.table("./UCI HAR Dataset/test/X_test.txt")

dataActivityTrain <- read.table("./UCI HAR Dataset/train/y_train.txt")
dataActivityTest <- read.table("./UCI HAR Dataset/test/y_test.txt")

dataSubjectTrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")
dataSubjectTest  <- read.table("./UCI HAR Dataset/test/subject_test.txt")

#Obtain only the names, that´s why i´m using [,2]
featuresNames <- read.table("./UCI HAR Dataset/features.txt")[,2]
activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]


#****** Filtering the mean and std features
importantFeatures <- grepl("mean|std",featuresNames)
featuresNames <- grep("mean|std",featuresNames,value = TRUE)

dataFeaturesTrain <- dataFeaturesTrain[,importantFeatures]
dataFeaturesTest <- dataFeaturesTest[,importantFeatures]


#****** Assigning the labels and names
dataActivityTrain[,2] <- activityLabels[dataActivityTrain[,1]]
dataActivityTest[,2] <- activityLabels[dataActivityTest[,1]]
names(dataActivityTrain) <- c("idActivity","activName")
names(dataActivityTest) <- c("idActivity","activName")

#Assigning an ID to the subjects
names(dataSubjectTrain) <- "IDSubject"
names(dataSubjectTest) <- "IDSubject"
#Assigning the names to the Features
names(dataFeaturesTrain) <- featuresNames
names(dataFeaturesTest) <- featuresNames


#****** Column Binding the trainsets and the testsets
trainDataSet<-cbind(as.data.table(dataSubjectTrain),dataActivityTrain,dataFeaturesTrain)
testDataSet<-cbind(as.data.table(dataSubjectTest),dataActivityTest,dataFeaturesTest)

#****** Row Binding the trainsets and the testsets already binded by column.
#       Merge Equivalent
mergedDataSet<-rbind(trainDataSet,testDataSet)


#****** Creating the Tidy DataSet and writing it to a csv file
tidyData <- aggregate(. ~IDSubject + activName,mergedDataSet,mean)
tidyData <- tidyData[order(tidyData$IDSubject,tidyData$activName),]
write.csv(tidyData,file="tidyData.csv")