library(stringr)
library(here)

slides <- list.files(here("Rmd"), pattern="^[[:digit:]].*Rmd$")

if (!dir.exists(here("script"))) {
  dir.create(here("script"))
}

for (file in slides) {
  path <- here("Rmd", file)
  knitr::purl(path, output=here("script", str_replace(file,"md$","")))
}

if (!dir.exists(here("pdf"))) {
  dir.create(here("pdf"))
}


pdf_slides <- list.files(here("Rmd"), pattern=".*pdf$")

for (file in pdf_slides) {
  path <- here("Rmd", file)
  file.copy(from=path, to=here("pdf"))
  file.remove(path)
}