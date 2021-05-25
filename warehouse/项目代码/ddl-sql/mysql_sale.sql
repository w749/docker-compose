-- 进入数据库
use mall;

-- 创建复购率表
create  table ads_sale_tm_category1_stat_mn
(   
    tm_id varchar(200) comment '品牌id ' ,
    category1_id varchar(200) comment '1级品类id ',
    category1_name varchar(200) comment '1级品类名称 ',
    buycount   varchar(200) comment  '购买人数',
    buy_twice_last varchar(200) comment '两次以上购买人数',
    buy_twice_last_ratio varchar(200) comment  '单次复购率', 
    buy_3times_last   varchar(200) comment   '三次以上购买人数',
    buy_3times_last_ratio varchar(200)  comment  '多次复购率' ,
    stat_mn varchar(200) comment '统计月份',
    stat_date varchar(200) comment '统计日期' 
)  
