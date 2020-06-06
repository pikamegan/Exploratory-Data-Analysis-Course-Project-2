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
balt_emissions <- tapply(baltimore$Emissions, baltimore$year, sum)

#plot
png("plot2.png")
barplot(balt_emissions, xlab="Year", ylab="PM2.5 Emissions (tons)", main="Total PM2.5 Emissions in Baltimore by Year", ylim=c(0, 3500))

dev.off()
