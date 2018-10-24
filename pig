dd= load 'file:///home/mercy/Downloads/student.csv' using PigStorage(',') as (sid,name,mark,city);
dd1= foreach dd generate sid,name,city;
dump dd1;
dd2= filter dd by city == 'chennai';
dump dd2;
dd3= order dd2 by city;
dump dd3;
dd4= limit dd3 2;
dump dd4;
store dd into '/home/mercy/Documents/pigops';
illustrate dd;
dd5= group dd all;
dump dd5;
dd6= group dd by city;
dump dd6;
---------------------------------------------------------
A = load '/home/mercy/Downloads/purchase.txt' using PigStorage(',') as (prod:int, pqty:int);
A1 = group A by ($0); 
(101,{(101,30),(101,20)})
(102,{(102,40),(102,25)})
(107,{(107,500)})
(108,{(108,1000)})
-------------------------------------------------------
A2 = foreach A1 generate group, SUM(A.$1);
(101,50)
(102,65)
(107,500)
(108,1000)
--------------------------------------------------------
B = load '/home/mercy/Downloads/sales.txt' using PigStorage(',') as (prod:int, sqty:int);
C = cogroup A by $0, B by $0;
(101,{(101,30),(101,20)},{(101,40),(101,30)})
(102,{(102,40),(102,25)},{(102,50),(102,30)})
(105,{},{(105,100)})
(106,{},{(106,120)})
(107,{(107,500)},{})
(108,{(108,1000)},{})
-------------------------------------------------------------- 
txn = load '/home/mercy/Documents/inputfiles/txns1.txt' using PigStorage(',') as (txnid, txndate, custno:chararray, amount:double, cat, prod, city, state, type);

cust = Load '/home/mercy/Documents/inputfiles/custs.txt' using PigStorage(',') as (custno:chararray, firstname:chararray, lastname, age:int, profession:chararray);
----------------------------------------
txn = foreach txn generate custno, amount;

cust = foreach cust generate custno, firstname;
D = foreach C generate group, SUM(A.pqty), SUM(B.sqty);
(101,50,70)
(102,65,80)
(105,,100)
(106,,120)
(107,500,)
(108,1000,)
---------------------------------------------------------------
A1 = group A all;
(all,{(108,1000),(107,500),(102,40),(101,30),(102,25),(101,20)})
------------------------------------------------------------------
A2 = foreach A1 generate group, SUM(A.$1),AVG(A.$1),COUNT(A.$1),MAX(A.$1);
(all,1615,269.1666666666667,6,1000)
-----------------------------------------------------------------------------
C= union A,B;
(101,20)
(101,30)
(102,25)
(102,30)
(101,30)
(101,40)
(102,40)
(102,50)
(107,500)
(105,100)
(108,1000)
(106,120)
-----------------------------------------------------------------
C= cross A,B;
(108,1000,106,120)
(108,1000,105,100)
(108,1000,102,50)
(108,1000,101,40)
(108,1000,102,30)
(108,1000,101,30)
(107,500,106,120)
(107,500,105,100)
(107,500,102,50)
(107,500,101,40)
(107,500,102,30)
(107,500,101,30)
(102,40,106,120)
(102,40,105,100)
(102,40,102,50)
(102,40,101,40)
(102,40,102,30)
(102,40,101,30)
(101,30,106,120)
(101,30,105,100)
(101,30,102,50)
(101,30,101,40)
(101,30,102,30)
(101,30,101,30)
(102,25,106,120)
(102,25,105,100)
(102,25,102,50)
(102,25,101,40)
(102,25,102,30)
(102,25,101,30)
(101,20,106,120)
(101,20,105,100)
(101,20,102,50)
(101,20,101,40)
(101,20,102,30)
(101,20,101,30)
-----------------------------------------------------------------------
C = join A by $0, B by $0;
(101,30,101,40)
(101,30,101,30)
(101,20,101,40)
(101,20,101,30)
(102,40,102,50)
(102,40,102,30)
(102,25,102,50)
(102,25,102,30)
----------------------------------------------------------------------
C = join A by $0 left outer, B by $0;
(101,30,101,40)
(101,30,101,30)
(101,20,101,40)
(101,20,101,30)
(102,40,102,50)
(102,40,102,30)
(102,25,102,50)
(102,25,102,30)
(107,500,,)
(108,1000,,)
-----------------------------------------------------------
C = join A by $0 right outer, B by $0;
(101,30,101,40)
(101,30,101,30)
(101,20,101,40)
(101,20,101,30)
(102,40,102,50)
(102,40,102,30)
(102,25,102,50)
(102,25,102,30)
(,,105,100)
(,,106,120)
---------------------------------------------------------------
C = join A by $0 full outer, B by $0;
(101,30,101,40)
(101,30,101,30)
(101,20,101,40)
(101,20,101,30)
(102,40,102,50)
(102,40,102,30)
(102,25,102,50)
(102,25,102,30)
(,,105,100)
(,,106,120)
(107,500,,)
(108,1000,,)
-----------------------------------------------------------------
D = foreach C generate group, SUM(A.pqty),COUNT(A), SUM(B.sqty), COUNT(B);
(101,50,2,70,2)
(102,65,2,80,2)
(105,,0,100,1)
(106,,0,120,1)
(107,500,1,,0)
(108,1000,1,,0)
-------------------------------------------------

txn = load '/home/amirtha/Desktop/pigout/pig/txns1.txt' using PigStorage(',') as (txnid, txndate, custno:chararray, amount:double, cat, prod, city, state, type);

cust = Load '/home/amirtha/Desktop/pigout/pig/custs' using PigStorage(',') as (custno:chararray, firstname:chararray, lastname, age:int, profession:chararray);

txn = foreach txn generate custno, amount;
cust = foreach cust generate custno, firstname;


joined = cogroup cust by $0, txn by $0;

final = foreach joined generate cust.firstname, COUNT(txn), ROUND_TO(SUM(txn.amount),2);





















