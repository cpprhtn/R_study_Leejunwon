#coin toss stock price simulation
n <- 10000
stock_price <- vector(length=n)
current_stock <- 129

for(i in 1:n){
  if(rbinom(1, 1, 1/2 )==1){
   current_stock <- current_stock + 1
  }
  else{
    current_stock <- current_stock - 1
  } %>% 
  stock_price[i] <- current_stock
}
current_stock
stock_price
plot(stock_price, type="l",col="red")
