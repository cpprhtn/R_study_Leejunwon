# sum of two dice
roll <- 10000
dice <- ceiling(runif(roll)*6) + ceiling(runif(roll)*6) + ceiling(runif(roll)*6)
a <- table(dice)
barplot(a)
a
table(a[1])
a[1]*6-a[6]
