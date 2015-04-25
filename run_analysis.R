## Read all the txt for train, test and root folder

x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
features_names <- read.table("./data/UCI HAR Dataset/features.txt")
activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

## Step 1: Merges the training and the test sets to create one data set.
## Step 4: Appropriately labels the data set with descriptive variable names

features <- rbind(x_train, x_test)
names(features) = features_names$V2
activity <- rbind(y_train, y_test)
names(activity) <- "Activity"
subject <- rbind(subject_train, subject_test)
names(subject) <- "Subject"


## Step 2: Extracts only the measurements on the mean and standard deviation for each measurement. 

## Use grep function to look for a text like mean or std in the variables names in features table
mean_or_std_text <- grep("(mean|std)\\(\\)", features_names[, 2])
## Subset the data set using only the variables that we found in grep
features <- features[,mean_or_std_text]

##Step 3: Uses descriptive activity names to name the activities in the data set
activity <- activity_labels[activity[,1],2]

## Create a tidy data
data <- cbind(features, activity, subject)

## Step 5: From the data, creates a second, independent tidy data set with 
## the average of each variable for each activity and each subject.
library(dplyr)
library(data.table)
data$Subject <- as.factor(data$Subject)
data <- data.table(data)
tidy <- aggregate(. ~Subject + activity, data, mean)
write.table(tidy, file = "tidy_data.txt", row.names = FALSE)
