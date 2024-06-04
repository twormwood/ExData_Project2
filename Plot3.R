library(dplyr)
library(ggplot2)
library(data.table)

#Downloading data

zip<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(zip, "/Users/Tracy/Desktop/ExData_Project2/NEI_data.zip")
unzip("NEI_data.zip", exdir="/Users/Tracy/Desktop/ExData_Project2/")
NEI<-readRDS("summarySCC_PM25.rds")

rm(zip)

pm25<-NEI$Emissions
year<-NEI$year
type<-as.factor(NEI$type)

dt<-data.table(pm25, year, type)

rm(NEI)

non_road<-filter(dt, type=="NON-ROAD")
nonpoint<-filter(dt, type=="NONPOINT")
on_road<-filter(dt, type=="ON-ROAD")
point<-filter(dt, type=="POINT")

rm(dt)

#Plot 3
non_road_g<-ggplot(data=non_road, aes(year, pm25))
non_road_plot<-non_road_g+geom_smooth(method="lm")+ggtitle("Non-Road Type")

nonpoint_g<-ggplot(data=nonpoint, aes(year, pm25))
nonpoint_plot<-nonpoint_g+geom_smooth(method="lm")+ggtitle("Non-Point Type")

on_road_g<-ggplot(data=on_road, aes(year, pm25))
on_road_plot<-on_road_g+geom_smooth(method="lm")+ggtitle("On-Road Type")

point_g<-ggplot(data=point, aes(year, pm25))
point_plot<-point_g+geom_smooth(method="lm")+ggtitle("Point Type")


install.packages("patchwork")
library(patchwork)

png(filename = "Plot3.png")
non_road_plot+nonpoint_plot+on_road_plot+point_plot
dev.off()



##Another way to map it by finding the sum of each type/year (Plot3extra.png)
NEI<-readRDS("summarySCC_PM25.rds")
pm25<-NEI$Emissions
year<-NEI$year
type<-as.factor(NEI$type)
 
dt<-data.table(pm25, year, type)
 
rm(NEI)
rm(pm25, year, type)

sum_type<-with(dt, tapply(pm25, list(year, type), FUN=sum))
sum_type<-as.data.frame(sum_type)
sum_type<-cbind(sum_type, year=c(1999, 2002, 2005, 2008))
melt_type<-melt(sum_type, id="year")
gg<-ggplot(melt_type, aes(year, value))
gg+geom_point(aes(color=variable))+ggtitle("Sum of PM2.5 by year and variable type")

png(filename="Plot3extra.png")
gg+geom_point(aes(color=variable))+ggtitle("Sum of PM2.5 by year and variable type")
dev.off()