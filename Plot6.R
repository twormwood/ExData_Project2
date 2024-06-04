library(dplyr)
library(patchwork)
library(ggplot2)

#Downloading data

zip<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(zip, "/Users/Tracy/Desktop/ExData_Project2/NEI_data.zip")
unzip("NEI_data.zip", exdir="/Users/Tracy/Desktop/ExData_Project2/")
NEI<-readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")


#Subset for Baltimore
baltimore<-filter(NEI, fips=="24510")
baltimore<-cbind(baltimore, data="Baltimore")
#Subset for LA
la<-filter(NEI, fips=="06037")
la<-cbind(la,data="Los Angeles")

rm(NEI)
#combine the two subsets
baltimore_la<-rbind(baltimore, la)
baltimore_la<-rename(baltimore_la, City=data)

#find index for motor vehicles
index_vehicle<-grep("Vehicles", SCC$EI.Sector)

vehicle_scc<-slice(SCC, index_vehicle)
vehicle_code<-subset(vehicle_scc[1])

#filter baltimore_la dataset for vehicle codes
baltimore_la_vehicle<-filter(baltimore_la, SCC %in% vehicle_code$SCC)

##adding ei.sector data to baltimore_vehicle dataframe
ei_sector<-select(vehicle_scc, SCC, EI.Sector)
ei_sector_ba_la<-merge(baltimore_la_vehicle,ei_sector, by="SCC")

##Make plots
g<-ggplot(ei_sector_ba_la, aes(year, Emissions))
plota<-g+geom_point(aes(color=factor(City)))+geom_smooth(method="lm", aes(color=factor(City)))+coord_cartesian(ylim=c(0,200))+ggtitle("Total Vehicle Emissions between Baltimore and LA")

b<-ggplot(ei_sector_ba_la[ei_sector_ba_la$City=="Baltimore",], aes(year, Emissions))
plotb<-b+geom_point(aes(color=factor(EI.Sector)))+geom_smooth(aes(color=factor(EI.Sector)))+ggtitle("Emissions by EI Sector in Baltimore")+coord_cartesian(ylim=c(0,25))

c<-ggplot(ei_sector_ba_la[ei_sector_ba_la$City=="Los Angeles",], aes(year, Emissions))
plotc<-c+geom_point(aes(color=factor(EI.Sector)))+geom_smooth(aes(color=factor(EI.Sector)))+ggtitle("Emissions by EI Sector in Los Angeles")+coord_cartesian(ylim=c(0,250))+theme(legend.position = "none")

png(filename = "Plot6.png", width=960, height=480)
plota/(plotb|plotc)
dev.off()
