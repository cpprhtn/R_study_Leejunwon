year <- c(2000, 2001, 2002, 2003, 2004)
value <- c(2.3,3.2,4.6,5.4,5.8)
plot(year, value)
fit <- lm(value ~ year)
abline(fit, col="red")
fit$coefficients[[2]]
fit$residuals
summary(fit) 
par(mfrow = c(2,2))
plot(fit)



x=c(1:10)
y=c(2,3,4,5,6,0,2,3,4,5)
plot(x,y)
fit <- lm(y ~ x)
abline(fit, col='red')
summary(fit)
par(mfrow= c(2,2))
plot(fit)
# 좋은 모델이 아님



#iris(난제)
data(iris)
head(iris)

length = iris[which(iris$Species == "setosa"),]$Sepal.Length
width = iris[which(iris$Species == "setosa"),]$Sepal.Width
par(mfrow= c(1,2))
plot(length, width,col = "blue")
plot(jitter(length), width,col = "blue")
fit <- lm(width ~ length)
abline(fit,col = "yellow")
par(mfrow= c(2,2))
plot(fit)
par(mfrow=c(1,1))
boxplot(width)
#42번째 값이 떨어져 나옴


length_new = length[-42]
width_new = width[-42]
boxplot(width_new)
#42번째 값 제거후
par(mfrow= c(1,2))
plot(length, width,col = "blue")
plot(jitter(length_new), width_new,col = "blue")

fit <- lm(width_new ~ length_new)
abline(fit, col="red")
par(mfrow= c(2,2))
plot(fit)



x=c(1:5,7:10)
y=c(2,1,4,3,12,5,8,7,9)
z=c(2,1,4,3,12,5,8,7,10)
plot(x,y)
fit <- lm(z ~ y)
abline(fit, col="red")
summary(fit)
par(mfrow= c(2,2))
plot(fit)

