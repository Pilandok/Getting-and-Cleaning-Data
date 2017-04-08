#setwd("C:/Users/Admin/Downloads/getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset")

library(plyr)
library(data.table)

#read data

subjectTrain = read.table('./train/subject_train.txt',header=FALSE)
x_train = read.table('./train/x_train.txt',header=FALSE)
y_train = read.table('./train/y_train.txt',header=FALSE)

subjectTest = read.table('./test/subject_test.txt',header=FALSE)
x_test = read.table('./test/x_test.txt',header=FALSE)
y_test = read.table('./test/y_test.txt',header=FALSE)


# 1. Merges the training and the test sets to create one data set.

x_data <- rbind(x_train, x_test) #motion_data
y_data <- rbind(y_train, y_test) #activity_data
subject_data <- rbind(subjectTrain, subjectTest) #subject_data


# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
x_data_mean_std <- x_data[, grep("(\S*(mean)|\S*(std)).*", read.table("features.txt")[, 2])]


# 3. Uses descriptive activity names to name the activities in the data set

y_data[, 1] <- read.table("activity_labels.txt")[y_data[, 1], 2]
names(y_data) <- "Activity"


# 4. Appropriately labels the data set with descriptive variable names.

names(x_data_mean_std) <- read.table("features.txt")[grep("-(mean|std)\\(\\)", read.table("features.txt")[, 2]), 2] 


# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

names(subject_data) <- "Subject"
tidy_data <- cbind(x_data_mean_std, y_data, subject_data)
tidy_data <- aggregate(x = tidy_data, by=list(activities=tidy_data$Activity, subj=tidy_data$Subject), FUN = mean)
write.table(tidy_data, './tidy_data.txt', row.names = FALSE)
