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

#subset NEI for Baltimore
baltimore <- subset(NEI, fips=="24510")

#get total sum of emissions for Baltimore by year
balt_emissions_type <- aggregate(Emissions ~ year + type, baltimore, sum)

#plot
library(ggplot2)

png("plot3.png")
ggplot(balt_emissions_type, aes(x=year, y=Emissions, color=type))+ 
  geom_line() + xlab("Year") + ylab("Total PM2.5 Emissions (tons)") + ggtitle("Total PM2.5 Emissions in Baltimore by Year and Type")

dev.off()
