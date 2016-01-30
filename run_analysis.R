setwd("C:\\Users\\a\\Desktop\\DS\\Getting & Cleaning Data\\Practise")
install.packages("downloader")
install.packages("plyr") #for join
install.packages("dplyr")
library("downloader")
library("plyr")
library("dplyr") # group_by function

if (!file.exists("WearableData")) {
      url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
      download(url, dest="WearableData.zip", mode="wb") 
      unzip ("WearableData.zip", exdir = "C:\\Users\\a\\Desktop\\DS\\Getting & Cleaning Data\\Practise\\WearableData")
}
setwd("C:\\Users\\a\\Desktop\\DS\\Getting & Cleaning Data\\Practise\\WearableData\\UCI HAR Dataset")

Train_Labels <- read.table("train//y_train.txt", sep="\t")
Training_Set <- read.table("train//X_train.txt")
Training_Subject <- read.table("train//subject_train.txt", sep="\t")

train <- cbind(Training_Subject, Train_Labels, Training_Set)


Test_Labels <- read.table("test//y_test.txt", sep="\t")
Testing_Set <- read.table("test//X_test.txt")
Testing_Subject <- read.table("test//subject_test.txt", sep="\t")

test <- cbind(Testing_Subject, Test_Labels, Testing_Set)

# Merges the training and the test sets to create one data set
data <- rbind(train,test)

# 2
# Extracts only the measurements on the mean and standard deviation for each measurement
features <- read.table("features.txt")
SubData <- data[grep("mean|std", features$V2) + 2]
SubData <- cbind(data[1], data[2], SubData)

#3 Uses descriptive activity names to name the activities in the data set
names(SubData) <- c(grep("mean|std", features$V2, value = TRUE))
Activity_Names <- read.table("activity_labels.txt")

a <- join(data[2], Activity_Names)
SubData[2] <- a[2]

# 4 Appropriately labels the data set with descriptive variable names
names <- c(grep("mean|std", features$V2, value = TRUE))
names <- sub("^f", "Freq", names)
names <- sub("^t", "Time", names)
names <- c(c("Subject", "Activity"), names)
colnames(SubData) <- names

# 5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable 
# for each activity and each subject
"""
#  note that .SDcols also allows reordering of the columns
dt[, lapply(.SD, sum, na.rm=TRUE), by=category, .SDcols=c('a', 'c', 'z') ] 
e.dt[, lapply(.SD, mean), by = list(SiteNo, Group)]

TidyData %>% group_by(Subject) %>% group_by(Activity) %>% summarize_each(funs(mean, mean), Subject, Activity)

TidyData[, lapply(TidyData, mean) by = list('Subject')]

"""
by1 <- factor(SubData$Subject)
by2 <- factor(SubData$Activity)
TidyData <-aggregate(x = SubData, by=list(by1, by2), FUN="mean")
TidyData <- TidyData[, !names(TidyData) %in% c("Subject", "Activity")]
colnames(TidyData) <- names

write.table(TidyData, "TidyData.txt", row.names = FALSE)
