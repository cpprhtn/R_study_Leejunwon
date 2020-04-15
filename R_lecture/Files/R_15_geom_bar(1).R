다양한 라이브러리가 있지만, ggplot2 라이브러리를 사용하여
데이터를 다뤄볼 생각입니다.
또한 gcookbook 책의 예제 패키지를 이용하여 연습할 것입니다.
먼저 라이브러리를 설치해줍시다.
install.packages("ggplot2")
install.packages("gcookbook")
(저는 이미 설치되어있으니 넘어가겠습니다.)
library(ggplot2)
library(gcookbook)


pg_mean
먼저 barplot로 만들어봅시다.
barplot(pg_mean$weight, names.arg = pg_mean$group,
        main = "Using barplot")
이번에는 ggplot로 만들어봅시다.
ggplot(pg_mean,aes(x=group,y=weight)) + geom_bar(stat = "identity") +
  ggtitle("Using ggplot")

모양이 비슷하게 나옵니다.

13강에 사용된 코드를 한번 가져와봅시다.
barplot(BOD$demand, names.arg = BOD$Time,
        main = "Using barplot",
        xlab = "Time",ylab = "Demand", ylim = c(0,20),
        col = "light blue", border = "blue")
ggplot로 나타내봅시다.

ggplot(BOD,aes(x=Time,y=demand)) + geom_bar(stat="identity")
#연속된 수로 인식하여 값이 없는 6이 비어있다.
이 역시 형변환으로 해결이 가능하다.
ggplot(BOD,aes(x=factor(Time),y=demand)) + geom_bar(stat="identity")
x값을 factor로 변환해 이산값으로 취급하게 한다.
barplot처럼 조금더 꾸며보겠습니다.
ggplot(BOD,aes(x=factor(Time),y=demand)) + geom_bar(stat="identity",
                                            fill="lightblue",colour = "black") + 
  ggtitle("Using ggplot")
#ggplot에서는 사용할 자료와 x,y축의 값 설정
#geom_bar : bar 즉 막대 그래프를 사용하겠다라고 알려줌.
#stat="identity"는 필수적으로 쓴다고 생각.
#fill은 막대 내부를 채움
#colour은 막대 태두리 색 결정

#이번에는 막대를 함께 묶어보겠습니다.
cabbage_exp

ggplot(cabbage_exp, aes(x=Date,y=Weight,fill=Cultivar)) + 
  geom_bar(stat="identity",position = "dodge",colour = "black") +
  scale_fill_brewer(palette = "Pastel1")
#postition = "dodge": 막대를 분리해준다.
막대 그래프의 색을 바꾸고싶다.
팔레트를 이용하여 색을 바꿔줄 수 있다.

#잘못된 데이터를 이와같이 만들경우.
ce <- cabbage_exp[1:5,] #1~5행의 데이터를 ce에 복사한다.
cabbage_exp
ce
ggplot(ce, aes(x=Date,y=Weight,fill=Cultivar)) + 
  geom_bar(stat="identity",position = "dodge",colour = "black") +
  scale_fill_brewer(palette = "Pastel1")
#데이터가 없어서 다른 막대가 빈 자리를 차지한다.