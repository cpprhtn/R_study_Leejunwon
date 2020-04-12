grep("z", cars) #grep("찾을내용", 자료), 대소문자 구별됨

grep("z",cars,value=TRUE)
grep("[Zz]",cars,value=TRUE) #대소문자 둘다 찾기
grep("t", tolower(cars), value=TRUE) #tolower(자료) : 자료전체를 소문자화 시킴
grep("T", toupper(cars), value=TRUE) #toupper(자료) : 자료전체를 대문자화 시킴

install.packages("stringr")
library(stringr)
cars
str_count(cars,"t") #각각의 자료에 t가 몇개 들어있나?
sum(str_count(toupper(cars),"TOYOTA")) 
