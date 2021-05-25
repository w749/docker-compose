#!/bin/bash

# 定义变量方便修改
APP=mall
hive=hive

# 如果是输入的日期按照取输入日期；如果没输入日期取当前时间的前一天
if [ -n $1 ] ;then
	log_date=$1
else 
	log_date=`date  -d "-1 day"  +%F`  
fi 

sql="

set hive.exec.dynamic.partition.mode=nonstrict;

insert into table "$APP".ads_gmv_sum_day 
select 
'$log_date' dt ,
    sum(order_count)  gmv_count ,
    sum(order_amount) gmv_amount ,
    sum(payment_amount) payment_amount 
from "$APP".dws_user_action 
where dt ='$log_date'
group by dt
;

"
$hive -e "$sql"
