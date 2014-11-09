# Load downloaded dataset or directly from the website


if(!file.exists("exdata-data-household_power_consumption.zip")){
  temp <- tempfile()
  download.file("http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)
  data <- unzip(temp)
  unlink(temp)
}else{
  data<-unzip("exdata-data-household_power_consumption.zip")}
  

powerconsum <- read.table(data, header=TRUE, sep=";")
powerconsum$Date <- as.Date(powerconsum$Date, format="%d/%m/%Y")

# Select the 2 days (01/02/2007 and 02/02/2007) dataset for plotting

df <- powerconsum[(powerconsum$Date=="2007-02-01") | (powerconsum$Date=="2007-02-02"),]
df$Global_active_power <- as.numeric(as.character(df$Global_active_power))
df$Global_reactive_power <- as.numeric(as.character(df$Global_reactive_power))
df$Voltage <- as.numeric(as.character(df$Voltage))
df <- transform(df, timestamp=as.POSIXct(paste(Date, Time)), "%d/%m/%Y %H:%M:%S")
df$Sub_metering_1 <- as.numeric(as.character(df$Sub_metering_1))
df$Sub_metering_2 <- as.numeric(as.character(df$Sub_metering_2))
df$Sub_metering_3 <- as.numeric(as.character(df$Sub_metering_3))

# Plotting of Plot 2

plot2 <- function() {
  plot(df$timestamp,df$Global_active_power, type="l", xlab="", ylab="Global Active Power (kilowatts)")
  dev.copy(png, file="plot2.png", width=480, height=480)
  dev.off()
  cat("plot2.png has been saved in", getwd())
}
plot2()