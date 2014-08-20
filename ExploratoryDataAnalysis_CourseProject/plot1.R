##Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the base plotting system,
##make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.
#load data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

##aggregate with sum by year
PMbyYear <- aggregate(NEI$Emissions,by=list(NEI$year),FUN=sum)
colnames(PMbyYear) <- c("year","Total.Emissions")

##numbers are divided by 10^4 so the labels are a bit less messy
##a text is added to the top of y axis to indicate the number shown should be multiplied *10^4
png("plot1.png",680,680)
plot(PMbyYear,type="b",lwd=4,col="orange",xlab="Year",ylab="Total Emissions",axes=FALSE)
with(PMbyYear,axis(1,at=year,labels=year))
with(PMbyYear,axis(2,at=Total.Emissions,labels=round(Total.Emissions/10^4),las=2))
loc <- par("usr")
text(loc[1], loc[4], paste("*",expression("10^4")), pos = 3, xpd = T)
dev.off()