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
--update-key "dt" \
--update-mode allowinsert \
--input-null-string '\\N'    \
--input-null-non-string '\\N'  
}

case $1 in
  "ads_gmv_sum_day")
     export_data "ads_gmv_sum_day"
;;
   "all")
     export_data "ads_gmv_sum_day"
;;
esac
