#Downloading data

zip<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(zip, "/Users/Tracy/Desktop/ExData_Project2/NEI_data.zip")
unzip("NEI_data.zip", exdir="/Users/Tracy/Desktop/ExData_Project2/")
NEI<-readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#find coal codes in SCC
index_scc<-grep("Coal", SCC$EI.Sector)

#select only rows in SCC with coal
coal_scc<-slice(SCC, index_scc)

#create df with only the SCC codes for coal
coal_code<-subset(coal_scc[1:2])

#filter NEI for coal codes
nei_coal<-filter(NEI, SCC %in% coal_code$SCC)

rm(NEI)
rm(SCC)

#create plot 4
g<-ggplot(nei_coal, aes(year, Emissions))
plota<-g+geom_point()+geom_smooth(method="lm")+ggtitle("PM2.5 from Coal-combustion")
plotb<-g+geom_point()+geom_smooth(method="lm")+coord_cartesian(ylim=c(0,500))

png(filename="Plot4.png")
plota+plotb
dev.off()