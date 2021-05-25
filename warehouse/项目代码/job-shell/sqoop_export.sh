#!/bin/bash

db_name=mall

export_data() {
sqoop export \
--connect "jdbc:mysql://node02:3306/${db_name}?useUnicode=true&characterEncoding=utf-8"  \
--username root \
--password DBa2020* \
--table $1 \
--num-mappers 1 \
--export-dir /warehouse/$db_name/ads/$1 \
--input-fields-terminated-by "\t"  \
--update-key "tm_id,category1_id,stat_mn,stat_date" \
--update-mode allowinsert \
--input-null-string '\\N'    \
--input-null-non-string '\\N'  
}

case $1 in
  "ads_sale_tm_category1_stat_mn")
     export_data "ads_sale_tm_category1_stat_mn"
;;
   "all")
     export_data "ads_sale_tm_category1_stat_mn"
;;
esac
