install.packages("neuralnet")
library(neuralnet)

#데이터 수집
x <- c(1:100)
y <- x*x*x #x 3승의 그래프
plot(x,y)

#정규화
x.max <- max(df[,1])
y.max <- max(df[,2])
df[,1] <- df[,1]/x.max
df[,2] <- df[,2]/y.max
df <- data.frame(x,y)
#테스트 데이터세트 생성
index <- sample(1:100,80) #표본에서 80%의 데이터 추출
index
train <- df[index,] #100개의 표본에서 80개 추출한 데이터
test <- df[-index,] #나머지 20개 추출한 데이터

#트레이닝
nn <- neuralnet(y ~ x, data = train, hidden = 0,
                   linear.output =T)
nn
plot(nn$data$x,nn$data$y)
pred <- compute(nn$data$x,test$x)
