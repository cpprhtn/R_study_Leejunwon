setwd("/Users/cpprhtn/Desktop/R_study")
f.test.data <- read.table("therbook/f.test.data.txt",header = T)
f.test.data

var(f.test.data$gardenB)
var(f.test.data$gardenC)

hist(f.test.data$gardenB)
hist(f.test.data$gardenC)

attach(f.test.data)
F.ratio = var(gardenC)/var(gardenB)
F.ratio
summary(f.test.data)
pf(F.ratio,9,9) #자유도 %퍼센테이지
qf(0.9991879,9,9) #편차
2*(1- pf(F.ratio,9,9))


var.test(gardenB,gardenC)
