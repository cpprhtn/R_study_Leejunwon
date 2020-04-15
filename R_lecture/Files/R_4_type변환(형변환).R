name <- "bigdata"
str(name)
class(name) #class는 data의 type만 알려준다

num <- 3
class(num)

is.character(name) #num data가 chr형인가? =>TRUE
is.character(num) # => False

#type변환(형변환)
#num을 chr로 변환
num2 <- as.character(num)
class(num)
class(num2)
#chr을 num으로 변환
num3 <- as.numeric(num2)
class(num3)

class(name)
name2 <- as.numeric(name)
name2 #NA not applicable , 즉 값이 없음을 의미

#num2와 name 둘다 chr형이었지만
#num3으로는 변환이되고 name2로는 변환이 안되는이유

#문자를 숫자로 표현이 불가능하기때문에 변환이 적용되지 않는다.


num                          chr




chr                          num




chr                         num










