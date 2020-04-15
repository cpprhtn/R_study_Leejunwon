mtcars
#mtcars에 있는 data중 mpg와 gear를 시각화해보려 한다.
#먼저 지난시간에 배운 plot로 나타내보자.
plot(mtcars$mpg,mtcars$gear)
#데이터 형태가 이상하다.
#다른 타입도 확인해보자.
arr <- c("p","l","h","b")
par(mfrow=c(2,2)) #화면을 2,2로 분할한다.
for(i in 1:4){
  plot(mtcars$mpg,mtcars$gear, type = arr[i])
}
#다른 타입의 그래프들 모두 형태가 이상하다.
#dotchart로 나타내보자.
par(mfrow=c(1,1))
dotchart(mtcars$mpg,mtcars$gear)
#데이터를 알아볼수 있으나, 직관적이지가 않다.
#보다 직관적으로 바꿔보자.

#rowname를 먼저 나타내주자.
dotchart(mtcars$mpg,labels = row.names(mtcars))
#mpg값을 정렬해주자.
sort_mpg <- mtcars[order(mtcars$mpg),] #mpg의 값을 작은 순서대로 sort(정렬)해준다.
sort_mpg
class(mtcars$gear)
par(mfrow=c(1,2))
dotchart(sort_mpg$mpg,labels = row.names(sort_mpg), xlab = "Miles Per Gallon(mpg)",
         groups = sort_mpg$gear,
         main = "Gear's class type is numeric")
#gear에 따라 자료가 묶여서 처리되었다.
#그러나 그래프만 보고는 gear의 값을 알수가 없다.
#이를 해결해보자.
sort_mpg$gear <- factor(sort_mpg$gear)
class(sort_mpg$g)
dotchart(sort_mpg$mpg,labels = row.names(sort_mpg), xlab = "Miles Per Gallon(mpg)",
         groups = sort_mpg$gear,
         main = "Gear's class type is factor")
#mpg의 정렬 + 같은 gear값끼리 그룹화 + gear값의 명시.
#자료가 더 직관적으로 보인다.
#이렇듯 형변환이 중요함을 알 수 있다.

#조금만 더 직관적으로 변환해보자..
sort_mpg$color[sort_mpg$gear==3] <- "blue" 
sort_mpg$color[sort_mpg$gear==4] <- "red"
sort_mpg$color[sort_mpg$gear==5] <- "dark green"
#sort_mpg의 gear 값이 3일때 sort_mpg의 color항목에 "blue"를 넣는다.
#4일때는 red
#5일때는 dark green
par(mfrow=c(1,2))
dotchart(sort_mpg$mpg,labels = row.names(sort_mpg), xlab = "Miles Per Gallon(mpg)",
         groups = sort_mpg$gear,
         main = "No color")
dotchart(sort_mpg$mpg,labels = row.names(sort_mpg), xlab = "Miles Per Gallon(mpg)",
         groups = sort_mpg$gear, color = sort_mpg$color, cex=0.8, #글자크기
         main = "Have color")

