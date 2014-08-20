##Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources 
##have seen decreases in emissions from 1999 to 2008 for Baltimore City? Which have seen increases in emissions from 
## 1999 to 2008? 
##Use the ggplot2 plotting system to make a plot answer this question.
library(ggplot2)
#load data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

##subset and aggregate
NEI <- NEI[(NEI$fips== "24510"),] 
PMbyTypeAndYear <- aggregate(NEI$Emissions,by=list(NEI$type,NEI$year),FUN=sum)
colnames(PMbyTypeAndYear) <- c("Type","Year","Total.Emissions")
png("plot3.png",680,680)
qplot(Year,Total.Emissions,data=PMbyTypeAndYear,col=Type,ylab="Total Emissions") + geom_line(size=1.3)
dev.off()