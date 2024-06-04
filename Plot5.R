library(dplyr)
library(patchwork)

#Downloading data

zip<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(zip, "/Users/Tracy/Desktop/ExData_Project2/NEI_data.zip")
unzip("NEI_data.zip", exdir="/Users/Tracy/Desktop/ExData_Project2/")
NEI<-readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")


#Subset for Baltimore
baltimore<-filter(NEI, fips=="24510")

#find index for motor vehicles
index_vehicle<-grep("Vehicles", SCC$EI.Sector)

vehicle_scc<-slice(SCC, index_vehicle)
vehicle_code<-subset(vehicle_scc[1])

#filter baltimore dataset for vehicle codes
baltimore_vehicle<-filter(baltimore, SCC %in% vehicle_code$SCC)

##adding ei.sector data to baltimore_vehicle dataframe
ei_sector<-select(vehicle_scc, SCC, EI.Sector)
ei_sector_baltimore<-merge(baltimore_vehicle,ei_sector, by="SCC")


#Creating two plots (one is zoomed to see effects up close)
g<-ggplot(ei_sector_baltimore, aes(year, Emissions))
plota<-g+geom_point(aes(color=factor(EI.Sector)))+ggtitle("Emissions from Motor Vehicle Sources in Baltimore")
plotb<-g+geom_point(aes(color=factor(EI.Sector)))+geom_smooth(aes(color=factor(EI.Sector)))+coord_cartesian(ylim=c(0,10))+theme(legend.position = "none")

png(filename="Plot5.png")
plota/plotb
dev.off()