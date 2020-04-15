#코로나 바이러스 증가 추세를 그래프로 만들어보고, 분석해 봅시다.
corona <- c(1:19)
distribute <- c(1261,2337,3736,4812,5766,6767,7382,7755,7979,8162,8320,8565,8799,
                8961,9137,9332,9583,9786,9976)
length(distribute)
plot(corona,distribute)
#개요가 비슷하다.
#그래프에 다양한 정보를 넣어주자.
#plot(x축,y축,col = "컬러", type = "l,p,h,b", xlim = c(x범위),ylim = c(y범위),
#     xlab = "x축 단위", ylab = "y축 단위", main = "그래프 제목")
plot(corona,distribute,col="red",type = "b", ylim = c(0,10000),
     main = "Corona distribute in Korea", 
     xlab = "Date_start 2/26",ylab = "Infacted")

#비슷하게 만들어 보았습니다.
과연, 이 모델이 좋은 모델인가?
믿을만한 모델인가?
  
좋은 모델인지 빠르고 간단하게 판단하는 방법
1. summary(fit) 에서 coefficients 항목의 *(별) 갯수가 많을수록
2. p-value 값이 0.05 이하일때

좋은 모델일 가능성이 크다.
#말 그대로 빠르고 간단하게 판단이 가능한 것이며, 맹신하면 안된다.
#더 정확한 적합성의 판단은 F검정을 비롯한 다른 방법을 사용하면 된다.

fit <- lm(distribute ~ corona) # lm(y축 ~ x축), x, y의 통계적 중앙값
abline(fit, col = "blue") #직선 형태의 fit값을 그린다.

summary(fit)
#좋은 모델.



#데이터의 순서를 무작위로 섞음
corona2 <- c(1:19)
distribute2 <- c(2337,9137,3736,9976,4812,6767,7382,7755,5766,8162,8320,8565,8799,
                8961,1261,9332,9583,9786,7979)
plot(corona2,distribute2,col="purple",type = "b", ylim = c(0,10000),
     main = "Corona2 distribute in Korea", 
     xlab = "Date_start 2/26",ylab = "Infacted")
#불규칙적임을 알 수 있다.
fit를 구해 모델 적합성을 확인해보자.
fit2 <- lm(distribute2 ~ corona2)
abline(fit2)

summary(fit2)
#좋은 모델이 아니다.


