# Getting and Cleaning Data - Run Analysis
Jorge A Diaz Infante  
Friday, April 24, 2015  

Data Set Information:

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

Attribute Information:

For each record in the dataset it is provided: 
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration. 
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

Read all the txt for train, test and root folder

```r
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
features_names <- read.table("./data/UCI HAR Dataset/features.txt")
activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
```

Step 1: Merges the training and the test sets to create one data set.
Step 4: Appropriately labels the data set with descriptive variable names


```r
features <- rbind(x_train, x_test)
names(features) = features_names$V2
activity <- rbind(y_train, y_test)
names(activity) <- "Activity"
subject <- rbind(subject_train, subject_test)
names(subject) <- "Subject"
```
Step 2: Extracts only the measurements on the mean and standard deviation for each measurement. 

Use grep function to look for a text like mean or std in the variables names in features table

```r
mean_or_std_text <- grep("(mean|std)\\(\\)", features_names[, 2])
```
Subset the data set using only the variables that we found in grep

```r
features <- features[,mean_or_std_text]
```

Step 3: Uses descriptive activity names to name the activities in the data set

```r
activity <- activity_labels[activity[,1],2]
```

Create a tidy data

```r
data <- cbind(features, activity, subject)
```

Step 5: From the data, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

```r
library(dplyr)
```

```
## 
## Attaching package: 'dplyr'
## 
## The following object is masked from 'package:stats':
## 
##     filter
## 
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

```r
library(data.table)
```

```
## 
## Attaching package: 'data.table'
## 
## The following objects are masked from 'package:dplyr':
## 
##     between, last
```

```r
data$Subject <- as.factor(data$Subject)
data <- data.table(data)
tidy <- aggregate(. ~Subject + activity, data, mean)
write.table(tidy, file = "tidy_data.txt", row.names = FALSE)
```
