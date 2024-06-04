library(dplyr)

#Downloading data

zip<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(zip, "/Users/Tracy/Desktop/ExData_Project2/NEI_data.zip")
unzip("NEI_data.zip", exdir="/Users/Tracy/Desktop/ExData_Project2/")
NEI<-readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")


#Subset for Baltimore
baltimore<-filter(NEI, fips=="24510")


#Calculate total PM 2.5 by year
pm25_baltimore<-baltimore$Emissions
year<-baltimore$year
year<-as.factor(year)

sum_pm25_baltimore<-tapply(pm25_baltimore, year, sum)
sum_pm25_baltimore<-as.data.frame(sum_pm25_baltimore)
sum_pm25_baltimore<-cbind(sum_pm25_baltimore, year=c(1999, 2002, 2005, 2008))
sum_pm25_baltimore<-rename(sum_pm25_baltimore, Total_PM2.5=sum_pm25_baltimore)

#Plot2
png(filename="Plot2.png")
with(sum_pm25_baltimore, plot(year, Total_PM2.5, xlab="Year", ylab="Total PM2.5 Emissions", pch=15, col="purple", cex=2))
title(main="Total PM2.5 Emissions in Baltimore, MD")
dev.off()