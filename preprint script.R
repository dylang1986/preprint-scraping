library(jsonlite)
library(revtools)
library(stringr)
library(rvest)

#reading the JSON file from the BioRxiv and MedRxiv repository for COVID articles.
jfile <- fromJSON("https://connect.biorxiv.org/relate/collection_json.php?grp=181")

#convert JSON to dataframe
df <- as.data.frame(jfile)

#drop some columns and rename
df <- df[-c(1,2)]
names(df)[1] <- "title"
names(df)[2] <- "doi"
names(df)[3] <- "URL"
names(df)[4] <- "abstract"
names(df)[5] <- "author"
names(df)[6] <- "date"
names(df)[7] <- "journal"

#extract year for indexing
df$year <- substr(df$date, 1, 4)

#create bib or ris file
write_bibliography(df, filename="test.bib", format="bib")
write_bibliography(df, filename="test.ris", format="ris")

#testing to see if file is created correctly
read_bibliography("test.bib")
read_bibliography("test.ris")


#Download all files -- **NOTE** this last piece takes hours to run due to volume of pdfs to scrape; please comment out if you don't want to grrab
title <- df$title
i <- 1

for (id in df$doi){
  df.url = toString(paste0('https://www.medrxiv.org/content/',id,"v1.full.pdf"))
  df.name <- toString(paste0('bibstuff/',title[i],'.pdf'))
  try(download.file(df.url,df.name))
  i<- i +1
}
