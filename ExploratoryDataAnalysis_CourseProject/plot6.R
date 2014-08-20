##Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in 
##Los Angeles County, 
##California (fips == "06037"). Which city has seen greater changes over time in motor vehicle emissions?

library(ggplot2)
#load data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#subset for Baltimore and Los Angeles and mobile* sectors.
NEI <- NEI[(NEI$fips %in% c("24510","06037")),] 
SCC <- SCC[grepl("Mobile",SCC$EI.Sector),c("SCC","EI.Sector")]
##get subset of motor vehicle related SCCs
NEI <- NEI[(NEI$SCC %in% SCC$SCC),]
PMfromMV <- aggregate(NEI$Emissions,by=list(NEI$fips,NEI$year),FUN=function(x) round(sum(x)))
colnames(PMfromMV) <- c("City","Year","Total.Emissions")

PMfromMV$City <- factor(PMfromMV$City,labels=c("Baltimore","Los Angeles"),levels=c("24510","06037"))

png("plot6.png",680,680)
p <- qplot(Year,Total.Emissions,data=PMfromMV,geom="blank",col=City,ylab="Total Emissions")
p <- p + geom_line(size=1.3) + facet_wrap(~City,scales="free_y")
p
dev.off()