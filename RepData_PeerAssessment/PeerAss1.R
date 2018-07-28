activity = read.csv("./DataScienceSp/Reproducible_Research/PeerAss/activity.csv")

activity$date <- strptime(activity$date, "%Y-%m-%d")
activity_woNA = na.omit(activity)


library(plyr)

Totalperday <- ddply(activity_woNA, .(date), summarise, steps=sum(steps))
hist(Totalperday$steps, main="Total No. of Steps", xlab="Total no. of steps/day", col="red")


mean(Totalperday$steps)
median(Totalperday$steps)


AverageByInterval <- ddply(activity_woNA, .(interval), summarise, steps=mean(steps))

plot(AverageByInterval$interval, AverageByInterval$steps, type="l", col="black", xlab="5-min Interval", 
     ylab="Avg number of steps taken", main="Average daily activity pattern")


AverageByInterval$interval[which.max(AverageByInterval$steps)]


AverageByInterval$AvgSteps = AverageByInterval$steps
AverageByInterval$steps = NULL

sum(is.na(activity$steps))

# Fill NA's with mean of the corresponding 5-min interval
mergeAct <- arrange(join(activity, AverageByInterval), interval)

# Create a new dataset that is equal to the original dataset but with the missing data filled in.
mergeAct$steps[is.na(mergeAct$steps)] <- mergeAct$AvgSteps[is.na(mergeAct$steps)]

# Histogram
TotalPerDay_2 <- ddply(mergeAct, .(date), summarise, steps=sum(steps))


hist(TotalPerDay_2$steps, main="Number of Steps", xlab="Total number of steps taken each day", col="green")

# mean and median total number of steps taken per day
mean(TotalPerDay_2$steps)
median(TotalPerDay_2$steps)

totSteps_1 <- sum(activity_woNA$steps)
totSteps_2 <- sum(mergeAct$steps)
totSteps_2 - totSteps_1





library(lattice)
weekdays <- weekdays(as.Date(mergeAct$date))

weekdayData <- transform(mergeAct, day=weekdays)
weekdayData$wk <- ifelse(weekdayData$day %in% c("Saturday", "Sunday"),"weekend", "weekday")

Avgwkday <- ddply(weekdayData, .(interval, wk), summarise, steps=mean(steps))

xyplot(steps ~ interval | wk, data = Avgwkday, layout = c(1, 2), type="l")


