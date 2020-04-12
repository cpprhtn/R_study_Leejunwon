mtcars
aggregate(mtcars$mpg, by=list(mtcars$cyl), mean)
mean_by_cyl <- function(x){
  if(x==4){
    a <- round(mean(mtcars[which(mtcars$cyl==4),][,1]),2)
    return(paste("The avg mile per gallon of",x, "cylinder car is", a))
  }
  else if(x==6){
    b <- round(mean(mtcars[which(mtcars$cyl==6),][,1]),2)
    return(paste("The avg mile per gallon of",x, "cylinder car is", b))
    }
  else if(x==8){
    c <- round(mean(mtcars[which(mtcars$cyl==8),][,1]),2)
    return(paste("The avg mile per gallon of",x, "cylinder car is", c))
  }
  else{
    print("Wrong number!!!!")
  }
}
mean_by_cyl(6)

mean_by_cyl2 <- function(x){
  mean(mtcars[which(mtcars$cyl==x),][,1])
}
mean_by_cyl2(4)
