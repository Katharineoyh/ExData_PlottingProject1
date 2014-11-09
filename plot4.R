# Load downloaded dataset or directly from the website

install.packages("unzip")

if(!file.exists("exdata-data-household_power_consumption.zip")){
  temp <- tempfile()  #Create a temp. file name e.g. tempfile()
  
  #Use download.file() to fetch the file into the temp. file
  download.file("http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)
  data <- unzip(temp) # Use unz() or unnzip()to extract the target file from temp. file
  unlink(temp) # Remove the temp file via unlink()
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

# Plotting of Plot 4 (Four sub-graphs)

plot4 <- function() {
  par(mfrow=c(2,2))
  
  ##PLOT 1
  plot(df$timestamp,df$Global_active_power, type="l", xlab="", ylab="Global Active Power")
  ##PLOT 2
  plot(df$timestamp,df$Voltage, type="l", xlab="datetime", ylab="Voltage")
  
  ##PLOT 3
  plot(df$timestamp,df$Sub_metering_1, type="l", xlab="", ylab="Energy sub metering")
  lines(df$timestamp,df$Sub_metering_2,col="red")
  lines(df$timestamp,df$Sub_metering_3,col="blue")
  legend("topright", inset=-0.18,col=c("black","red","blue"), 
         c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"),
         lty=c(1,1), bty="n", cex=.8, y.intersp=0.15) 
  #inset further adjust the position of the legend box
  #bty removes the box, cex shrinks the text,y.intersp set the space between the lines
  
  #PLOT 4
  plot(df$timestamp,df$Global_reactive_power, type="l", xlab="datetime", ylab="Global_reactive_power")
  
  #OUTPUT
  dev.copy(png, file="plot4.png", width=480, height=480)
  dev.off()
  cat("plot4.png has been saved in", getwd())
}
plot4()