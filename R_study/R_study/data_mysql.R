#mysql버전

#mysql -uroot -p
#install.packages("RMySQL")
#library(RMySQL)
#mydb <- dbConnect(MySQL(), user='root', password='5553', dbname='sampdb')
#result <- dbGetQuery(mydb, 'show tables;')
#dbGetQuery(mydb, 'select count(*) from president;')
#tbl <- dbGetQuery(mydb, 'select * from president;')


#file.load
getwd()
setwd("/Users/cpprhtn/Desktop/R_study")
sampdb <- read.table("sampdb/president.txt",header=FALSE, sep="\t")
sampdb$name <- paste(sampdb$V1, sampdb$V2, sampdb$V3)
#sampdb$city <- sampdb$V4
sampdb
newdf <- sampdb[(c(8,4:7))] 
newdf$name <- gsub(' \\N','',newdf$name)
newdf
str(newdf)
newdf$V6 <- as.Date(newdf$V6)
newdf$V7 <- as.Date(newdf$V6)
str(newdf)
summary(newdf)
newdf$city <- newdf$V4
newdf$state <- newdf$V5
newdf$birth <- newdf$V6
newdf$death <- newdf$V7
newdb <- newdf[(c(1,6:9))]
newdb
str(newdb)
summary(newdb)
