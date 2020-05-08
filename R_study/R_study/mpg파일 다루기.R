setwd("/Users/cpprhtn/Desktop")
read.csv("mpg.csv",header = T,fileEncoding = "CP949") -> mpgdata
head(mpgdata)
hist(mpgdata$hwy)
max(mpgdata$cty,na.rm = T)
max(mpgdata$cty)
mpgdata$manufacturer[max(mpgdata$cty)]
summary(mpgdata$hwy)
max(mpgdata$cty) -> hi
boxplot(mpgdata$cty~mpgdata$drv,data = mpgdata)
install.packages("outliers")
library(outliers)
outlier(mpgdata$hwy)
prop.table(table(mpgdata$cyl))
pie(table(mpgdata$drv))
sub <- mpgdata[,c("displ","cty","hwy")]
cor(sub)
summary(sub)
sd(sub$displ)
plot(sub$displ,sub$cty)
