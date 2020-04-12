# uniform distribution sumulate
# p = 1/n, n of die=6
roll <- 100000
n <- 6
die <- ceiling(runif(roll)*n) #ceiling_반올림 runif_랜덤
b <- table(die)
barplot(b) #막대그래프