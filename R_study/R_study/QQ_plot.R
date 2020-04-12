getwd()
setwd("/Users/cpprhtn/Desktop/R_study")
light <- read.table("therbook/light.txt",header=T)
light
hist(light$speed, col = "green")
summary(light)
boxplot(light)
x <- rnorm(1000)
hist(x)
qqnorm(light$speed)
qqline(light$speed,col= "red")
shapiro.test(light$speed)
shapiro.test(x)

x <- exp(rnorm(1000))
qqnorm(x)
qqline(x, col="red")
#HQ: normally distributed => reject
shapiro.test(x)

#HQ: speed of higth 299 990 km/s => reject
wilcox.test(light$speed,mu=990)

#HQ: speed of higth 299 909 km/s => reject
wilcox.test(light$speed,mu=909)
