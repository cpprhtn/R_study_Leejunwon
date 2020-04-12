reverse_myf <- function(string){
a <- strsplit(string,split="") #자르는 기준
reversed <- a[[1]][nchar(string):1]
paste(reversed,collapse="") #제거하고 출력
}
reverse_myf("how are you?, Jack")
