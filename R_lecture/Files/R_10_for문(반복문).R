a <- c(5,9,6,4,2,4,10,1)
#하나하나 출력해보자.
a[1]
a[2]
a[3]
a[4]
...
length(a) #length(data), data의 길이를 알려준다.
a[8]

#자료갯수만큼 입력해야한다.
#for문을 이용하여 간단히 할수있다.
for(i in 1:length(a)){ 
  #i라는 지역변수가 1~(a의 길이)까지 1씩 증가하며 {}괄호 속의 내용을 반복한다.
  print(a[i])
}



#1~10까지의 합을 구해보자.
sum = 0
for(i in 1:10){
  print(paste("i =",i))
  print(paste("sum =",sum))
  sum= sum + i
  print(paste("sum + i =",sum))
  print("")
}
sum

#직관적으로 수정해보자.



#다중for문
#for문안에 다른 for문을 사용하는 방식

#구구단을 만들어보자.
2 * 1 = 2 
2 * 2 = 4
.
.
.
9 * 9 = 81

n * m = X 형식.
n = 2~9까지
m = 1~9까지

for(n in 2:9){
  print(paste(n,"단"))
  for(m in 1:9){
    print(paste(n,"*",m,"=",n*m))
  }
  print("                 ")
}

#직관적으로 수정해보자.