library(reshape2)

subject_train <- read.table("subject_train.txt")
subject_test <- read.table("subject_test.txt")
X_train <- read.table("X_train.txt")
X_test <- read.table("X_test.txt")
y_train <- read.table("y_train.txt")
y_test <- read.table("y_test.txt")

names(subject_train) <- "subjectID"
names(subject_test) <- "subjectID"

# column names for measurement files
featureNames <- read.table("features.txt")
names(X_train) <- featureNames$V2
names(X_test) <- featureNames$V2

# column name for label files
names(y_train) <- "activity"
names(y_test) <- "activity"

# combine files into one dataset
train <- cbind(subject_train, y_train, X_train)
test <- cbind(subject_test, y_test, X_test)
combined <- rbind(train, test)

meanstdcols <- grepl("mean\\(\\)", names(combined)) |
    grepl("std\\(\\)", names(combined))

# ensure we keep the subjectID and activity columns
meanstdcols[1:2] <- TRUE

# remove unnecessary columns
combined <- combined[, meanstdcols]

# convert column to factor
combined$activity <- factor(combined$activity, labels=c("Walking",
    "Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying"))


# create the tidy data set
melted <- melt(combined, id=c("subjectID","activity"))
tidy <- dcast(melted, subjectID+activity ~ variable, mean)

# write the tidy data set to a file
write.csv(tidy, "tidy.csv", row.names=FALSE)
