#먼저 외부자료를 다운받아 봅시다. 
#다운받은 자료를 바탕화면으로 이동시켜줍니다.
#sampdb파일중에 오늘 쓸 파일은 president.txt파일입니다.

#먼저 파일의 경로를 설정해 주어야합니다.
getwd() #현재 설정된 경로
setwd("/Users/cpprhtn/Desktop/sampdb") #desktop의 sampdb로 경로설정

sampdb안의 president.txt파일을 불러오겠습니다.
read.table("president.txt",header = FALSE, sep = "\t") -> sam
#혹시 txt파일을 불러오지 못했다면 setwd 경로설정방법을 검색창에 검색하셔서
#재설정 해주시면 되겠습니다.
sam
#역대 미국대통령들이 기록되어있습니다.
#우리가 알기 편하도록 데이터를 수정해봅시다.
sam$Name <- paste(sam$V2,sam$V1)
sam$State <- sam$V4
sam$Life <- paste(sam$V6,sam$V7,sep=" ~ ")
sam
#Life의 모양이 예쁘지 않으니 옵션을 붙여 변형해봅시다.

#필요한 부분만 이제 뽑아봅시다.
pre_new <- sam[,c(8,9,11)]
pre_new

#데이터의 type보기
str(pre_new)

#Life는 날짜인데, chr형으로 선언되어있습니다. 다른작업시 불편해질수도 있기때문에 date type로 바꿔줍시다.
pre_new$Life <- as.Date(pre_new$Life)

str(pre_new)
write.table(pre_new, "pre_new.txt", sep = ",",row.names = FALSE)
sampdb폴더에 president.txt이외에도 다른 txt파일도 있습니다.
따로 연습해보면 좋겠습니다.