dotchart
x <- 1:10
y <- x-1
plot(x,y)
dotchart(x,y)


plot(mtcars$mpg)

dotchart(mtcars$mpg, labels=row.names(mtcars), cex=0.7) #x, y축이 바뀐모습

carmpg <- mtcars[order(mtcars$mpg),] #mpg가 작은순서대로 나열
carmpg$cyl <- factor(carmpg$cyl)
class(carmpg$cyl)
carmpg$color[carmpg$cyl==4] <- "blue"
carmpg$color[carmpg$cyl==6] <- "green"
carmpg$color[carmpg$cyl==8]  <- "red"
dotchart(carmpg$mpg, labels=row.names(carmpg),
         groups=carmpg$cyl, cex=0.8, 
         xlab="Miles Per Gallon", color=carmpg$color, main="Milage depending on numbers of cylinder")
