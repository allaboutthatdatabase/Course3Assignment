### Introduction

This is my solution to the Coursera Data Cleansing class' final project.

### Files Included

1.  The folder UCI HAR Dataset, which contains the raw data sets as provided for the assignment.  Explanations of these are provided in the file's own README and features_info files.
2.  The CodeBook file, which defines the data found in the tidy data set.
3.  The script run_analysis.R, which does the transformation from raw data to tidy.
4.  This README file.

### Trasformation Performed

In the file run_analysis.R, the following transformations are performed:

1.  Read in the relevant data files from the raw data folder into memory.
2.  Combine the "test" and "train" files together with rbind.
3.  Use grep to find the measures with "mean()" or "std()" in their names.  Only use those variables in continuing calculations.
4.  Create descriptive names for the activities and subjects, and then append those columsn with cbind and merge to the main data set.
5.  Name the column headers for the variables in the data set using the provided feature names.
6.  Create tidy data by: gathering the long-form variable names into a long table; separating the variable names into three separate columns by their name parts; group and summarize the data in order to calculate means; and then pivot the variables back into columns.  This is achieved with the tidyr and dplyr packages.
