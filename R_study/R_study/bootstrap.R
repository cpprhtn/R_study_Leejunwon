#자료가 충분하지 않을때 사용

getwd()
light <- read.table("therbook/light.txt",header=T)
light
hist(light$speed, col = "green")
qqnorm(light$speed)
qqline(light$speed,col = "blue")
length(light$speed)

a <- numeric(10000) #10000개의 빈 공간
for(i in 1:10000) a[i] <- mean(sample(light$speed, size = 20, replace = T))
#replace=T 제비뽑기에서 한번뽑고 다시 넣어서 뽑는것


hist(a,col = "blue")
max(a)
