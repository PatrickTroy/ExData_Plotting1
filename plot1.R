plot1<-function(){
        ##zip file will be downloaded to a temporary file
        temp<-tempfile()
        ##connect to file, store as temporary file.
        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)
        ##load in data. Does not matter that you are using read.csv as you are specifying sep = ";"
        data<-read.csv(unz(temp,"household_power_consumption.txt"),sep = ";",header = TRUE, stringsAsFactors=FALSE,na.strings="?")
        ##disconnect from download
        unlink(temp)
        ##use regular expression to subset the two days you are looking for
        dayof<-data[grepl("^[12$]/2/2007",data$Date,perl=TRUE),]
        ##open file device. It would default to 480x480, but better safe than sorry
        png("plot1.png",width=480,height=480)
        ##simple histogram with a few annotations
        hist(dayof$Global_active_power,12,col="red",xlab = "Global Active Power (kilowatts)",main = "Global Active Power")
        ##close the file device
        dev.off()
}
