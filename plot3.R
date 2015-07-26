## PM2.5 Emissions Data (summarySCC_PM25.rds): This file contains a data frame
## with all of the PM2.5 emissions data for 1999, 2002, 2005, and 2008. For 
## each year, the table contains number of tons of PM2.5 emitted from a 
## specific type of source for the entire year.
##
## Source Classification Code Table (Source_Classification_Code.rds): 
## This table provides a mapping from the SCC digit strings in the Emissions
## table to the actual name of the PM2.5 source.
##
## The overall goal of this assignment is to explore the National Emissions 
## Inventory database and see what it say about fine particulate matter 
## pollution in the United states over the 10-year period 1999–2008.
##
## ASSUMPTION - 'Source_Classification_Code.rds' and 'summarySCC_PM25.rds'
## are available in current-working-directory.
## Author - Sanjeev Kumar Maheve
##
library(dplyr)
library(datasets)
library(ggplot2)
## Have total emissions from PM2.5 decreased in the Baltimore City, Maryland 
## (fips == "24510") from 1999 to 2008? Use the base plotting system to make 
## a plot answering this question.

## remove (almost) everything in the working environment.
## You will get no warning, so don't do this unless you are really sure.
rm(list = ls())
graphics.off()
## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")

# Extract dataset only for Baltimore City, Maryland (fips == "24510")
BaltimoreNEI <- filter(NEI, fips == "24510")

# The group_by() function is used to generate summary statistics 
# from the data frame within strata defined by a variable.
# The general operation here is a combination of splitting a data
# frame into separate pieces defined by a variable or group of 
# variables (group_by()), and then applying a summary function 
# across those subsets (summarize()).
stats <- group_by(BaltimoreNEI, year, type) %>% 
    summarize(emissionsCount = sum(Emissions, na.rm = TRUE))

# ggplot2 allow for complex and sophisticated visualizations of 
# high-dimensional data.
myPlot <- qplot(year, emissionsCount, 
                data = stats, facets = .~type, color='red', 
                ylab = 'Emissions Count', xlab='Year', 
                geom = c("point", "smooth"),
                main = "PM2.5 emission count in Baltimore City, Maryland")
suppressWarnings(print(myPlot + theme_bw(base_family = "Times")))

# Save result to a file
dev.copy(png, file="plot3.png", width=580, height=580)
dev.off()