library(sparklyr)
library(tidyverse)
library(DBI)

conf <- spark_config()   
conf$`sparklyr.cores.local`         <- 4
conf$`sparklyr.shell.driver-memory` <- "32G"
conf$`spark.memory.fraction`        <- 0.9
conf$`spark.rpc.message.maxSize`    <- 1024
conf$`spark.driver.maxResultSize`   <- "30G"
conf$`spark.executor.memory`        <- "40G"
conf$`spark.kryoserializer.buffer.max` <- "2000m"
sc <- spark_connect(spark_home = "/opt/cloudera/parcels/CDH-6.3.3-1.cdh6.3.3.p0.1796617/lib/spark",
                     master     = "yarn-client",
                     config     = conf)

test <- dbGetQuery(sc, "select * from gene_gwas_hg38_use.ideas_states where chrom = '1'")
chr1 <- test %>% collect()
nrow(chr1)

