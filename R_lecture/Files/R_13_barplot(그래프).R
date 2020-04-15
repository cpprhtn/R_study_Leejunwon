BOD
#먼저 plot으로 시각화 해봅시다.
plot(BOD)
#더 직관적으로 바꾸어봅시다.
plot(BOD,type="l",col="red",ylim=c(0,20),
     main = "Number of demand over time")
#이번에는 막대 그래프를 사용해봅시다.
barplot(BOD$demand)
#그래프에 정보가 부족하다. 더 채워보자.
barplot(BOD$demand, names.arg = BOD$Time)
#names.arg : 막대나 막대그룹에 이름을 지정해준다.
#여기서는 BOD의 Time값을 이름으로 지정해준다.
par(mfrow=c(1,2))

#나머지 정보도 채워주자.
barplot(BOD$demand, names.arg = BOD$Time,
        main = "Number of demand over time",
        xlab = "Time",ylab = "Demand", ylim = c(0,20),
        col = "light blue", border = "blue") #border은 막대그래프의 태두리 색을 의미


#이번에는 mtcars의 cyl항목을 시각화 하려고 한다.
mtcars
plot(mtcars$cyl)
dotchart(mtcars$cyl)
barplot(mtcars$cyl)
#3개의 자료중 barplot만 사용이 가능한 수준이다. 
#barplot를 이용하여 직관적으로 수정해보자.
barplot(mtcars$cyl,names.arg = mtcars$cyl)
#4,6,8 이 세가지 값만 반복해서 나온다.
#이를 압축해보자.
table(mtcars$cyl)
4  6  8  <- cyl 종류 
11  7 14 <- cyl의 빈도수 

barplot(table(mtcars$cyl), main = "The number of each cyl")


#이처럼 그래프는 상황에 맞게 선택하여 사용해야한다.
# 한 자료에 대해, 다양한 방법으로 시각화하는 연습이 중요하다.