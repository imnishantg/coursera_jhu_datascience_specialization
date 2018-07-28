##### Loading the Dataset #######

EPCnames = read.table("household_power_consumption.txt", header= TRUE, nrows= 10, na.strings= "?", sep = ";")
EPC <- read.table("household_power_consumption.txt", header=TRUE, skip= 66000, nrows= 4000, na.strings= "?", sep = ";")

colnames(EPC) <- names(EPCnames)

EPC$DateTime <- paste(EPC$Date, EPC$Time)
EPC$DateTime <- strptime(EPC$DateTime, "%d/%m/%Y %H:%M:%S")

str(EPC)
table(as.Date(EPC$DateTime))

EPC_new = subset(EPC, as.Date(EPC$DateTime) == "2007-02-01" | as.Date(EPC$DateTime) == "2007-02-02")
EPC_new$Weekdays = weekdays(EPC_new$DateTime)
str(EPC_new)

########## Plot 3 ##########

png("plot3.png", width = 480, height = 480, units = "px",bg = "white")
par()
plot(EPC_new$DateTime, EPC_new$Sub_metering_1, xlab = "", ylab = "Energy sub metering", type="l", col = "black")
lines(EPC_new$DateTime, EPC_new$Sub_metering_2, col = "red")
lines(EPC_new$DateTime, EPC_new$Sub_metering_3, col = "blue")
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c("black", "red", "blue"), lty = 1)

dev.off()

