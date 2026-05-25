# data_import.R
library(tuikr); library(httr); library(readxl); library(dplyr); library(tidyr); library(lubridate)

import_tufe_data <- function() {
  fiyat_tables <- statistical_tables("6")
  tufe_row <- fiyat_tables |>
    filter(node_type == "istab",
           grepl("Index numbers and rate of changes in the consumer price index",
                 table_name, ignore.case = TRUE)) |> slice(1)
  resp <- GET(tufe_row$table_url,
    add_headers(`User-Agent`="Mozilla/5.0",
                `Accept`="application/vnd.ms-excel, */*",
                `Referer`="https://veriportali.tuik.gov.tr/"))
  tmp <- tempfile(fileext=".xls")
  writeBin(content(resp,"raw"), tmp)
  tufe_raw <- read_excel(tmp, col_names=FALSE)
  tufe_endeks <- tufe_raw[5:25,]
  colnames(tufe_endeks) <- c("year","Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
  tufe_endeks |> mutate(across(everything(), as.numeric)) |>
    pivot_longer(cols=Jan:Dec, names_to="month", values_to="index") |>
    mutate(month_num=match(month,c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")),
           date=as.Date(paste(year,month_num,"1",sep="-"))) |>
    filter(!is.na(index)) |> arrange(date) |> select(date,index)
}
