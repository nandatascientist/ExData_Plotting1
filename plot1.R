
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


############## STEP #2: CREATE THE PLOT ON "SCREEN" DEVICE ##############

data$globalactivepower<-as.numeric(data$globalactivepower)
par(mfrow=c(1,1))
hist(data$globalactivepower, col="red", xlab="Global Active Power (kilowatts)", main="Global Active Power")

############## STEP #3: COPY  PLOT TO "PNG FILE" DEVICE ##############

dev.copy(png,file="plot1.png") # copying earlier plot to a file device
dev.off() # closing PNG device
dev.off() # closing screen device

############## STEP #4: REMOVE VARIABLES FROM MEMORY ##############
rm(data,cleanNames,currNames,dataFile,startdate,enddate)

# turn  warnings back on
options(warn=-1)
