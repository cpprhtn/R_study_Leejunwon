install.packages("XML")
library(XML)

XML 패키지를 사용해서 웹페이지에 테이블 형식으로 있는 자료를 R로 다운로드 받을 수 있습니다. 
인벤 기록실의 LoL선수기록을 아래 df 객체로 다운로드 받았습니다.

df1<-readHTMLTable("http://lol.inven.co.kr/dataninfo/match/playerList.php", header=T)
str(df)
df1 <- df1[[2]]
str(df)
str(df[[2]])
View(df[[2]])
df[[2]] -> df
head(df)
#필요없는 변수 삭제
df<-df[, -c(1, 2,5)]
head(df)
names(df)<-c("name", "cmp", "result", "k", "d", "a", "kda", "help")
str(df)
#형변환
df[, 4:7]<-sapply(df[, 4:7], function(a){as.numeric(as.character(a))})
df$help<-as.numeric(sub("%", "", df$help))/100
str(df)
temp<-as.data.frame(do.call(rbind, strsplit(df$help, ' (?=[^ ]+$)', perl=TRUE)))
df$k_d_a <- paste(df$k,df$d,df$a,sep="/")
head(df)
df <- df[,-c(4:6)]
df <- df[,c(1,2,6,5,4,3)]
names(df) <- c("선수명","챔피언","kda","어시","평점","결과")
df
df$name<-temp$V2
df$team<-temp$V1
df
write.csv(df, "lol_test.csv")
?BH
