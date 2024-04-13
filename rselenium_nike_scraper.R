# Intal·lació de paquets
install.packages("RSelenium")
install.packages("rvest")
install.packages("dplyr")


# Carreguem RSelenium
library(tidyverse)
library(RSelenium)
library(rvest)
library(netstat)
library(dplyr)


# Tanquem tots els ports
system("taskkill /im java.exe /f", intern=FALSE, ignore.stdout=FALSE)


# Configurem un servidor de Selenium i un navegador.
rD <- rsDriver(port = 4567L,
               browser = "firefox",
               version = "latest",
               chromever = NULL,
               geckover = "latest",
               iedrver = NULL,
               phantomver = "2.1.1",
               verbose = TRUE,
               check = TRUE
)


# Acess al client
remDr <- rD$client


# Obre el navegador i va a la web
remDr$open()
remDr$navigate("https://www.nike.com/es/w/hombre-zapatillas-nik1zy7ok")
Sys.sleep(5)

#Clica en el botó del pop-up per acceptar les cookies
remDr$findElement(using = "xpath", "//button[text()='Aceptar todas']")$clickElement()

# Scroll
bodyEl <- remDr$findElement("css", "body")
for (i in 1:10) {
        bodyEl$sendKeysToElement(list(key = "page_down"))
        Sys.sleep(5)
}

# Selecciona els elements que introduirem al DF utilitzant tant CSS com XPATH. Finalment aplica la funció lapply
# per obtenir les dades en una sola variable
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



# Agreguem totes les dades del scraping en un df
nike_df <- products <- data.frame(
        names,
        price,
        colours,
        subtitle
)  

# Extracció del df a csv 
write.csv2(
        nike_df,
        file = "nike_df.csv",
        fileEncoding = "UTF-8",
        row.names = FALSE
)

# Bibliografia:
# https://www.zenrows.com/blog/rselenium#scrape
# https://pbelai.github.io/2020-06-22-scraping-data-from-website-with-infinite-scrolling/
# Extract from css selector: https://stackoverflow.com/questions/73070911/rselenium-issue-with-extracting-link-from-website
# https://www.youtube.com/watch?v=mWUOdV2nMOk&t=1117s&ab_channel=SamerHijjazi