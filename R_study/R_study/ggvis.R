library(ggvis)

mtcars
plot(mtcars$mpg, mtcars$wt)

mtcars %>% ggvis(~mpg, ~wt, fill=~cyl) %>% layer_points() %>% layer_smooths() #fill:="red"

str(mtcars)
#num일땐 연속된 수로 인식
mtcars$cyl <- factor(mtcars$cyl)
str(mtcars)
#factor일때 각각의 수로 인식
mtcars %>% ggvis(~mpg, ~wt, fill=~cyl) %>% 
  layer_points() %>% layer_smooths() %>%
  add_axis("x",title="MPG",values=c(10:35)) %>%
  add_axis("y",title="WT",subdivide=4) #subdibide : 눈금만 나타냄
#add_axis("기준축", title="자료이름", values=기준축의 범위)