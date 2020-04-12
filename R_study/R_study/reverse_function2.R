rev_word <- function(string){
a <- strsplit(string, split=" ")
str_length <- length(a[[1]])
reversed <- a[[1]][str_length:1]
paste(reversed, collapse=" ")
}
rev_word("how are you?, what are you doing?")
