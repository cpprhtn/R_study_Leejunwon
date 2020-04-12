C <- matrix(c(1,-1,2,3), nrow=2)
C 
def_f <- function(A){
  D <- A[1,1]*A[2,2]-A[1,2]*A[2,1]
  return(D)
}
def_f(B)

inv_f <- function(A){
  D <- A[1,1]*A[2,2]-A[1,2]*A[2,1]
  B <- matrix(nrow = 2, ncol = 2)
  B[1,1] <- A[2,2]
  B[2,2] <- A[1,1]
  B[1,2] <- -A[1,2]
  B[2,1] <- -A[2,1]
  I=1/D*B
  inv <- list()
  inv$det <- D
  inv$I <- I
  return(inv)
}
D <- inv_f(C)$det
D
I <- inv_f(C)$I
I
C%*%I
round(C%*%solve(C),10)
