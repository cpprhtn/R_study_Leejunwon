hel <- "Hello"
wor <- "world!"
#한번에 출력하고 싶을때
paste(hel,wor)
paste(hel,"R",wor)

#sep은 문자열 사이에 들어갈 옵션
#기본형 sep = " "
#ex)
paste("010","1234","5678",sep = "-")

df <- c("Dog","Cat","Ant","Bird","Butterfly","Fly","Turtle","Rabbit","Tiger","Cow",
        "Lion","Eagle")
df

grep("a",df) #grep("찾을 내용", data)
grep("A",df) #대소문자가 구별된다
grep("[Aa]",df) #대소문자 구별없이

big <- toupper(df) #toupper(data) data값을 모두 대문자로 변환
df
big
small <- tolower(df) #data값을 모두 소문자로 변환
small


#R_3_data.frame() 자료 사용
name <- c("me", "mom","dad","brother")
age <- c("20","50","53","19") 
job <- c("student", "housewife","architect","student")
toeic <- c("948","870","936","711")

family <- data.frame(name, age, job,toeic)
family

#학점계산을 위해 토익점수의 100의 자릿수만 따로 빼내고 싶다.
t_point <- substr(family$toeic,1,1) 
#substr(data$A,n,m)  data$A의 n번칸부터 m번칸까지 추출
t_point

#100의자릿수 빼고 추출
t_point <- substr(family$toeic,2,3) 
t_point


#string 라이브러리
install.packages("stringr") #stringr이라는 외부 라이브러리 설치
library("stringr") #stringr이라는 라이브러리 적용
df
str_count(df) #df의 요소들 각각의 갯수
str_count(df,"a") #df의 요소들중 a를 포함하는 갯수
grep("a",df) #grep("찾을 내용", data)
