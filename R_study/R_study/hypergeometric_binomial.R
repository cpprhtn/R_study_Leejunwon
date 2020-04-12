dbinom(3, 10, 0.5) #dbinom(m, n, p)
#n번중 p의 확률로 m번 나올 확률

dhyper(3, 24, 36, 10) #dhyper(x, y, z, r)
#y+z명중 r명 뽑았을때 y가 x번 나올 확률

a=100
approx <- numeric(length = a)
for(i in 1:a){
  approx[i]=dhyper(3,4*i, 6*i,10)
}
approx

plot(approx[2:100])
abline(h=dbinom(3,10,0.4),col="red")

approx-dbinom(3,10,0.4)
