# Instal·lació de paquets
install.packages("RSelenium")
install.packages("rvest")
install.packages("dplyr")


# Càrrega de llibreries
library(RSelenium)



# Tanquem els ports

system("taskkill /im java.exe /f", intern=FALSE, ignore.stdout=FALSE)



# Configurem el servidor de Selenium i el navegador. S'haurà de borrar la llicencia de Chromedriver perque no doni problemes
# Es pot trobar a C:\Users\ElTeuUsuari\AppData\Local\binman\binman_chromedriver\win32\123.0.6312.106

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


# Accés al client

remDr <- rD$client



## SABATES ESPORTIVES D'HOME

# Obrim el navegador i anem a la plana web.

remDr$open()
remDr$navigate("https://www.nike.com/es/w/hombre-zapatillas-nik1zy7ok")
Sys.sleep(5)


# Fem click al botó del pop-up que surt per tancar-lo.

remDr$findElement(using = "xpath", "//button[text()='Aceptar todas']")$clickElement()


# Scroll: Utilitzem un while que busca a quina altura està l'ultim scroll. Torna a fer scroll fins que l'altura
# de l'últim scroll es igual que l'altura de l'scroll anterior.

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

# Deixem una pausa de 10 segons per carregar dades.

Sys.sleep(10)



# Seleccionem les dades que agregarem al dataset utilitzant CSS i XPATH.

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



# Afegim totes les dades a un df

nike_df_m <- data.frame(
        names,
        price,
        colours,
        subtitle,
        sex = "Man",
        date = Sys.Date()
)  


# Repetirem el proces amb els productes de dona i nens


# SABATES ESPORTIVES DE DONA

remDr$open()
remDr$navigate("https://www.nike.com/es/w/mujer-zapatillas-5e1x6zy7ok")
Sys.sleep(5)



remDr$findElement(using = "xpath", "//button[text()='Aceptar todas']")$clickElement()



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



nike_df_w <- data.frame(
        names,
        price,
        colours,
        subtitle,
        sex = "Woman",
        date = Sys.Date()
)  



# SABATES ESPORTIVES DE NEN

remDr$open()
remDr$navigate("https://www.nike.com/es/w/ninos-zapatillas-v4dhzy7ok")
Sys.sleep(5)



remDr$findElement(using = "xpath", "//button[text()='Aceptar todas']")$clickElement()



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
#

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



nike_df_k <- data.frame(
        names,
        price,
        colours,
        subtitle,
        sex = "Kids",
        date = Sys.Date()
)  


# Obtenim el dataset final, tanquem el navegador i el passem a CSV

Dataset_of_Nike_Sneakers = rbind(nike_df_m, nike_df_w, nike_df_k)


remDr$close()
rD$server$stop()


rite.csv2(
        Dataset_of_Nike_Sneakers,
        file = "Dataset_of_Nike_Sneakers.csv",
        fileEncoding = "UTF-8",
        row.names = FALSE

# Extreiem les llibreries utilitzades en format txt:

sink("libraries.txt")
cat("Package RSelenium version 1.7.9")
cat("\n")
cat("Package rvest version 1.0.4")

# Bibliografia:
# https://www.zenrows.com/blog/rselenium#scrape
# https://pbelai.github.io/2020-06-22-scraping-data-from-website-with-infinite-scrolling/
# Extract from css selector: https://stackoverflow.com/questions/73070911/rselenium-issue-with-extracting-link-from-website
# https://www.youtube.com/watch?v=mWUOdV2nMOk&t=1117s&ab_channel=SamerHijjazi
