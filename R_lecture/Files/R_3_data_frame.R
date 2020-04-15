name <- c("me", "mom","dad","brother")
age <- c("20","50","53","19") #name데이터의 순서에 따르기!!
job <- c("student", "housewife","architect","student")
#위 세 자료를 가지고 family 틀 만들기

family <- data.frame(name, age, job)
family

age
age[1]
job[3]
family
family[1]
family[1,2]
family[,1]
family$age

#family$age와 age의 차이 확인하기

str(family$age) #factor type
str(age) # chr type

family[3,2] <- 50
family

which(family$name=="dad")
family[which(family$name=="dad"),2] <-50
family
