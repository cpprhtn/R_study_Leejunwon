#자료정리가 중요
library(tidyr)
library(dplyr)

member <- data.frame(family=c(1,2,3), namef=c("a","b","c"), agef=c(30,40,23),
                     namem=c("d","e","f"), agem=c(44,53,25))
member
a <- gather(member, key, value, namef:agem)  #gather(자료, 항목1, 항목2 ,시작항목:끝항목)
b <- separate(a, key ,c("variable","type"),-1) #separate(자료, 분할할 항목, 분할내용)
new <- spread(b, variable, value) #spread(자료, 분할할 항목,교체할 항목)
new
filter(new, type=="f")
filter(new, age>=30)


new2 <- member %>% 
  gather(key,value, namef:agem) %>%
  separate(key ,c("variable","type"),-1) %>%
  spread(variable, value)
new2

#자료정리를 안할시_비효율
member
select(member, family, namef, agef)
