# Installing packages
install.packages("RSelenium")
install.packages("rvest")
install.packages("dplyr")


# Loading libraries
library(tidyverse)
library(RSelenium)
library(rvest)
library(netstat)
library(dplyr)


# Close all ports

system("taskkill /im java.exe /f", intern=FALSE, ignore.stdout=FALSE)


# Seting up Selenium server and a browser.

rD <- rsDriver(port = 4567L,
               browser = "chrome",
               version = "latest",
               chromever = "latest",
               geckover = "latest",
               iedrver = NULL,
               phantomver = "2.1.1",
               verbose = TRUE,
               check = TRUE
)


# Access to the client

remDr <- rD$client


## MAN PRODUCTS

# Opening the browser and navigate to the website

remDr$open()
remDr$navigate("https://www.nike.com/es/w/hombre-zapatillas-nik1zy7ok")
Sys.sleep(5)


# Click on the Close button

remDr$findElement(using = "xpath", "//button[text()='Aceptar todas']")$clickElement()


# Scroll
while(TRUE){
        height = remDr$executeScript("return document.body.scrollHeight")
        print(height)
        remDr$executeScript("window.scrollTo(0,document.body.scrollHeight)")
        Sys.sleep(10)
        new_height = remDr$executeScript("return document.body.scrollHeight")
        if(unlist(height) == unlist(new_height)){
                break
        }
        
}
Sys.sleep(10)

# Selecting data that we will add in df using CSS and XPATH. Using lapply to get all data in one value.

sneaker_name <- remDr$findElements(using = "css", ".product-card__link-overlay")
names <- unlist(lapply(sneaker_name, function(x) {
        
        x$getElementText()
}))

price_elements <- remDr$findElements(using = "xpath", "//div[starts-with(@class, 'product-price__wrapper')]")
price <- unlist(lapply(price_elements, function(x) {
        
        x$getElementText()
}))


colours_elements <- remDr$findElements(using = "xpath", "//div[starts-with(@class, 'product-card__product-count')]")
colours <- unlist(lapply(colours_elements, function(x) {
        x$getElementText()
}))

subtitle_elements <- remDr$findElements(using = "xpath", "//div[starts-with(@class, 'product-card__subtitle')]")
subtitle <- unlist(lapply(subtitle_elements, function(x) {
        
        x$getElementText()
}))



# Adding all data in a df for male products

nike_df_m <- data.frame(
        names,
        price,
        colours,
        subtitle,
        sex = "Man",
        date = Sys.Date()
)  


## WOMEN PRODUCTS

# Opening the browser and navigate to the website

remDr$open()
remDr$navigate("https://www.nike.com/es/w/mujer-zapatillas-5e1x6zy7ok")
Sys.sleep(5)


# Click on the Close button

remDr$findElement(using = "xpath", "//button[text()='Aceptar todas']")$clickElement()


# Scroll

while(TRUE){
        height = remDr$executeScript("return document.body.scrollHeight")
        print(height)
        remDr$executeScript("window.scrollTo(0,document.body.scrollHeight)")
        Sys.sleep(10)
        new_height = remDr$executeScript("return document.body.scrollHeight")
        if(unlist(height) == unlist(new_height)){
                break
                print(height)
        }
        
}
Sys.sleep(10)

# Selecting data that we will add in df using CSS and XPATH. Using lapply to get all data in one value.

sneaker_name <- remDr$findElements(using = "css", ".product-card__link-overlay")
names <- unlist(lapply(sneaker_name, function(x) {
        
        x$getElementText()
}))

price_elements <- remDr$findElements(using = "xpath", "//div[starts-with(@class, 'product-price__wrapper')]")
price <- unlist(lapply(price_elements, function(x) {
        
        x$getElementText()
}))


colours_elements <- remDr$findElements(using = "xpath", "//div[starts-with(@class, 'product-card__product-count')]")
colours <- unlist(lapply(colours_elements, function(x) {
        x$getElementText()
}))

subtitle_elements <- remDr$findElements(using = "xpath", "//div[starts-with(@class, 'product-card__subtitle')]")
subtitle <- unlist(lapply(subtitle_elements, function(x) {
        
        x$getElementText()
}))



# Adding all data in a df for male products

nike_df_w <- data.frame(
        names,
        price,
        colours,
        subtitle,
        sex = "Woman",
        date = Sys.Date()
)  


## KIDS PRODUCTS

# Opening the browser and navigate to the website

remDr$open()
remDr$navigate("https://www.nike.com/es/w/ninos-zapatillas-v4dhzy7ok")
Sys.sleep(5)


# Click on the Close button

remDr$findElement(using = "xpath", "//button[text()='Aceptar todas']")$clickElement()


# Scroll

while(TRUE){
        height = remDr$executeScript("return document.body.scrollHeight")
        print(height)
        remDr$executeScript("window.scrollTo(0,document.body.scrollHeight)")
        Sys.sleep(10)
        new_height = remDr$executeScript("return document.body.scrollHeight")
        print(height)
        if(unlist(height) == unlist(new_height)){
                break
                print(height)
        }
        
}

Sys.sleep(10)
# Selecting data that we will add in df using CSS and XPATH. Using lapply to get all data in one value.

sneaker_name <- remDr$findElements(using = "css", ".product-card__link-overlay")
names <- unlist(lapply(sneaker_name, function(x) {
        
        x$getElementText()
}))

price_elements <- remDr$findElements(using = "xpath", "//div[starts-with(@class, 'product-price__wrapper')]")
price <- unlist(lapply(price_elements, function(x) {
        
        x$getElementText()
}))


colours_elements <- remDr$findElements(using = "xpath", "//div[starts-with(@class, 'product-card__product-count')]")
colours <- unlist(lapply(colours_elements, function(x) {
        x$getElementText()
}))

subtitle_elements <- remDr$findElements(using = "xpath", "//div[starts-with(@class, 'product-card__subtitle')]")
subtitle <- unlist(lapply(subtitle_elements, function(x) {
        
        x$getElementText()
}))



# Adding all data in a df for male products

nike_df_k <- data.frame(
        names,
        price,
        colours,
        subtitle,
        sex = "Kids",
        date = Sys.Date()
)  


Dataset_of_Nike_Sneakers = rbind(nike_df_m, nike_df_w, nike_df_k)


# Cerrar el navegador
remDr$close()
rD$server$stop()

# Extracting df to a csv

write.csv2(
        nike_sneakers_df,
        file = "nike_df.csv",
        fileEncoding = "UTF-8",
        row.names = FALSE
)

# Bibliografia:
# https://www.zenrows.com/blog/rselenium#scrape
# https://pbelai.github.io/2020-06-22-scraping-data-from-website-with-infinite-scrolling/
# Extract from css selector: https://stackoverflow.com/questions/73070911/rselenium-issue-with-extracting-link-from-website
# https://www.youtube.com/watch?v=mWUOdV2nMOk&t=1117s&ab_channel=SamerHijjazi