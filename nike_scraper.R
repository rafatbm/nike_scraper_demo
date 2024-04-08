# Intalació de paquets
install.packages("rvest")
install.packages("dplyr")


# Càrrega de llibreries
library(rvest)
library(dplyr)


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

# Per cada un dels link aconseguim color, model i nom i els guardem
sneaker_colours = sapply(sneakers_links, FUN = get_colour, USE.NAMES = FALSE)
sneaker_models = sapply(sneakers_links, FUN = get_model, USE.NAMES = FALSE)
sneaker_names = sapply(sneakers_links, FUN = get_name, USE.NAMES = FALSE)


# Obtenció del DF (aquí falla)
sneakers = data.frame(sneaker_colours, sneaker_models, sneaker_names, stringsAsFactors = FALSE)
