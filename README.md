# Getting and Cleaning Data Project
The "run_analysis.R" script in this repository proceeds according to the five
steps of the Course Project. When run with the UCI HAR dataset in the working directory,
it

 1. Merges the training and the test sets to create one data set
 2. Extracts only the measurements on the mean and standard deviation for each measurement
 3. Uses descriptive activity names to name the activities in the data set
 4. Appropriately labels the data set with descriptive variable names
 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

# Data Ingestion

We read in (using the read.table function) and then combine (using rbind and cbind) the activity labels, features, test and training files to create one table containing all variables for all participants.

Then, using the select function from dplyr, we extract just mean and standard deviation
variables.

# Renaming

We look up activity names from the "activity_labels.txt" file, and use the gsub()
function to insert time and frequency into variable names.

# Averaging

We aggregate our TidyData set by using dplyr functions group_by() and summarise_each()
to average each variable by activity and subject