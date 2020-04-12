install.packages("MASS")
library(MASS)
data(Aids2)
Aids2
str(Aids2)
head(Aids2)
summary(Aids2)
Aids2[which(Aids2$age==0),]

Alive <- Aids2[which(Aids2$status=="A"),]
Dead <- Aids2[which(Aids2$status=="D"),]
aggregate(Alive$age, by=list(Alive$sex),mean)
#aggregate(궁금한자료,분류기준, 표시할 값)
aggregate(Dead$age, by=list(Dead$sex),mean)

aggregate(Aids2$age, by=list(Aids2$sex, Aids2$status), mean)
