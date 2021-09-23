library(readr)
library(tidyr)
library(RSQLite)

# Read CSVs into tibbles
ideas_metadata <- readr::read_csv("ideas_metadata.csv")
ideas_para_meta <- readr::read_csv("ideas_para_meta.csv")
ideas_para <- readr::read_csv("ideas_para.csv")
ideas_state_sample <- readr::read_csv("ideas_states_sample.csv")
# Convert wide tables to long versions
ideas_state_sample_long <- ideas_state_sample %>% tidyr::pivot_longer(cols = starts_with("e"), names_to = "name", values_to = "value")
ideas_para_long <- ideas_para %>% tidyr::pivot_longer(!count, names_to = "name", values_to = "value")
# Push tibbles to SQLite DB
db_conn <-RSQLite::dbConnect(RSQLite::SQLite(), 'ideas_modelling.db')
RSQLite::dbWriteTable(db_conn, 'ideas_metadata', ideas_metadata)
RSQLite::dbWriteTable(db_conn, 'ideas_para_meta', ideas_para_meta)
RSQLite::dbWriteTable(db_conn, 'ideas_para_long', ideas_para_long)
RSQLite::dbWriteTable(db_conn, 'ideas_state_sample_long', ideas_state_sample_long)
RSQLite::dbListTables(db_conn)
RSQLite::dbDisconnect(db_conn)

