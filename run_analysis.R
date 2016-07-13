#Load library
library(dplyr)

#Load data
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")
features <- read.table("./UCI HAR Dataset/features.txt")

testSubject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
trainSubject <- read.table("./UCI HAR Dataset/train/subject_train.txt")

xTest <- read.table("./UCI HAR Dataset/test/X_test.txt")
yTest <- read.table("./UCI HAR Dataset/test/y_test.txt")

xTrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
yTrain <- read.table("./UCI HAR Dataset/train/y_train.txt")


#Merges the training and the test sets to create one data set.
subjectData <- rbind(testSubject, trainSubject)
xData <- rbind(xTest, xTrain)
yData <- rbind(yTest, yTrain)

#Extracts only the measurements on the mean and standard deviation for each measurement.
extractFeatures <- features$V2[grepl("mean|std", features$V2)]
extractFeatures <- as.character(extractFeatures)
extractFeatures <- gsub("()","", extractFeatures, fixed=TRUE)
extractFeatures <- gsub("-","", extractFeatures, fixed=TRUE)
xData <- xData[grepl("mean|std", features$V2)]

#Uses descriptive activity names to name the activities in the data set
yData$activityName = activities$V2[match(yData$V1, activities$V1)]

#Merges the training and the test sets to create one data set.
data <- cbind(subjectData$V1, yData$activityName, xData)

#Appropriately labels the data set with descriptive variable names.
dataNames<- c("subject", "activity", extractFeatures)
names(data) <- dataNames
write.table(data, "./data.txt", row.names = FALSE)

#From the data set in step 4, creates a second, independent tidy data set 
#with the average of each variable for each activity and each subject
data %>% group_by(subject, activity) %>% summarise_each(funs(mean)) %>% as.data.frame() %>% write.table("./data-mean.txt", row.names=FALSE)
