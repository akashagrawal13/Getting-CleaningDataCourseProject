#download and unzip files in working directory
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile="run_analysis.zip")
unzip("run_analysis.zip")

#read training and test files
training<-read.table(text=readLines("UCI HAR Dataset/train/X_train.txt"))
testing<-read.table(text=readLines("UCI HAR Dataset/test/X_test.txt"))

#merge using rbind
merged<-rbind(training, testing)

#Print the means and standard deviations of each variable
sapply(merged, mean)
sapply(merged, sd)

#read the activity numbers and then merge them
xlabs<-read.table(text=readLines("UCI HAR Dataset/train/y_train.txt"))
ylabs<-read.table(text=readLines("UCI HAR Dataset/test/y_test.txt"))
labs<-rbind(xlabs, ylabs)

#merge(join) the dataset and activity_labels
activities<-read.table(text=readLines("UCI HAR Dataset/activity_labels.txt"))
labs<-merge(labs, activities, by.x="V1", by.y="V1")
merged<-cbind(merged, labs[,2])

#assign variable names
features<-read.table(text=readLines("UCI HAR Dataset/features.txt"))
features[,2]<-as.character(features[,2])
for(i in 1:561){
    names(merged)[i]=features[i,2]
}
names(merged)[562]="Activites"

#split the dataset by activity label and calculate averages
splitd<-split(merged[,1:561], merged[,562])
for(i in 1:6)
{
    for(j in 1:561)
    {
        means[i,j]=mean(splitd[[i]][[j]])
    }
}

#assign names to variables in new dataset
for(i in 1:561){
    names(means)[i]=features[i,2]
}

#write file
write.table(means, "means.txt", sep="\t")

