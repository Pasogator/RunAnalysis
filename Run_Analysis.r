##You should create one R script called run_analysis.R that does the following. 
##1.Merges the training and the test sets to create one data set.
##2.Extracts only the measurements on the mean and standard deviation for each measurement. 
##3.Uses descriptive activity names to name the activities in the data set
##4.Appropriately labels the data set with descriptive variable names. 
##5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for 
##each activity and each subject.


##Begin by reading in Data from files

getwd()
ls()

features<-read.table("features.txt")
head(features)

##Read X Values
testx<-read.table("./test/X_test.txt", col.names=features[,2])
trainx<-read.table("./train/X_train.txt", col.names=features[,2])
subjecttrain<-read.table("./train/subject_train.txt", header=FALSE)
dim(testx)
dim(trainx)

##Read Y Values
trainy<-read.table("./train/Y_train.txt", col.names=c("activity"))
testy<-read.table("./test/Y_test.txt", col.names=c("activity"))
subjecttest<-read.table("./test/subject_test.txt", header=FALSE)
dim(trainy)
dim(testy)

##Combine the Data into one set
xdata<-rbind(testx,trainx)
dim(xdata)

ydat<-rbind(testy,trainy)
dim(ydat)

subject<-rbind(subjecttest,subjecttrain)
dim(subject)

##Apply Column Names
colnames(subject)<- "Subject"
colnames(ydat)<- "Activity"
fulldat<-cbind(xdata,ydat,subject)
dim(fulldat)
head(fulldat)

##Obtain only the columns containing Mean and Standard Deviation values
stdev<-data.frame()
stdev<-fulldat[grep("std|mean|Activity|Subject",colnames(fulldat))]
dim(stdev)
head(stdev)

##Apply meaningful column names by removing abbreviations and reformatting
names(stdev)
names(stdev)<-gsub("Acc", "Accelerometer", names(stdev))
names(stdev)<-gsub("Gyro", "Gyroscope", names(stdev))
names(stdev)<-gsub("BodyBody", "Body", names(stdev))
names(stdev)<-gsub("Mag", "Magnitude", names(stdev))
names(stdev)<-gsub("^t", "Time", names(stdev))
names(stdev)<-gsub("^f", "Frequency", names(stdev))
names(stdev)<-gsub("tBody", "TimeBody", names(stdev))
names(stdev)<-gsub("-mean()", "Mean", names(stdev))
names(stdev)<-gsub("-std()", "StandardDev", names(stdev))
names(stdev)<-gsub(".std()", "StandardDev", names(stdev))
names(stdev)<-gsub("freq()", "Frequency", names(stdev))
names(stdev)<-gsub("angle", "Angle", names(stdev))
names(stdev)<-gsub("gravity", "Gravity", names(stdev))
names(stdev)<-gsub(".mean", ".Mean", names(stdev))
names(stdev)


##Replace Activity values with representative names
stdev$Activity <- as.character(stdev$Activity)
stdev$Activity[stdev$Activity == 1] <- "Walking"
stdev$Activity[stdev$Activity == 2] <- "Walking Upstairs"
stdev$Activity[stdev$Activity == 3] <- "Walking Downstairs"
stdev$Activity[stdev$Activity == 4] <- "Sitting"
stdev$Activity[stdev$Activity == 5] <- "Standing"
stdev$Activity[stdev$Activity == 6] <- "Lying Down"
head(stdev)

##obtain the means of the Activity values and Subject values
melt_stddev <- melt(stdev, id=c("Activity","Subject"))
subjmeans <- cast(melt_stddev, Subject~variable, mean)
dim(subjmeans)
head(subjmeans)

actmeans <- cast(melt_stddev, Activity~variable, mean)
dim(actmeans)
head(actmeans)

##Write this new Tidy Data into txt files
write.table(subjmeans, file="Subject_Means.txt", sep = " ", row.names = FALSE)
write.table(actmeans, file="Activity_Means.txt", sep = " ", row.names = FALSE)




