hi <- paste("Hi","Jack") #붙여서 나옴
paste("jac","k",sep="") #sep=는 문자열 사이에 들어갈 옵션 
paste(hi,"what's up",sep=", ")

paste("1",1:10,sep="-") 

a <- paste("The value of 'pi' is", pi,", endless!!!")
noquote(a)

print(a, quote=FALSE)
a

mtcars #기본 제공 데이터, 연습용으로 사용
cars <- rownames(mtcars) #rownames 자료 제목만 가져오는 것
cars
colnames(mtcars) #colnames 분류기준명만 가져오는 것
nchar(cars) #문자열의 길이
cars[which(nchar(cars)==max(nchar(cars)))] #가장 긴 이름 찾기
