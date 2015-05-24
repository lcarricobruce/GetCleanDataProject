# Load in the necessary package - will use dplyr for subsetting and grouping
install.packages("dplyr")
library(dplyr)


# STEP 1: Merge data into 1 data frame.

# First we will load in the relevant data
# We will then use the following structure to create the data set 
# Rows: Train, then Test
# Columns: Subject, then y (representing Activity), then x 
# Headers: use "subject" for subject, "activity" for y, Features labels for x

# Load in the relevant datasets
activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt")
features <- read.table("./UCI HAR Dataset/features.txt")
xTest <- read.table("./UCI HAR Dataset/test/X_test.txt")
yTest <- read.table("./UCI HAR Dataset/test/y_test.txt")
subjectTest <- read.table("./UCI HAR Dataset/test/subject_test.txt")
xTrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
yTrain <- read.table("./UCI HAR Dataset/train/y_train.txt")
subjectTrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# Combine X and Y observations for each variable.
# Apply the headers at this point (NOTE: "features.txt" has duplicate variable
# names so we need to use make.names() to distinguish them) 
subject <- rbind(subjectTrain, subjectTest); names(subject) <- "subject"
y <- rbind(yTrain, yTest); names(y) <- "activity"
x <- rbind(xTrain, xTest); names(x) <- make.names(features[,2], unique=TRUE)


# Combine the columns to make 1 dataframe
rawData <- tbl_df(cbind(subject,y,x))
# We can get rid of our component columns
rm(subject,y,x)


# STEP 2: Extract only variables pertaining to mean and std

# Add a numeric index for the variables (to reorder our data after our Select()
# call below. Index will be the last (10,300th) line to make it easy to drop
# when we no longer need it.
rawData <- rbind(rawData, 1:563)

# Create vector showing which variables contain "mean.." - which replaced
#  "mean()" by make.names() and "std.." which replaced "std()". Exclude angles
#  means, which are out of scope for our consideration.
data <- select(rawData, contains("mean.."), contains("std.."), -contains("angle"), subject, activity)

# Now, we can reorder our data to its original order using our index row.
data <- data[,order(data[10300,])]
# We no longer need the index so can drop it.
data <- data[-10300,]


# STEP 3: Rename the activity data with descriptive names
# Because activityLabels is already ordered, we can just lookup to column 2
# of the row corresponding to the activity value in our data
data$activity <- activityLabels[data$activity,2]


# STEP 4: Clean up the variable names
# Here we can make some replacements to make the data looks a little better
# Convert "t" to "time" and "f" to "frequency"
names(data) <- gsub("tB","timeB", names(data))
names(data) <- gsub("tG", "timeG", names(data))
names(data) <- gsub("fB", "frequencyB", names(data))
names(data) <- gsub("fG", "frequencyG", names(data))
# Remove ".." (leftover from cleaning up the "()"'s)
names(data) <- gsub("mean..", "mean", names(data))
names(data) <- gsub("std..", "std", names(data))


# STEP 5: Create tidy data set
# Group by Subject and Activity
groupData <- group_by(data, subject, activity)
# Then summarize the columns using summarize_each()
tidyData <- summarise_each(groupData, funs(mean))
write.table(tidyData, file = "tidyData.txt", quote = FALSE, row.names = FALSE)