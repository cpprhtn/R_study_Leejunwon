#dnorm 점의 위치 표시
#pnorm 넓이 퍼센트
#qnorm x값 표시
#rnorm 랜덤값 생성

x <- seq(40,120,length=300) #40~120까지를 300분할
y <- dnorm(x,mean=80,sd=10)
y
plot(x,y,type = "l",col="red")
lines(x,dnorm(x,mean=80,sd=20),col="blue")

#65~75사이의 범위가 전체의 몇 퍼센트인가?
x2 <- seq(65,75,length=300)
y2 <- dnorm(x2, mean=80,sd=10)
polygon(c(65,x2,75),c(0,y2,0),col="gray")

pnorm(75 ,mean=80,sd=10) - pnorm(65,mean=80,sd=10)

#92점을 넘을 확률?
pnorm(92,mean=80,sd=10,lower.tail = FALSE) #lower.tail은 왼쪽부터 계산,false를 해줘야 오른쪽의 넓이

1-pnorm(92,mean=80,sd=10)
x3 <- seq(92,120,length=300)
y3 <- dnorm(x3,mean=80, sd=10)
polygon(c(92,x3,120),c(0,y3,0),col="green")

#68점 이하일 확률?
pnorm(68,mean=80,sd=10)
x4 <- seq(40,68,length=200)
y4 <- dnorm(x4,mean=80,sd=10)
polygon(c(40,x4,68),c(0,y4,0),col="purple")

#30%를 차지하는 x값?
qnorm(0.3, mean=80,sd=10)

#중간 60%를 차지하는 값?
-80+qnorm(0.8, mean=80,sd=10)
80-qnorm(0.2, mean=80,sd=10)
