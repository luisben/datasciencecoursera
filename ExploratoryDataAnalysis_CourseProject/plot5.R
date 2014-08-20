##How have emissions from motor vehicle sources changed from 1999 2008 in Baltimore City?

library(ggplot2)
#load data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#subset for Baltimore fips and for Mobile* sectors.
NEI <- NEI[(NEI$fips== "24510"),] 
SCC <- SCC[grepl("Mobile",SCC$EI.Sector),c("SCC","EI.Sector")]
##get subset of motor vehicle related SCCs
NEI <- NEI[(NEI$SCC %in% SCC$SCC),]
PMfromMV <- aggregate(NEI$Emissions,by=list(NEI$year),FUN=function(x) round(sum(x)))
colnames(PMfromMV) <- c("Year","Total.Emissions")
PMfromMV$Year <- factor(PMfromMV$Year)
#plot
png("plot5.png",680,680)
p <- qplot(Year,Total.Emissions,data=PMfromMV,geom="blank",ylab="Total Emissions")
p <- p + geom_bar(stat="identity",fill="sienna2")
p
dev.off()