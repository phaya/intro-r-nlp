library(here)
library(rmarkdown)
library(tidyverse)


slides <- list.files(here("Rmd"), pattern="^[[:digit:]]")

################################################################################
# Render slides to pdfs
################################################################################

if (!dir.exists(here("pdf"))) {
  dir.create(here("pdf"))
}

# render to beamer presentation
for (file in slides) {
  path <- here("Rmd", file)
  render(path, beamer_presentation(theme= "CambridgeUS",
                                   colortheme= "orchid",
                                   fonttheme= "structurebold"), 
         output_dir=here("pdf"))    
}

################################################################################
# Render slides to html
################################################################################

if (!dir.exists(here("html"))) {
  dir.create(here("html"))
}

for (file in slides) {
  path <- here("Rmd",file)
  render(path, ioslides_presentation(widescreen = TRUE), output_dir=here("html"))
}

################################################################################
# Render README to gitbub README 
################################################################################

render(here("Rmd","README.Rmd"), "md_document", encoding = "UTF-8", output_dir=here())

################################################################################
# Render README to html
################################################################################

render(here("Rmd","README.Rmd"), "html_document", encoding = "UTF-8", output_dir=here("html"))

################################################################################
# Render script
################################################################################
library(stringr)

if (!dir.exists(here("script"))) {
  dir.create(here("script"))
}

for (file in slides) {
  path <- here("Rmd", file)
  knitr::purl(path, output=here("script", str_replace(file,"md$","")))
}

################################################################################
# Make distribution file
################################################################################

if (!dir.exists(here("dist"))) {
  dir.create(here("dist"))
}

file.copy(here("pdf"), here("dist"), recursive=TRUE)
file.copy(here("html"), here("dist"), recursive=TRUE)
file.copy(here("script"), here("dist"), recursive=TRUE)

if (!dir.exists(here("dist/data"))) {
  dir.create(here("dist/data"))
}

file.copy(here("data/employee_reviews_10000.csv"), here("dist/data"))

zip(zipfile = here("2023-hr-analytics-nlp.zip"), files = "dist")

