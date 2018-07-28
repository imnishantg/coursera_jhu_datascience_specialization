######### Reading the Data ############

activity_labels = read.table("./UCI HAR Dataset/activity_labels.txt", header= FALSE, col.names= c("ActivityID", "ActivityName"))
features = read.table("./UCI HAR Dataset/features.txt", header= FALSE)

####### Reading the Training Dataset ########

subject_train = read.table("./UCI HAR Dataset/train/subject_train.txt", header= FALSE)
X_train = read.table("./UCI HAR Dataset/train/X_train.txt", header= FALSE)
y_train = read.table("./UCI HAR Dataset/train/y_train.txt", header= FALSE)


body_acc_x_train = read.table("./UCI HAR Dataset/train/Inertial Signals/body_acc_x_train.txt", header= FALSE)
body_acc_y_train = read.table("./UCI HAR Dataset/train/Inertial Signals/body_acc_y_train.txt", header= FALSE)
body_acc_z_train = read.table("./UCI HAR Dataset/train/Inertial Signals/body_acc_z_train.txt", header= FALSE)

body_gyro_x_train = read.table("./UCI HAR Dataset/train/Inertial Signals/body_gyro_x_train.txt", header= FALSE)
body_gyro_y_train = read.table("./UCI HAR Dataset/train/Inertial Signals/body_gyro_y_train.txt", header= FALSE)
body_gyro_z_train = read.table("./UCI HAR Dataset/train/Inertial Signals/body_gyro_z_train.txt", header= FALSE)

total_acc_x_train = read.table("./UCI HAR Dataset/train/Inertial Signals/total_acc_x_train.txt", header= FALSE)
total_acc_y_train = read.table("./UCI HAR Dataset/train/Inertial Signals/total_acc_y_train.txt", header= FALSE)
total_acc_z_train = read.table("./UCI HAR Dataset/train/Inertial Signals/total_acc_z_train.txt", header= FALSE)


####### Reading the Test Dataset ########

subject_test = read.table("./UCI HAR Dataset/test/subject_test.txt", header= FALSE)
X_test = read.table("./UCI HAR Dataset/test/X_test.txt", header= FALSE)
y_test = read.table("./UCI HAR Dataset/test/y_test.txt", header= FALSE)


body_acc_x_test = read.table("./UCI HAR Dataset/test/Inertial Signals/body_acc_x_test.txt", header= FALSE)
body_acc_y_test = read.table("./UCI HAR Dataset/test/Inertial Signals/body_acc_y_test.txt", header= FALSE)
body_acc_z_test = read.table("./UCI HAR Dataset/test/Inertial Signals/body_acc_z_test.txt", header= FALSE)

body_gyro_x_test = read.table("./UCI HAR Dataset/test/Inertial Signals/body_gyro_x_test.txt", header= FALSE)
body_gyro_y_test = read.table("./UCI HAR Dataset/test/Inertial Signals/body_gyro_y_test.txt", header= FALSE)
body_gyro_z_test = read.table("./UCI HAR Dataset/test/Inertial Signals/body_gyro_z_test.txt", header= FALSE)

total_acc_x_test = read.table("./UCI HAR Dataset/test/Inertial Signals/total_acc_x_test.txt", header= FALSE)
total_acc_y_test = read.table("./UCI HAR Dataset/test/Inertial Signals/total_acc_y_test.txt", header= FALSE)
total_acc_z_test = read.table("./UCI HAR Dataset/test/Inertial Signals/total_acc_z_test.txt", header= FALSE)


############# Merging the Training Dataset ############

complete_train = cbind(subject_train, y_train, X_train, body_acc_x_train, body_acc_y_train, body_acc_z_train, body_gyro_x_train, body_gyro_y_train, body_gyro_z_train, total_acc_x_train, total_acc_y_train, total_acc_z_train)

############# Merging the Training Dataset ############

complete_test = cbind(subject_test, y_test, X_test, body_acc_x_test, body_acc_y_test, body_acc_z_test, body_gyro_x_test, body_gyro_y_test, body_gyro_z_test, total_acc_x_test, total_acc_y_test, total_acc_z_test)

############# Training and Testing Dataset Merge ###############

complete_DS = rbind(complete_train, complete_test)

# Creating the Column Labels for Complete_DS

lab_body_acc_x = paste(rep("body_acc_x", 128), 1:128, sep = "_")
lab_body_acc_y = paste(rep("body_acc_y", 128), 1:128, sep = "_")
lab_body_acc_z = paste(rep("body_acc_z", 128), 1:128, sep = "_")

lab_body_gyro_x = paste(rep("body_gyro_x", 128), 1:128, sep = "_")
lab_body_gyro_y = paste(rep("body_gyro_y", 128), 1:128, sep = "_")
lab_body_gyro_z = paste(rep("body_gyro_y", 128), 1:128, sep = "_")

lab_total_acc_x = paste(rep("total_acc_x", 128), 1:128, sep = "_")
lab_total_acc_y = paste(rep("total_acc_y", 128), 1:128, sep = "_")
lab_total_acc_z = paste(rep("total_acc_z", 128), 1:128, sep = "_")

feature_name = as.vector(features$V2)

