x <- "what's is your name?"
x

y <- character()
y
length(y)
y2 <- ""
y2
class(y)
class(y2)
length(y2)

y <- c("e","12","2")
y <- character(10)
y[3] <- "third"
y[12] <- "twelveth"
length(y)
y[11] <- "11"
y

n=3
m="3"
is.character(n)
is.character(m)

class(n)
class(m)

n2 <- as.character(n) #as.character(n)은 n의 값이 character로 변환됨
class(n2)

t <- c(1:5)
t2 <- c(1:5, "a") #형식이 일정해야하므로 전체가 character이 됨
t3 <-  c(1:4,TRUE,FALSE)
class(t3)
class(t2)
t4 <- c(1:4, TRUE, FALSE, "a")
class(t4)


df1 <- data.frame(n=c(1:5,"a"), letters=c("a","b","23","1","4"))
df1
str(df1)
