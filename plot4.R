plot4<-function(){
        ##I chose use dplyr to mutate and select data for the remaining plots.
        ##Most R users will have dplyr, but if it isn't installed or loaded, the script will take care of that.
        require(dplyr)
        ##zip file will be downloaded to a temporary file
        ##I chose not to create a directory or check for a directory because of the tempfile.
        temp<-tempfile()
        ##connect to file, store as temporary file.
        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)
        ##load in data. Does not matter that you are using read.csv as you are specifying sep = ";"
        data<-read.csv(unz(temp,"household_power_consumption.txt"),sep = ";",header = TRUE, stringsAsFactors=FALSE,na.strings="?")
        ##disconnect from download
        unlink(temp)
        ##Use regular expression to subset out the two days in question
        dayof<-data[grepl("^[12$]/2/2007",data$Date,perl=TRUE),]
        ##Create a datetime column using as.POSIXct to recognize and rearrange date and time info.
        dayof2<-mutate(dayof,DateTime = as.POSIXct(paste(as.Date(dayof$Date,format = "%d/%m/%Y"),dayof$Time)))
        ##create data for each plot. This wasn't necessary for the earlier plots, 
        ##but it makes things much simpler with four graphs to keep track of.
        dataforplot1<-select(dayof2,DateTime,Global_active_power)
        dataforplot2<-select(dayof2,DateTime,Sub_metering_1,Sub_metering_2,Sub_metering_3)
        dataforplot3<-select(dayof2,DateTime,Voltage)
        dataforplot4<-select(dayof2,DateTime,Global_reactive_power)
        ##Open file device.
        png("plot4.png", width = 480, height = 480)
        ##specify a square grid of 4 plots. These will fill column-wise
        par(mfcol = c(2,2))
        with(dataforplot1,plot(DateTime,Global_active_power,type="l",xlab = "",ylab = "Global Active Power (kilowatts)"))
                
        with(dataforplot2,{
                plot(DateTime,Sub_metering_1,type="l",col = "black",xlab = "",ylab = "Energy sub metering")
                lines(DateTime,Sub_metering_2,type="l",col = "red",xlab = "",ylab = "Energy sub metering")
                lines(DateTime,Sub_metering_3,type="l",col = "blue",xlab = "",ylab = "Energy sub metering")
                ##change from before: bty = "n" removes the box around the legend.
                legend("topright",lty=1,bty = "n",col = c("black","red","blue"),legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
        })
        ##simple line graph of Voltage over time.
        with(dataforplot3,plot(DateTime, Voltage, type = "l",xlab = "datetime",ylab = "Voltage"))
        ##simple line graph of Global_reactive_power over time
        with(dataforplot4,plot(DateTime,Global_reactive_power, type = "l", xlab = "datetime",ylab = "Global_reactive_power"))
        dev.off()
}

##I appreciate any constructive comments you may have!