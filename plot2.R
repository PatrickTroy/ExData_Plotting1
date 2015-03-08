plot2<-function(){
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
        ##The date and time come formatted as characters in two different columns.
        ##The following step gives you a column with a specific time during a specific day.
        dayof2<-mutate(dayof,DateTime = as.POSIXct(paste(as.Date(dayof$Date,format = "%d/%m/%Y"),dayof$Time)))
        ##Selecting out the data I want.
        dataforplot<-select(dayof2,DateTime,Global_active_power)
        ##Opening the file device. Again, unnecessarily setting height.
        png("plot2.png", width = 480, height = 480)
        ##specify type = "l" for line graph, and label y-axis.
        with(dataforplot,plot(DateTime,Global_active_power,type="l",xlab = "",ylab = "Global Active Power (kilowatts)"))
        ##close the file device.
        dev.off()
}