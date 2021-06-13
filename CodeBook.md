# The original data was transformed by
1. Merging the training and the test sets to create one data set.
2. Extracting only the measurements on the mean and standard deviation for each measurement.
3. Using descriptive activity names to name the activities in the data set
4. Appropriately labeling the data set with descriptive activity names.
5. Creating a second, independent tidy data set with the average of each variable for each activity and each subject.

# About R script
File with R code "run_analysis.R" performs the 5 steps above.

# About variables:
- x_train, y_train, x_test, y_test, subject_train and subject_test contain the data from the downloaded files.
- features (10299 rows, 561 columns) is created by merging x_train and x_test using bind_rows() function
- activity (10299 rows, 1 column) is created by merging y_train and y_test using bind_rows() function
- Subject (10299 rows, 1 column) is created by merging subject_train and subject_test using bind_rows() function
- final_df (10299 rows, 563 column) is created by merging Subject, features and activity using bind_cols() function
- final_df2 (180 rows, 88 columns) is created by sumarizing final_df taking the means of each variable for each activity and each subject, after grouped by subject and activity.

# Output
- final_df2 is outputted as a txt file called TidyData.txt using write.table() function.