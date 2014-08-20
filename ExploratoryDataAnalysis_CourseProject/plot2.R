##Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008? 
##Use the base plotting system to make a plot answering this question.
#load data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

##subset and aggregate
NEI <- NEI[(NEI$fips== "24510"),] 
PMbyYear <- aggregate(NEI$Emissions,by=list(NEI$year),FUN=sum)
colnames(PMbyYear) <- c("year","Total.Emissions")

#plot
png("plot2.png",680,680)
plot(PMbyYear,type="b",lwd=4,col="orange",xlab="Year",ylab="Total Emissions",axes=FALSE)
with(PMbyYear,axis(1,at=year,labels=year))
with(PMbyYear,axis(2,at=Total.Emissions,labels=round(Total.Emissions),las=2))
dev.off()