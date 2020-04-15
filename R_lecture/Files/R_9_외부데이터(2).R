먼저, 외부데이터를 가져와봅시다.
csv형식으로 다운받으시고, 바탕화면으로 옮겨줍시다.
파일명은 employment로 고쳐줍시다.

#install.packages("reshape2")
#reshape2 패키지를 다운받아줍시다.(melt함수에 이용) (저는 이미 다운되어있습니다.)
library(tidyr)
library(reshape2)
#바탕화면으로 경로를 설정해줍시다.
getwd()
setwd("/Users/cpprhtn/Desktop")
#파일을 불러옵시다.
read.csv("employment.csv",header = T,fileEncoding = "CP949") -> emp
#한글이 포함된 파일은 인코딩 설정을 해주는것이 중요합니다.
emp
#보기좋게 성별, 연령계층별, 날짜, value 항목으로 정리해줍시다.
emp_new <- melt(emp, id.vars = c("성별","연령계층별"),variable.name = "Date")
emp_new
head(emp_new)
#melt(emp, id.vars = c("성별","연령계층별"),variable.name = "Date")
#emp data를 id.var, variable, value 항목으로 emp_new에 녹여라.
#년, 월을 보기좋게 정리해봅시다.
#1. 년, 월을 따로 항목으로 만들어준다.
emp_new$year =substr(emp_new$Date,2,5)
#emp_new data의 Date항목중 2~5번째 칸을 year항목에 추가.
head(emp_new)
emp_new$month = substr(emp_new$Date,8,9)
head(emp_new)
emp_new

emp_new$year_month <- paste(emp_new$year,emp_new$month,sep="-")
head(emp_new)
emp_new$newDate <- paste(emp_new$year,emp_new$month,"01",sep="-")
#임의의 일을 추가하여 년-월-일 형태로 정리해보자.
emp_new$YearMonthDate <- paste(emp_new$year_month,"-01",sep = "")
head(emp_new)

#필요한 부분만 뽑기.
emp_final <- emp_new[,c(1,2,9,4)]
head(emp_final)
#다른방법
emp_2 <- emp_new[,c("성별","연령계층별","newDate","value")]
head(emp_2)
#2번쨰 방법은 항목이 많아 숫자를 찾기 어려울때 주로 사용하는 방법.

str(emp_final)
#Y.M.D의 type을 변경해주자.
emp_final$YearMonthDate = as.Date(emp_final$YearMonthDate)
emp_final
str(emp_final)
write.csv(emp_final, "pre_new.txt")
국가통계포털 사이트에서 다양한 데이터파일들을 다운받아 연습하시면 될것 같습니다.