colnames(complete_DS) = c("SubjectID", "ActivityCode", feature_name,  lab_body_acc_x, lab_body_acc_y, lab_body_acc_z, lab_body_gyro_x, lab_body_gyro_y, lab_body_gyro_z, lab_total_acc_x, lab_total_acc_y, lab_total_acc_z)

############# Mapping the Activity Name to the Dataset ############

Final_DS = merge(x=complete_DS, y= activity_labels, by.x= "ActivityCode", by.y= "ActivityID", all = TRUE)

# You can skip this step if you wish to avoid downloading this data. The size of the following dataset is ~190 MB
write.table(Final_DS, "Final_DS_1.txt", row.names= FALSE, sep = " ") # You can skip this step if you wish to avoid downloading this data

# Upto this point, we have created the final dataset, which would be used to create the second Tidy Dataset as per the assessment requirement
# According to the second point of the instructions: "Extracts only the measurements on the mean and standard deviation for each measurement"
# Following this, I would be isolating and creating the means and standard deviations of features and Inertial Signals.

########### Checking for Missing Values ###########

all(colSums(is.na(Final_DS)) == 0)    # If it returns TRUE, then there are no NAs/missing values in the dataset

############# Transforming the Final Dataset ##############

Trans_Final_DS = Final_DS[order(Final_DS$ActivityCode, Final_DS$SubjectID),]

## Identifying the Columns that contain Mean and SD measurements of the features

VarWithMean = setdiff(grep("mean", colnames(Trans_Final_DS)), grep("meanFreq", colnames(Trans_Final_DS)))
VarWithStd = grep("std", colnames(Trans_Final_DS))

## Creating the dataset to be used for developing tidy dataset

FinalDS2 = Trans_Final_DS[,c(1,2,1716,VarWithMean, VarWithStd)]

FinalDS2$mean_body_acc_x = rowMeans(Trans_Final_DS[,(564 + 128*0):(564 + 128*1 - 1)])
FinalDS2$mean_body_acc_y = rowMeans(Trans_Final_DS[,(564 + 128*1):(564 + 128*2 - 1)])
FinalDS2$mean_body_acc_z = rowMeans(Trans_Final_DS[,(564 + 128*2):(564 + 128*3 - 1)])
FinalDS2$mean_body_gyro_x = rowMeans(Trans_Final_DS[,(564 + 128*3):(564 + 128*4 - 1)])
FinalDS2$mean_body_gyro_y = rowMeans(Trans_Final_DS[,(564 + 128*4):(564 + 128*5 - 1)])
FinalDS2$mean_body_gyro_z = rowMeans(Trans_Final_DS[,(564 + 128*5):(564 + 128*6 - 1)])
FinalDS2$mean_total_acc_x = rowMeans(Trans_Final_DS[,(564 + 128*6):(564 + 128*7 - 1)])
FinalDS2$mean_total_acc_y = rowMeans(Trans_Final_DS[,(564 + 128*7):(564 + 128*8 - 1)])
FinalDS2$mean_total_acc_z = rowMeans(Trans_Final_DS[,(564 + 128*8):(564 + 128*9 - 1)])

FinalDS2$std_body_acc_x = apply(Trans_Final_DS[,(564 + 128*0):(564 + 128*1 - 1)], 1, sd)
FinalDS2$std_body_acc_y = apply(Trans_Final_DS[,(564 + 128*1):(564 + 128*2 - 1)], 1, sd)
FinalDS2$std_body_acc_z = apply(Trans_Final_DS[,(564 + 128*2):(564 + 128*3 - 1)], 1, sd)
FinalDS2$std_body_gyro_x = apply(Trans_Final_DS[,(564 + 128*3):(564 + 128*4 - 1)], 1, sd)
FinalDS2$std_body_gyro_y = apply(Trans_Final_DS[,(564 + 128*4):(564 + 128*5 - 1)], 1, sd)
FinalDS2$std_body_gyro_z = apply(Trans_Final_DS[,(564 + 128*5):(564 + 128*6 - 1)], 1, sd)
FinalDS2$std_total_acc_x = apply(Trans_Final_DS[,(564 + 128*6):(564 + 128*7 - 1)], 1, sd)
FinalDS2$std_total_acc_y = apply(Trans_Final_DS[,(564 + 128*7):(564 + 128*8 - 1)], 1, sd)
FinalDS2$std_total_acc_z = apply(Trans_Final_DS[,(564 + 128*8):(564 + 128*9 - 1)], 1, sd)


# 'FinalDS2' is the dataframe which will be used to obtain the Tidy Dataset 2
########### Developing Final Tidy Dataset

library(data.table)
FinalDS2_dataTable<- data.table(FinalDS2)
FinalDS3 <- FinalDS2_dataTable[, lapply(.SD, mean), by=c("SubjectID", "ActivityCode")]

FinalDS3 = as.data.frame(FinalDS3)
FinalDS3$ActivityName = NULL

FinalDS4 = merge(x=FinalDS3, y= activity_labels, by.x= "ActivityCode", by.y= "ActivityID", all = TRUE)
FinalDS4 = FinalDS4[,c(1,2,87, 3:86)]

## Writing the Final Dataset

write.table(FinalDS4, "Tidy_Data_2.txt", row.names= FALSE, sep="\t")

