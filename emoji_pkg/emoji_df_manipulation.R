library(emo)
library(RSQLite)
library(tidyverse)

# Create the emojis dataframe from the package data
emojis_df <- emo::jis
glimpse(emojis_df)

# Create two dataframes from the one above
# 1. The nested columns
# 2. All other columns

# Extract the three nested columns composed of lists of vectors and keep a mapping column (runes)
list_columns_unnested <- emojis_df %>% 
  select(runes, points, aliases, keywords) %>% 
  tidyr::unnest_longer(col = aliases) %>% 
  unnest_longer(points) %>% 
  unnest_longer(keywords) %>% 
  mutate(emoji_attr_id = row_number())
# Extract all unnested columns
emojis_df_minus_list_cols <- select(emojis_df, -c(points, aliases, keywords))
# Write the dataframes to TSV text files
write_tsv(list_columns_unnested, "/Users/mfm45656/SHARED_DATA/emojis_df_list_columns_unnested.tsv")
write_tsv(emojis_df_minus_list_cols, "/Users/mfm45656/SHARED_DATA/emojis_df_minus_list_cols.tsv")
# Transfer the dataframes to an SQLite DB
home_dir <- Sys.getenv("HOME")
conn <- dbConnect(RSQLite::SQLite(), sprintf("%s/SHARED_DATA/emojis.db", home_dir))
dbWriteTable(conn, "emojis", emojis_df_minus_list_cols)
dbWriteTable(conn, "emoji_attrs", list_columns_unnested)
dbListTables(conn)
dbDisconnect(conn)

