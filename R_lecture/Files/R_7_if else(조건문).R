#조건 1개 (if만 사용)

#홀수일때 박수치기

clap <- function(x){
  if(x%%2==1) { #x를 2로 나눈 나머지가 1일때
    print("박수") #박수를 출력하라
  }
}

clap(5)
clap(101)



#조건 2개( _1. if 2개 || _2. if, else || _3. ifelse )
#홀수 짝수 알려주기
clap_1 <- function(x){
  if(x%%2==1){
    print("홀수")
  }
  if(x%%2==0){
    print("짝수")
  }
}
clap_1(123)
clap_1(200)


clap_2 <- function(x){
  if(x%%2==1){
    print("홀수입니다.")
  }
  else{ #if 조건이 맞지 않을때
    print("짝수입니다.")
  }
}
clap_2(123)
clap_2(200)

clap_3 <-function(x){ #ifelse(조건,참일때,거짓일때)
  ifelse((x%%2==1),"홀수입니당","짝수입니당")
}
clap_3(123)
clap_3(200)


#조건이 3개 (if, else if, else)

#2차방정식
equation <- function(x,y){
  data_1 <- paste(x,"-",y,"=",(x-y))
  print(data_1)
  #양수, 0, 음수를 판단해보자
  if((x-y)>0){ #x-y값이 0보다 클때
    print("양수입니다")
  }
  else if(x==y) { #x-y값이 0일때, 즉 x=y일때
    print("0 입니다")
  }
  else{#if와 else if 조건에 만족하지 않을때
    print("음수입니다")
  }
}
equation(5,1)
equation(-1,-1)
equation(100,101)

#조건이 n개일때 (if 1개, else if n-2개, else 1개)

if(a==1){
}
else if(a==2){
}
else if(a==3){
}
else if(){
}
else{
}






