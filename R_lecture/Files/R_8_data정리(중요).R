#install.packages("tidyr") #패키지를 설치해주시면 됩니다(저는 설치가 되어있어요.)
#install.packages("dplyr") #패키지를 설치해주시면 됩니다.
library("dplyr")
# dplyr이라는 라이브러리는 %>%, "pip"라고 부르는 데이터 전처리,조작 패키지입니다.
#코드 양을 획기적으로 줄여주는 역할을 합니다. 
#%>% 단축키는 "ctrl + shift + m"입니다 
library("tidyr")
#tidyr이라는 라이브러리는 data.frame 조작 패키지입니다.

mtcars #기본적으로 내장되어있는 연습data

mtcars$name = rownames(mtcars) #rownames(data)  data의 rownames를 표시해준다.
mtcars
rownames(mtcars) = NULL #NULL은 아무것도 없음, 비어있음을 의미.
mtcars
mtcars %>% select(name,mpg,cyl,disp) -> mt_1
mt_1
#gather(data, 새로운 항목 생성, 생성된 항목의 값들을 넣을 변수, 변환할 값 지정)
gather(mt_1,key,value,mpg,cyl,disp) ->mt_2
mt_2
head(mt_1) #데이터의 일부분만 불러오기
head(mt_2)
#spread(data, 나눌 항목, 나눌 항목의 값)
#gather은 병합, spread는 분할, 즉 서로 반대되는 관계
spread(mt_2, key,value) -> mt_final
head(mt_1) 
head(mt_2)
head(mt_final)
#자료정리가 알파벳 순으로 깔끔하게 정리가 되었습니다.

#이렇게 원하는데로 정리가 되었다면, 데이터를 쉽게 가져오고, 분석할 수 있을 것입니다.
#아직 그래프 기능은 배우지 않았지만 
#filter함수를 사용하여 원하는 부분만 뽑아봅시다.

filter(mt_final,cyl=="8")
filter(mt_final,mpg>=20)


#이번에는 직접 data.frame를 만들어봅시다.

team = c('a','b','c','d')
namef=c("kim","seo","suji","yun")
agef=c("20","36","17","41")
namem=c("jun","brown","tom","mark")
agem=c("22","38","21","49")

department <- data.frame(team,namef,agef,namem,agem)
department
#현재, 성별 구분이 어렵다.
#구분되도록 만들어 봅시다.

#gather(data, 새로운 항목 생성, 생성된 항목의 값들을 넣을 변수, 변환할 값 지정)
dep_1 <- gather(department,key,value,namef:agem)
dep_1
#separate(data, 분할할 항목, 분할할 범위지정)
n    a    m    e    f                         a    g    e    m 
1    2    3    4    5                         1    2    3    4
-5  -4  -3   -2    -1                        -4   -3   -2   -1

dep_2 <- separate(dep_1,key,c("variable","gender"),-1)
head(dep_1)
head(dep_2)

#spread(data, 나눌 항목, 나눌 항목의 값)
depart <- spread(dep_2,variable,value)
head(depart)
#value의 데이터들을 variable의 나눈 항목에 맞게 정리가 되었다.

처음 만든형태와 비교해보자.
department
depart
#훨씬 데이터를 읽기 수월해졌다.
filter(depart,gender=="f")
filter(depart,age<=30)

크게 2가지의 데이터들을 정리해보았습니다.
앞으로 혹시 실무에 사용하기위해서는 
여러가지 데이터들을 많이 정리해봐야 합니다.
직접 데이터를 만들어서 분석하는 연습을 길러도 되고
mtcars의 일부분을 떼어와서 연습해도 됩니다.
색다른 데이터로 연습하고 싶다면 
다음 강의를 보시면 될것 같습니다.