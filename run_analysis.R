library("plyr")

# Merge the training and test sets to create one data set
tempdataA <- read.table("train/X_train.txt")
tempdataB <- read.table("test/X_test.txt")
X <- rbind(tempdataA, tempdataB)

tempdataC <- read.table("train/y_train.txt")
tempdataD <- read.table("test/y_test.txt")
Y <- rbind(tempdataC, tempdataD)

tempdataE <- read.table("train/subject_train.txt")
tempdataF <- read.table("test/subject_test.txt")
Z <- rbind(tempdataE, tempdataF)

# Extract only the measurements on the mean and standard deviation for each measurement
features <- read.table("features.txt")
indices <- grep("-(mean|std)\\(\\)", features[, 2])
X <- X[, indices]
names(X) <- features[indices, 2]
names(X) <- gsub("\\(|\\)", "", names(X))
names(X) <- tolower(names(X))

# Use descriptive activity names to name the activities in the data set.
activities <- read.table("activity_labels.txt")
activities[, 2] = gsub("_", "", tolower(as.character(activities[, 2])))
Y[,1] = activities[Y[,1], 2]
names(Y) <- "activity"
names(Z) <- "subject"

# bind all the data in a single data set
all <- cbind(X, Y, Z)

# Create a second, independent tidy data set
sum_data <- ddply(all, .(subject, activity), function(x) colMeans(x[, 1:66]))
write.table(sum_data, "averages.txt")