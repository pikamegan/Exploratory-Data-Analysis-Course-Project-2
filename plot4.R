#download data and save to "Data" folder
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
zipFile <- "pm25 emissions.zip"


if (!file.exists(zipFile)) {
  download.file(fileUrl, zipFile, mode = "wb")
}
data <- "Data"
if (!file.exists(data)) {
  unzip(zipFile)
}

#read files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#extract data related to coal combustion sources only
coal <- grepl("coal", SCC$EI.Sector, ignore.case=TRUE)
SCC_coal <- SCC[coal,]
coal_NEI <- merge(NEI, SCC_coal, by="SCC")

#get total emissions by year then save it to a data frame
coal_sum <- tapply(coal_NEI$Emissions, coal_NEI$year, sum)
coal_sum <- as.data.frame(coal_sum)
names(coal_sum)[1] <- "Emissions"
rownames(coal_sum) <- c(1:4)
coal_sum$Year <- c(1999, 2002, 2005, 2008)

#plot
png("plot4.png")
ggplot(coal_sum, aes(x=Year, y=Emissions)) +
  geom_line() + geom_point() + xlab("Year") + ylab("Total PM.25 Emissions (tons)") + ggtitle("Total PM2.5 Emissions from Coal Combustion-Related Sources by Year")

dev.off()