
########################################
# ASSUMPTIONS
# This assumes the working directory is the Git repository folder containing 
# the unzipped data sets and this script.

# These libraries will be useful for the tidying step.
library(tidyr)
library(dplyr)

########################################
# 1. Merge the training and the test sets to create one data set.

# Load the relevant data sets into R - use read.table, since they are txt files
features <- read.table("./UCI HAR Dataset/features.txt")
labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

testx <- read.table("./UCI HAR Dataset/test/X_test.txt")
testy <- read.table("./UCI HAR Dataset/test/y_test.txt")
testsubject <- read.table("./UCI HAR Dataset/test/subject_test.txt")

trainx <- read.table("./UCI HAR Dataset/train/X_train.txt")
trainy <- read.table("./UCI HAR Dataset/train/y_train.txt")
trainsubject <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# Merge the cooresponding data sets together with rbind (the README tells us
# the variables are the same in both train and test sets).
fullx <- rbind(testx, trainx)
fully <- rbind(testy, trainy)
fullsubject <- rbind(testsubject, trainsubject)

# Since the x data sets are somewhat large, let's remove them from memory.
rm(testx)
rm(trainx)

#########################################
# 2. Extract only the measurements on the mean and standard deviation for each 
# measurement.

# Use grep and regex to find all columns with "mean" or "std" in their name
meanstd <- fullx[, grep("mean\\(\\)|std\\(\\)", features$V2)]

# Since the x data set is somewhat large, let's remove it from memory.
rm(fullx)

#########################################
# 3. Use descriptive activity names to name the activities in the data set.

# I'm going to append subject at the same time, since we'll need that later.

# Add some descriptive names to the metadata. As advised in lecture, we'll 
# use lower case names with only alpha-numeric characters.
names(fully) <- c("activity")
names(labels) <- c("activity", "activitylabel")
names(fullsubject) <- c("subjectid")

# Attach the y data and subject data to the data set to get the activity and 
# subject identifier per row.
meanstd <- cbind(meanstd, fully)
meanstd <- cbind(meanstd, fullsubject)

# Now use merge to look up the provided labels for each activity,
meanstd <- merge(meanstd, labels, by.x = "activity", by.y = "activity")

# We aren't provided any subject identifiers beyond the numeric ID, so we
# don't need to merge any subject descriptive names.

#########################################
# 4. Appropriately label the data set with descriptive variable names.

# Use the names given in the features data set.
names(meanstd)[2:67] <- grep("mean\\(\\)|std\\(\\)", features$V2, value = TRUE)

#########################################
# 5. From the data set in step 4, create a second, independent tidy data set 
# with the average of each variable for each activity and each subject.

# The rows will be: activity identifier, subject identifier, direction
# identifier, and metric identifier. The columns should be the variables, 
# like tBodyAcc and tGravityAcc.  The data should contain the means.

# We will make use of the tidyr and dplyr packages, which were loaded at the top 
# of this script.  We will also use the chain function to bypass storing 
# individual steps.

tidydata <- meanstd %>%
# First, pull all the columns into long-form.
gather(variable_metric_direction, value, -activity, -activitylabel, -subjectid) %>%
# Then, separate out the measure column into multiple columns
separate(variable_metric_direction, into = c("variable", "metric", "direction")) %>%
# Now consolidate the values with group_by summarize
group_by(activity, subjectid, activitylabel, metric, direction, variable) %>%
summarize(mean = mean(value)) %>%
# Now pivot the measures back out into columns.  This is the last step of the chain.
spread(variable, mean)


#Finally, write the data to a file.
write.table(tidydata
    , file = "tidydata.txt"
    , row.names = FALSE
    , col.names = TRUE
    , sep = "\t"
    , quote = FALSE)







