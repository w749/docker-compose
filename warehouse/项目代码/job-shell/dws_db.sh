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

# 用户行为宽表
function user_actions()
{
    # 定义变量
    APP=$1
    hive=$2
    log_date=$3

    sql="
    
    with  
    tmp_order as
    (
        select 
        user_id, 
        sum(oc.total_amount) order_amount, 
        count(*)  order_count
        from "$APP".dwd_order_info  oc
        where date_format(oc.create_time,'yyyy-MM-dd')='$log_date'
        group by user_id
    ),
    tmp_payment as
    (
        select 
        user_id, 
        sum(pi.total_amount) payment_amount, 
        count(*) payment_count 
        from "$APP".dwd_payment_info pi 
        where date_format(pi.payment_time,'yyyy-MM-dd')='$log_date'
        group by user_id
    )

    insert  overwrite table "$APP".dws_user_action partition(dt='$log_date')
    select 
        user_actions.user_id, 
        sum(user_actions.order_count), 
        sum(user_actions.order_amount),
        sum(user_actions.payment_count), 
        sum(user_actions.payment_amount)
    from 
    (
        select 
        user_id, 
        order_count,
        order_amount ,
        0 payment_count , 
        0 payment_amount
        from tmp_order 

        union all
        select 
        user_id, 
        0,
        0, 
        payment_count, 
        payment_amount
        from tmp_payment
    ) user_actions
    group by user_id;

    "

    $hive -e "$sql"
}

function user_sales()
{
    # 定义变量
    APP=$1
    hive=$2
    log_date=$3

    sql="

    set hive.exec.dynamic.partition.mode=nonstrict;

    with
    tmp_detail as
    (
        select 
            user_id,
            sku_id, 
            sum(sku_num) sku_num ,   
            count(*) order_count , 
            sum(od.order_price*sku_num)  order_amount 
        from "$APP".dwd_order_detail od
        where od.dt='$log_date' and user_id is not null
        group by user_id, sku_id
    )  
    insert overwrite table  "$APP".dws_sale_detail_daycount partition(dt='$log_date')
    select 
        tmp_detail.user_id,
        tmp_detail.sku_id,
        u.gender,
        months_between('$log_date', u.birthday)/12  age, 
        u.user_level,
        price,
        sku_name,
        tm_id,
        category3_id ,  
        category2_id ,  
        category1_id ,  
        category3_name ,  
        category2_name ,  
        category1_name ,  
        spu_id,
        tmp_detail.sku_num,
        tmp_detail.order_count,
        tmp_detail.order_amount 
    from tmp_detail 
    left join "$APP".dwd_user_info u 
    on u.id=tmp_detail.user_id  and u.dt='$log_date'
    left join "$APP".dwd_sku_info s on tmp_detail.sku_id =s.id  and s.dt='$log_date';

    "
    $hive -e "$sql"
}

user_actions $APP $hive $log_date
user_sales $APP $hive $log_date