
############## STEP #1: READ AND EXTRACT RELEVANT DATA ##############

library(data.table)

# turn off warnings
options(warn=-1)

# filename in working directory
dataFile<-"household_power_consumption.txt" 

# dates to extract
startdate<-as.Date("2/1/2007",format="%m/%d/%Y")
enddate<-as.Date("2/2/2007",format="%m/%d/%Y")

# check if file is in current directory. If not error out.
if(!file.exists(dataFile)){
        
        stop("Required data file not found in  working directory.")
} 


# using data.table instead of data frame for speeding up computation

rawdatatable<-fread(dataFile,na.strings="?",header=TRUE ,sep=";")


#clean-up column names for easy reference
currNames<-names(rawdatatable)
cleanNames<-tolower(gsub("_","",currNames)) # convert to lowercase &  remove "_"

names(rawdatatable)<-cleanNames

# Adding a new col and converting date
rawdatatable$dateCol<-as.Date(rawdatatable$date,format="%d/%m/%Y")

#subsetting the values we need for plots
data<-subset(rawdatatable,
             rawdatatable$dateCol==startdate|rawdatatable$dateCol==enddate)

#getting rid of the big file that we dont need now.
rm(rawdatatable)

# create a timestamp col inside working  dataset 
data$timestamp<-paste(data$date,data$time)
data$timestamp <-as.POSIXct(data$timestamp,format="%d/%m/%Y %H:%M:%S")


############## STEP #2: CREATE THE PLOT ON "PNG FILE" DEVICE ##############


data$submetering1<-as.numeric(data$submetering1)
data$submetering2<-as.numeric(data$submetering2)
data$submetering2<-as.numeric(data$submetering2)

png(file="plot3.png")

par(mfrow=c(1,1))

with(data,plot(timestamp,submetering1, type="n", main="",
               ylab="Energy sub metering",xlab=""))
with(data,lines(timestamp,submetering1,col="black"))
with(data,lines(timestamp,submetering2,col="red"))
with(data,lines(timestamp,submetering3,col="blue"))
legend("topright",pch="__",col= c("black","red","blue"),
       legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))

dev.off() # closing PNG device

## dev.copy() distorts the png file. Therefore, this time around, 
## we have directly written the plot into the  file device

############## STEP #3: REMOVE VARIABLES FROM MEMORY ##############
rm(data,cleanNames,currNames,dataFile,startdate,enddate)

# turn  warnings back on
options(warn=-1)
