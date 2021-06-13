setwd("C:/Users/jacks/1. Coding/1. R/6. DS Course/DS Specialization/3. Getting and Cleaning Data/Project")

list.files(recursive=TRUE)

## --- Load Packages
pacman::p_load(tidyverse,data.table)

## --- Load Datasets
for (t in c('test','train')) {
  
  for (i in grep('.txt',list.files(t),value = TRUE)){
    assign(gsub('.txt','',i),
           data.table::fread(file.path(t,i),header = FALSE)
    )
    
  }

}

## --- Bind Datasets
OLD <- c('subject','y','X')
NEW <- c('subject','activity','features')
for(i in 1:3){
  assign(NEW[i],
         dplyr::bind_rows(get(paste0(OLD[i],"_test")),get(paste0(OLD[i],"_train")))
         )
}


## Set names
names(activity) <- c('activity')
names(subject) <- c('subject')
features_temp <- data.table::fread('features.txt'); names(features) <- features_temp$V2

## --- Add descriptive activity names
activity_temp <- data.table::fread('activity_labels.txt')
activity$activity <- factor(activity$activity,labels = activity_temp$V2)

## --- features DF : Select vars for mean and standard deviation
features <- features %>% 
  dplyr::select(grep(paste(c('mean','std'),collapse="|"), features %>% names(), value=TRUE)) %>% 
  dplyr::select(-grep('Freq', features %>% names(), value=TRUE))
  
## Add descriptive feature var names 
pattern <- c("^t","^f","Acc","Gyro","Mag","BodyBody")
replacement <- c("time","frequency","Accelerometer","Gyroscope","Magnitude","Body")

for(i in 1:length(pattern)){
  names(features) <- gsub(pattern[i], replacement[i], features %>%  names())
}

## --- Combined data
col_list <- list()
for(i in NEW){
  col_list[[i]] <- get(i)
}
final_df <- dplyr::bind_cols(col_list)

## Clear 
rm(list = setdiff(ls(),'final_df'));gc()

## --- Summarize data by subject & activity : fun = mean
final_df2 <- final_df %>% 
  group_by_at(.vars = vars('subject','activity')) %>% 
  summarize_all(mean)

write.table(final_df2,'TidyData.txt',row.names = FALSE)

