-- 进入数据库
use mall;

-- 创建用户行为宽表
drop table if exists dws_user_action;
create  external table dws_user_action 
(   
    user_id         string      comment '用户 id',
    order_count     bigint      comment '下单次数 ',
    order_amount    decimal(16,2)  comment '下单金额 ',
    payment_count   bigint      comment '支付次数',
    payment_amount  decimal(16,2) comment '支付金额 '
) COMMENT '每日用户行为宽表'
PARTITIONED BY ( `dt` string)
stored as  parquet 
location '/warehouse/mall/dws/dws_user_action/'
tblproperties ("parquet.compression"="snappy");

-- 创建用户购买商品明细表
drop table if exists  dws_sale_detail_daycount;
create external table  dws_sale_detail_daycount
(   user_id   string  comment '用户 id',
    sku_id    string comment '商品 Id',
    user_gender  string comment '用户性别',
    user_age string  comment '用户年龄',
    user_level string comment '用户等级',
    order_price decimal(10,2) comment '订单价格',
    sku_name string   comment '商品名称',
    sku_tm_id string   comment '品牌id',
    sku_category3_id string comment '商品三级品类id',
    sku_category2_id string comment '商品二级品类id',
    sku_category1_id string comment '商品一级品类id',
    sku_category3_name string comment '商品三级品类名称',
    sku_category2_name string comment '商品二级品类名称',
    sku_category1_name string comment '商品一级品类名称',
    spu_id  string comment '商品 spu',
    sku_num  int comment '购买个数',
    order_count string comment '当日下单单数',
    order_amount string comment '当日下单金额'
) COMMENT '用户购买商品明细表'
PARTITIONED BY ( `dt` string)
stored as  parquet 
location '/warehouse/mall/dws/dws_user_sale_detail_daycount/'
tblproperties ("parquet.compression"="snappy");
