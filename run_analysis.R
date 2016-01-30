setwd("C:\\Users\\a\\Desktop\\DS\\getting-n-cleaning-data\\Practise")
install.packages("downloader") # to download and unzip files
install.packages("plyr") # for using join function
install.packages("dplyr") # for using group_by function
library("downloader")
library("plyr")
library("dplyr")

# Downloads and unzips files
if (!file.exists("WearableData")) {
      url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
      download(url, dest="WearableData.zip", mode="wb")
      unzip ("WearableData.zip", exdir = "WearableData")
}

# Sets unzipped folder as a working directory
setwd("WearableData//UCI HAR Dataset")

# Reads required training files
Training_Subject <- read.table("train//subject_train.txt")
Train_Labels <- read.table("train//y_train.txt")
Training_Set <- read.table("train//X_train.txt")

# Reads required testing files
Testing_Subject <- read.table("test//subject_test.txt")
Test_Labels <- read.table("test//y_test.txt")
Testing_Set <- read.table("test//X_test.txt")

# 1)
# Merges the training and the test sets to create one data set
Merged_Set <- rbind(Training_Set, Testing_Set)
Merged_Labels <- rbind(Train_Labels, Test_Labels)
Merged_Subject <- rbind(Training_Subject, Testing_Subject)

# Checks if dimensions match, if not -- stops the programm
stopifnot(length(Merged_Set) == length(Merged_Labels), length(Merged_Labels) == length(Merged_Subject))

# 2)
# Extracts only the measurements on the mean and standard deviation for each measurement
features <- read.table("features.txt") # the file with variables names
# Subsets data so it only contains variables with mean and std in their names
SubData <- Merged_Set[grep("mean|std", features$V2)]

# 3)
# Uses descriptive activity names to name the activities in the data set
# Reads the file with activities numbers and coresponding names
Activity_Names <- read.table("activity_labels.txt") 
# Merges labels and their names preserving the order of the labels
LabelsWithNames <- join(Merged_Labels, Activity_Names)
# Adds subject and activity columns to the data set 
SubData <- cbind(Merged_Subject, LabelsWithNames[2], SubData)

# 4)
# Appropriately labels the data set with descriptive variable names
names <- c(grep("mean|std", features$V2, value = TRUE)) # gets names for the measurments
names <- sub("^f", "Freq", names) # changes "f" to "Freq" in the list of names
names <- sub("^t", "Time", names) # changes "t" to "Time" in the list of names
names <- c(c("Subject", "Activity"), names) # adds 2 first names to the list of names
colnames(SubData) <- names # names columns of the data

# 5)
# From the data set in step 4, creates a second, independent tidy data set with the average of each 
# variable for each activity and each subject
by1 <- factor(SubData$Subject)
by2 <- factor(SubData$Activity)
# Aggregates data according to Subject and Activity
TidyData <- aggregate(x = SubData[,3:81], by=list(by1, by2), FUN="mean")
# The aggregate function renames the first 2 columns, so we have to rename the columns again
colnames(TidyData) <- names

# Writes the tidy data to a file TidyData.txt
write.table(TidyData, "TidyData.txt", row.names = FALSE)