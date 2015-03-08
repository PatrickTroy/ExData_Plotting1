plot3<-function(){
        ##I chose use dplyr to mutate and select data for the remaining plots.
        ##Most R users will have dplyr, but if it isn't installed or loaded, the script will take care of that.
        require(dplyr)
        ##zip file will be downloaded to a temporary file
        temp<-tempfile()
        ##connect to file, store as temporary file.
        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)
        ##load in data. Does not matter that you are using read.csv as you are specifying sep = ";"
        data<-read.csv(unz(temp,"household_power_consumption.txt"),sep = ";",header = TRUE, stringsAsFactors=FALSE,na.strings="?")
        ##disconnect from download
        unlink(temp)
        ##Use regular expression to subset out the two days in question
        dayof<-data[grepl("^[12$]/2/2007",data$Date,perl=TRUE),]
        ##Use dplyr to add a column that is only the datetime in standard formatting based on how it originally read.
        dayof2<-mutate(dayof,DateTime = as.POSIXct(paste(as.Date(dayof$Date,format = "%d/%m/%Y"),dayof$Time)))
        ##Select data for three different lines.
        dataforplot<-select(dayof2,DateTime,Sub_metering_1,Sub_metering_2,Sub_metering_3)
        #Open graphics device, specifying the requested size.
        png("plot3.png", width = 480, height = 480)
        ##First plotting the data for Sub_metering_1 in black, and then adding other two in.
        with(dataforplot,{
             plot(DateTime,Sub_metering_1,type="l",col = "black",xlab = "",ylab = "Energy sub metering")
             lines(DateTime,Sub_metering_2,type="l",col = "red",xlab = "",ylab = "Energy sub metering")
             lines(DateTime,Sub_metering_3,type="l",col = "blue",xlab = "",ylab = "Energy sub metering")
             ##add in legend. lty = 1 is how you make the lines show up next to the items in legend.
             legend("topright",lty=1,col = c("black","red","blue"),legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
             })
        ##close the file device
        dev.off()
}