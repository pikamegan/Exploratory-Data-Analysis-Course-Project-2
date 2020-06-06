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

#extract data related to motor vehicle sources only
mv <- grepl("vehicle", SCC$EI.Sector, ignore.case=TRUE)
SCC_mv <- SCC[mv,]
mv_NEI <- merge(NEI, SCC_mv, by="SCC")

#subset motor vehicles in NEI for Baltimore and Los Angeles
baltimore_la <- subset(mv_NEI, fips=="24510" | fips=="06037")
baltimore_la$city <- ifelse(baltimore_la$fips=="24510", "Baltimore", "Los Angeles")

#get total sum of motor vehicle emissions for Baltimore and Los Angeles by year
Emissions <- aggregate(Emissions ~ year + city, baltimore_la, sum)


#plot
library(ggplot2)

png("plot6.png", width=500, height=480)
ggplot(Emissions, aes(x=year, y=Emissions, color=city)) +
  geom_line() + geom_point() + xlab("Year") + ylab("Total PM.25 Emissions (tons)") + ggtitle("Total Motor Vehicle Sources PM2.5 Emissions in Baltimore vs. Los Angeles")

dev.off()
