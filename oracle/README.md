### ����������ɺ�,�������������û������ʼ��
docker exec -it oracle11g bash

### Ȼ��ִ�����������л��� oracle �û���
su - oracle

### ��������ִ�����������¼ sqlplus��
sqlplus /nolog
conn /as sysdba

### ִ��������� system �� sys �����˻���������Ϊ abc��
alter user system identified by abc;
alter user sys identified by abc;
ALTER PROFILE DEFAULT LIMIT PASSWORD_LIFE_TIME UNLIMITED;

### ���Ϳ���ͨ��1521�˿ڽ���������
ע:ʹ�õ�[helowin](https://cr.console.aliyun.com/images/cn-hangzhou/helowin/oracle_11g/detail)���ڰ����Ʒ���ľ���,��ò�Ҫ��windows�µ�docker desktop�,һֱ�������Ҳ���
