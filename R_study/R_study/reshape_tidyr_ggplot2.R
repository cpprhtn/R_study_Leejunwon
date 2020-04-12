getwd()
setwd("/Users/cpprhtn/Desktop/R_study")
raw_df <- read.csv("unemployment_rate.csv",header = T, fileEncoding = 'CP949')
#한글 내용시 인코딩 필요
raw_df
head(raw_df)
summary(raw_df)



#Reshape
library(tidyr)
library(reshape2)
library(ggplot2)
df_m <- melt(raw_df, id.var = c("성별","연령계층별"))
head(df_m)

#Cleaning
df_m$year = substr(df_m$variable,2,5)
df_m$month = substr(df_m$variable,8,9)
df_m$year_month = paste(df_m$year, df_m$month, sep = "-")
df_m$year_month = as.Date(paste(df_m$year_month, "-01",sep = ""))

df_select = df_m[,c("성별", "연령계층별", "year_month", "value")]
summary(df_select)
tail(df_select)


#remove NA rows
#df_cleaned = df_select[complete.cases(df_select),]
df_cleaned = df_select
colnames(df_cleaned) = c("sex", "age_group", "year_month", "value")
levels(df_cleaned$sex)[1]="Total"
levels(df_cleaned$sex)[2]="Male"
levels(df_cleaned$sex)[3]="Female"
levels(df_cleaned$age_group)
df_cleaned$new_age_group = gsub("세|이상", "", df_cleaned$age_group)
df_cleaned$new_age_group = gsub("계", "Total", df_cleaned$new_age_group)
#gsub("x","y",col) x라는 철자를 모두 y로 바꾼다
df_final = df_cleaned[,c("sex","new_age_group","year_month","value")]
head(df_final)

df_20s = df_final[which(df_final$new_age_group=="20 - 29"),]
df_30s = df_final[which(df_final$new_age_group=="30 - 39"),]
df_40s = df_final[which(df_final$new_age_group=="40 - 49"),]
df_50s = df_final[which(df_final$new_age_group=="50 - 59"),]

plotF <- function(df, title){
  ggplot(df, aes(x=year_month, y=value,group=sex,colour=sex))+
    geom_point()+geom_line()+ggtitle(title)
}

plotF(df_20s,"20-29")
plotF(df_30s,"30-39")
plotF(df_40s,"40-49")
plotF(df_50s,"50-59")


ggplot(df_final, aes(x=year_month, y=value, group=sex,colour=sex)) + geom_point() + geom_line()
