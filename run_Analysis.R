## wearable computing-eg: Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone

##dplyr is a grammar of data manipulation, providing a consistent set of verbs that help you solve the most common data manipulation
##Loading The required package
library(dplyr)

##Downloading and & Unzipping the dataset

filename <- "Coursera_DS3_Final.zip"

##Checking if it already exists

if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method="curl")
}  

##Checking if folder exists

if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

##Assigning all data frames

features1 <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities1<- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

##Step 1: Merges the training and the test sets to create one data set.

X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Merged_Data1 <- cbind(Subject, Y, X)


##Step 2: Extracts only the measurements on the mean and standard deviation for each measurement.

TidyData1 <- Merged_Data1 %>% select(subject, code, contains("mean"), contains("std"))


##Step 3: Uses descriptive activity names to name the activities in the data set.

TidyData1$code <- activities1[TidyData1$code, 2]


names(TidyData1)[2] = "activity"
names(TidyData1)<-gsub("Acc", "Accelerometer", names(TidyData1))
names(TidyData1)<-gsub("Gyro", "Gyroscope", names(TidyData1))
names(TidyData1)<-gsub("BodyBody", "Body", names(TidyData1))
names(TidyData1)<-gsub("Mag", "Magnitude", names(TidyData1))
names(TidyData1)<-gsub("^t", "Time", names(TidyData1))
names(TidyData1)<-gsub("^f", "Frequency", names(TidyData1))
names(TidyData1)<-gsub("tBody", "TimeBody", names(TidyData1))
names(TidyData1)<-gsub("-mean()", "Mean", names(TidyData1), ignore.case = TRUE)
names(TidyData1)<-gsub("-std()", "STD", names(TidyData1), ignore.case = TRUE)
names(TidyData1)<-gsub("-freq()", "Frequency", names(TidyData1), ignore.case = TRUE)
names(TidyData1)<-gsub("angle", "Angle", names(TidyData1))
names(TidyData1)<-gsub("gravity", "Gravity", names(TidyData1))

Final_Data <- TidyData1%>%
  group_by(subject, activity) %>%
  summarise_all(tibble::lst(mean))
write.table(Final_Data, "FinalData.txt", row.name=FALSE)

str(Final_Data)

Final_Data
