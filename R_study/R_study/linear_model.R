year <- c(2000, 2001, 2002, 2003, 2004)
value <- c(2.3,3.2,4.6,5.4,5.8)
plot(year, value,xlim= c(2000,2020),ylim = c(0,20))

fit <- lm(value ~ year)
abline(fit, col="red")

fit$coefficients[[2]]

fit$residuals
summary(fit) 

#구분법
#*별표가 많이 있을때 정확도 up
#p-value가 0.05이하일때 정확도 up
