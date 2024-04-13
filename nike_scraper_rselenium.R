# Intal·lació de paquets
install.packages("RSelenium")
install.packages("rvest")
install.packages("dplyr")


# Carreguem RSelenium
library(tidyverse)
library(RSelenium)
library(netstat)
library(rvest)
library(dplyr)


# Configurem un servidor de Selenium i un navegador.
#system("taskkill /im java.exe /f", intern=FALSE, ignore.stdout=FALSE)

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


# Acess the client object
remDr <- rD$client


# Start the browser and send it to the web
remDr$open()
remDr$navigate("https://www.nike.com/es/w/hombre-zapatillas-nik1zy7ok")

#Click on the cookies' close button
remDr$findElement(using = "xpath", "//button[text()='Aceptar todas']")$clickElement()

#Find in the css enviroment the body and send to the browser to go to the end of the page 
#scroll_d <- remDr$findElement(using = "css", value = "body")
#scroll_d$sendKeysToElement(list("key" = "end"))

# Carreguem el link
link = "https://www.nike.com/es/w/hombre-zapatillas-nik1zy7ok"
page = read_html(link) # Crea document html desde la url


# html_nodes() selecciona parts de un document utilitzant seleccions CSS
# html_text() extracció de text dels nodes seleccionats

# Link de cada producte
sneakers_links = page %>% html_elements(".product-card__link-overlay") %>%
        html_attr("href")

#Obtenció de l'atribut color
get_colour = function(sneaker_link){
        sneaker_page = read_html(sneaker_link)
        colour = sneaker_page %>% html_elements(".description-preview__color-description") %>% html_text()
        
        return(colour)
}

#Obtenció de l'atribut model
get_model = function(sneaker_link){
        sneaker_page = read_html(sneaker_link)
        model = sneaker_page %>% html_elements(".description-preview__style-color") %>% html_text()
        
        return(model)
}
#Obtenció de l'atribut nom del producte
get_name = function(sneaker_link){
        sneaker_page = read_html(sneaker_link)
        name_product = sneaker_page %>% html_elements("#pdp_product_title") %>% html_text()
        
        return(name_product)
}

#Obtenció de l'atribut descripció
get_descr = function(sneaker_link){
        sneaker_page = read_html(sneaker_link)
        description = sneaker_page %>% html_elements(".css-1pbvugb p") %>% html_text()
        
        return(description)
}

#Obtenció de l'atribut valoració
get_review = function(sneaker_link){
        sneaker_page = read_html(sneaker_link)
        review = sneaker_page %>% html_elements(".product-review .pl4-sm") %>% html_text()
        
        return(review)
}

#Obtenció de l'atribut preu actual
get_price = function(sneaker_link){
        sneaker_page = read_html(sneaker_link)
        price = sneaker_page %>% html_elements(".css-tpaepq") %>% html_text()
        
        return(price)
}

#Obtenció de l'atribut preu antic
get_price_disc = function(sneaker_link){
        sneaker_page = read_html(sneaker_link)
        price_disc = sneaker_page %>% html_elements(".css-s56yt7") %>% html_text()
        
        return(price_disc)
}

#Obtenció de l'atribut descompte
get_discount = function(sneaker_link){
        sneaker_page = read_html(sneaker_link)
        discount = sneaker_page %>% html_elements(".css-14jqfub") %>% html_text()
        
        return(discount)
}

# Per cada un dels links aconseguim color, model i nom i els guardem. Per price_disc i discount
# farem una conversio de llista a caracter perque no doni error a l'hora de crear el df.
colours = sapply(sneakers_links, FUN = get_colour, USE.NAMES = FALSE)
models = sapply(sneakers_links, FUN = get_model, USE.NAMES = FALSE)
names = sapply(sneakers_links, FUN = get_name, USE.NAMES = FALSE)
description = sapply(sneakers_links, FUN = get_descr, USE.NAMES = FALSE)
review = sapply(sneakers_links, FUN = get_review, USE.NAMES = FALSE)
price = sapply(sneakers_links, FUN = get_price, USE.NAMES = FALSE)
price_disc = as.character(sapply(sneakers_links, FUN = get_price_disc, USE.NAMES = FALSE))
discount = as.character(sapply(sneakers_links, FUN = get_discount, USE.NAMES = FALSE))


# Obtenció del DF
df_nike = data.frame(names, models, colours, price, price_disc, discount,
                     review, description, stringsAsFactors = FALSE)