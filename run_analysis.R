setwd("C:\\Users\\a\\Desktop\\DS\\getting-n-cleaning-data\\Practise")
install.packages("downloader")
install.packages("plyr") # for join
install.packages("dplyr") # group_by function
library("downloader")
library("plyr")
library("dplyr")

if (!file.exists("WearableData")) {
      url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
      download(url, dest="WearableData.zip", mode="wb") 
      unzip ("WearableData.zip", exdir = "C:\\Users\\a\\Desktop\\DS\\getting-n-cleaning-data\\Practise\\WearableData")
}
setwd("C:\\Users\\a\\Desktop\\DS\\getting-n-cleaning-data\\Practise\\WearableData\\UCI HAR Dataset")

Training_Subject <- read.table("train//subject_train.txt")
Train_Labels <- read.table("train//y_train.txt")
Training_Set <- read.table("train//X_train.txt")

#train <- cbind(Training_Subject, Train_Labels, Training_Set)

Testing_Subject <- read.table("test//subject_test.txt")
Test_Labels <- read.table("test//y_test.txt")
Testing_Set <- read.table("test//X_test.txt")

#test <- cbind(Testing_Subject, Test_Labels, Testing_Set)

# Merges the training and the test sets to create one data set
Merged_Set <- rbind(Training_Set, Testing_Set)
Merged_Labels <- rbind(Train_Labels, Test_Labels)
Merged_Subject <- rbind(Training_Subject, Testing_Subject)
stopifnot(length(Merged_Set) == length(Merged_Labels), length(Merged_Labels) == length(Merged_Subject))

# 2
# Extracts only the measurements on the mean and standard deviation for each measurement
features <- read.table("features.txt")
SubData <- Merged_Set[grep("mean|std", features$V2)]

#3 Uses descriptive activity names to name the activities in the data set
Activity_Names <- read.table("activity_labels.txt")
LabelsWithNames <- join(Merged_Labels, Activity_Names)

SubData <- cbind(Merged_Subject, LabelsWithNames[2], SubData)

# 4 Appropriately labels the data set with descriptive variable names
names <- c(grep("mean|std", features$V2, value = TRUE))
names <- sub("^f", "Freq", names)
names <- sub("^t", "Time", names)
names <- c(c("Subject", "Activity"), names)
colnames(SubData) <- names

# 5 From the data set in step 4, creates a second, independent tidy data set with the average of each 
# variable for each activity and each subject
by1 <- factor(SubData$Subject)
by2 <- factor(SubData$Activity)
TidyData <- aggregate(x = SubData[,3:81], by=list(by1, by2), FUN="mean")
colnames(TidyData) <- names

write.table(TidyData, "TidyData.txt", row.names = FALSE)
