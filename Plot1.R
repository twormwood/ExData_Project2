library(dplyr)

#Downloading data

zip<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(zip, "/Users/Tracy/Desktop/ExData_Project2/NEI_data.zip")
unzip("NEI_data.zip", exdir="/Users/Tracy/Desktop/ExData_Project2/")
NEI<-readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")


#calculating sum of PM 2.5 for each year in dataset
pm25<-NEI$Emissions
year<-NEI$year
year<-as.factor(year)

sum_pm25<-tapply(pm25, year, sum)
sum_pm25<-as.data.frame(sum_pm25)
sum_pm25<-cbind(sum_pm25, year=c(1999, 2002, 2005, 2008))
sum_pm25<-rename(sum_pm25, Total_PM25=sum_pm25)

#Create plot1
png(filename="Plot1.png")
with(sum_pm25, plot(year, Total_PM25, xlab="Year", ylab="Total PM2.5 Emissions", pch=19, col="green", cex=2))
title(main="Total PM2.5 Emissions in US")
dev.off()