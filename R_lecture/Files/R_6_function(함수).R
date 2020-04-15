#자기소개 함수를 만들어 봅시다
#Hello my name is ~~~

f_intro <- function(name){
  data1 <- "Hello my name is"
  intro <- paste(data1,name)
  intro
}

f_intro("bigdata")


#전역변수(global variable)와 지역변수(local variable) 이해하기
#임의의 함수
a <- function(price){
  price
  b = 30
}
a(300)
b=20
b

#이름과 나이 소개하기
#Hello my name is ~~~. I'm ~~ years old

f_intro <- function(name, age){
  data1 <- "Hello my name is"
  intro <- paste(data1,name) #Hello my name is ~~~.
  #I'm ~~ years old
  final_intro <- paste(intro,"I'm",age,"years old")
  final_intro
}
f_intro("bigdata",20)


