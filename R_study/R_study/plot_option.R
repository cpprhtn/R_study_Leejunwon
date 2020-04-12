x <- c(1:10)
y <- x^2-x+10
par(mfrow=c(2,4))
types=c("p","l","o","b","c","s","S","h")
for(i in 1:8){
  plot(x,y,type = types[i], col="blue",pch=i)
}
