mtcars$mpg

hist(mtcars$mpg)
#지난번에 배운 barplot와 비슷합니다.
hist(mtcars$mpg,breaks = 7)
#breaks로 대강의 상자 갯수를 지정해준다.


ToothGrowth
plot(ToothGrowth$supp, data=ToothGrowth)
str(ToothGrowth)

#두 벡터가 하나의 data.frame에 들어있을때
boxplot(len~supp,data = ToothGrowth)
#두 변수를 사용하여 x축의 값들을 세분화 할 수 있다.
boxplot(len~supp+dose,data = ToothGrowth)

boxplot 보는법

최댓값
제 3사분위 : 75%의 위치
제 2사분위 : 50%의 위치, 중앙값(median)
제 1사분위 : 25%의 위치
최솟값

이상치(Outlier)





