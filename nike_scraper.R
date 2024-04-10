# Intalació de paquets
install.packages("rvest")
install.packages("dplyr")


# Càrrega de llibreries
library(rvest)
library(dplyr)


# Comprovem user agent:
se <- session( "https://httpbin.org/user-agent" )
se$response$request$options$useragent

# Carreguem el link
link = "https://www.nike.com/es/w/hombre-zapatillas-nik1zy7ok"
page = read_html(link) # Crea document html desde la url


# html_nodes() selecciona parts de un document utilitzant seleccions CSS
# html_text() extracció de text dels nodes seleccionats

# Link de cada producte
sneakers_links = page %>% html_nodes(".product-card__link-overlay") %>%
        html_attr("href")

#Obtenció de l'atribut color
get_colour = function(sneaker_link){
        sneaker_page = read_html(sneaker_link)
        colour = sneaker_page %>% html_nodes(".description-preview__color-description") %>% html_text()
        
        return(colour)
}

#Obtenció de l'atribut model
get_model = function(sneaker_link){
        sneaker_page = read_html(sneaker_link)
        model = sneaker_page %>% html_nodes(".description-preview__style-color") %>% html_text()
        
        return(model)
}
#Obtenció de l'atribut nom del producte
get_name = function(sneaker_link){
        sneaker_page = read_html(sneaker_link)
        name_product = sneaker_page %>% html_nodes("#pdp_product_title") %>% html_text()
        
        return(name_product)
}

#Obtenció de l'atribut descripció
get_descr = function(sneaker_link){
        sneaker_page = read_html(sneaker_link)
        description = sneaker_page %>% html_nodes(".css-1pbvugb p") %>% html_text()
        
        return(description)
}

#Obtenció de l'atribut valoració
get_review = function(sneaker_link){
        sneaker_page = read_html(sneaker_link)
        review = sneaker_page %>% html_nodes(".product-review .pl4-sm") %>% html_text()
        
        return(review)
}

#Obtenció de l'atribut preu actual
get_price = function(sneaker_link){
        sneaker_page = read_html(sneaker_link)
        price = sneaker_page %>% html_nodes(".css-tpaepq") %>% html_text()
        
        return(price)
}

#Obtenció de l'atribut preu antic
get_price_disc = function(sneaker_link){
        sneaker_page = read_html(sneaker_link)
        price_disc = sneaker_page %>% html_nodes(".css-s56yt7") %>% html_text()
        
        return(price_disc)
}

#Obtenció de l'atribut descompte
get_discount = function(sneaker_link){
        sneaker_page = read_html(sneaker_link)
        discount = sneaker_page %>% html_nodes(".css-14jqfub") %>% html_text()
        
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


