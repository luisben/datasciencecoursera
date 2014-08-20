##Across the United States, how have emissions from coal combustion related sources changed from 1999 2008?
library(ggplot2)
#load data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

##get subset of coal combustion related SCCs
##two grep searches are done, first one checks the Sector name for "coal" string
##second checks the short name for "coal" string AND at least one of (fuel,burn,fire) strings
##this way things like "[...]coal-fired" or "Fuel Use [...] Coal" show up, while
##things like "Coal Mining" are excluded (as they are not combustion sources)
strings_of_interest <- c("Fuel","Burn","fire")
short_name_regexp <- paste(strings_of_interest,collapse="|")
SCC <- SCC[(grepl("Coal",SCC$EI.Sector,ignore.case=TRUE) |
                    (grepl("Coal",SCC$Short.Name,ignore.case=TRUE) & 
                     grepl(short_name_regexp,SCC$Short.Name,ignore.case=TRUE)))
                 ,c("SCC","EI.Sector","Short.Name")]
NEI <- NEI[NEI$SCC %in% (SCC$SCC),c("SCC","Emissions","year")]

##some bit of cleaning
SCC$EI.Sector <- factor(SCC$EI.Sector)
SCC$Short.Name <- factor(SCC$Short.Name)

merged_NEI <- merge(NEI,SCC,by=c("SCC"))
merged_NEI$year <- factor(merged_NEI$year)

##the sum is done grouping by sectors, as grouping by individual activity name 
##would result in hundreds of values mapped EI.Sector gives a good enough level of information
CoalPMBySectorAndYear <- aggregate(merged_NEI$Emissions,
                                   by=list(merged_NEI$EI.Sector,merged_NEI$year)
                                   ,FUN=sum)
colnames(CoalPMBySectorAndYear) <- c("Sector","Year","Total.Emissions")
##plot 
##each plot has independent scaling. this because the values for emission vary greatly
##among sectors. a bar plot is chosen to make it easier to see changes from year to year 
## in the small plots.
png("plot4.png",680,680)
p <- qplot(Year,Total.Emissions,data=CoalPMBySectorAndYear,fill=Year,ylab="Total Emissions",geom="blank") 
p <- p + facet_wrap(~Sector,nrow=5,ncol=2,scales="free")
p <- p + geom_bar(stat="identity")
p <- p + theme(strip.text.x = element_text(size = 9))
p
dev.off()