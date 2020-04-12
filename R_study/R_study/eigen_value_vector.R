A <- matrix(c(3,1,0,2,1,0,-2,-2,1),nrow = 3)
A


ev <- eigen(A)$values
evec <- eigen(A)$vectors
diog(ev)
evec%*%diog(ev)%*%solve(evec)

trans <- function(A){
  B <- matrix(nrow = nrow(A), ncol = ncol(A))
  for(i in 1:nrow(A)){
    for(j in 1:ncol(A)){
      A[j.i] <- A[i,j]
    }
  }
  return(B)
}
trans(A)
C <- matrix(c(3,2,-2,2,1,-2,-2,-2,1),nrow = 3)
C==trans(C)
