# Sam Lawrance exdata-012
# For marker: all 4 R scripts are self contained.  They will look for the data file
# household_power_consumption.txt under "data/" in the current working directory.  It will
# download and uncompress the file if it does not already exist there.
# The output PNG files are written to the current working directory as well - typically either
# your home directory on OSX/Linux or (I guess) your user directory under windows, unless you set
# it otherwise beforehand.

# Check if data file exists under data/ in current working directory.  If not, download and unzip it.
if (!file.exists("data/household_power_consumption.txt"))
{
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
                destfile="household_power_consumption.zip",
                method="curl")
  unzip("household_power_consumption.zip", exdir="data")
}

# Read the power data file.  ? is replaced with nulls.  Column types are specified
# explicitly; dates and times are sorted out below.
powerData <- read.csv("data/household_power_consumption.txt",
                      sep=";", 
                      colClasses=c("character", "character", rep("numeric", 7)),
                      na.strings="?")

# Create a POSIXlt date field, and replace the existing character date field with a Date class.
powerData$DateTime <- as.POSIXlt(paste(powerData$Date, powerData$Time), format="%d/%m/%Y %H:%M:%S")
powerData$Date <- as.Date(powerData$Date, "%d/%m/%Y")

# Only want 1-2 Feb 2007.
powerData <- subset(powerData, (powerData$Date == "2007-02-01" | powerData$Date == "2007-02-02"))

# Write to plot4.png.  Create a 4-up view with plots of active power, voltage, sub metering values, and
# reactive power over the sample time period.
png(filename="plot4.png")
par(mfrow=c(2,2), mar=c(4,4,2,2))
plot(powerData$DateTime, powerData$Global_active_power, xlab="", ylab="Global Active Power", type="l")
plot(powerData$DateTime, powerData$Voltage, xlab="datetime", ylab="Voltage", type="l")
plot(powerData$DateTime, powerData$Sub_metering_1, 
     xlab="", ylab="Energy sub metering", type="n")
lines(powerData$DateTime, powerData$Sub_metering_1)
lines(powerData$DateTime, powerData$Sub_metering_2, col="red")
lines(powerData$DateTime, powerData$Sub_metering_3, col="blue")
legend("topright", 
       col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       lty=c(1, 1, 1))
plot(powerData$DateTime, powerData$Global_reactive_power, xlab="datetime", ylab="Global_reactive_power", type="l")
dev.off()
