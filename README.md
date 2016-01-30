## Getting-and-Cleaning-Data-Course-Project
Final project for "Getting and Cleaning Data" course on Coursera. The purpose of this project is to obtain a tidy data set.

[The data used for the project] (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).

A full description of the data can be found [here] (http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

This repository contains:
- run_analysis.R - source code in R
- TidyData.txt - tidy data obtained in the script
- CodeBook.md - a code book that describes the variables, the data, and any transformations that are performed
- README.md - a brief explanation of the project and files in the repo

The R script does the following:

1. Merges the training and the test sets to create one data set
2. Extracts only the measurements on the mean and standard deviation for each measurement
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

