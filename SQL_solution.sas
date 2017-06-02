
/* answer 1*/

proc sql;
create table NPI_BENE as 
select sum(BENE_COUNT)/COUNT(DISTINCT NPI)as NPIII from cc.PARTD_PUF_NPI_SUMMARY_2014;

/*
data cc.ans1;
set NPI_BENE;
run;
*/

proc print data = NPI_BENE; run;

/*  ans 2*/
proc sql;
create table ans2 as
select sum(TOTAL_DAY_SUPPLY)/sum(TOTAL_CLAIM_COUNT) as avg, NPI
from cc.PARTD_PUF_NPI_SUMMARY_2014
group by NPI;

proc sort data =ans2;by avg;
run;

proc means data =ans2 median;
VAR avg;
output out = med median=median;
run;

/* ans 3*/

proc sql;
create table ans3 as
select SPECIALTY_DESCRIPTION,sum(BRAND_CLAIM_COUNT) as BC, sum(total_claim_count) as BGC,sum(BRAND_CLAIM_COUNT)/sum(total_claim_count) as F
from cc.PARTD_PUF_NPI_SUMMARY_2014
group by SPECIALTY_DESCRIPTION
having  BGC >1000
;

proc sort data =ans3;by F;run;
proc means data =ans3 STDDEV;
run;

/* assuming state all across the world*/
proc sql;
create table answer4 as
select sum(OPIOID_BENE_COUNT)/sum(ANTIBIOTIC_BENE_COUNT) as ratio, NPPES_PROVIDER_STATE
from cc.PARTD_PUF_NPI_SUMMARY_2014
group by NPPES_PROVIDER_STATE
order by ratio;

proc sql;
create table ans4a as 
select (max(ratio)-min(ratio)) as diff
from answer4;
proc print data =ans4a; run;

/* ans5*/

proc sql;
create table ans5 as
select NPI,sum(BENE_COUNT_GE65)/sum(TOTAL_CLAIM_COUNT)as f_GE65, sum(LIS_CLAIM_COUNT)/sum(TOTAL_CLAIM_COUNT) as f_LIS
from cc.PARTD_PUF_NPI_SUMMARY_2014
group by NPI;
 
proc corr data =ans5;
var f_GE65 f_LIS;
run;

/* ans 6*/

proc sql;
create table q6 as
select sum(opioid_day_supply) as no_of_days_supply,
count(npi) as no_prviders, (sum(opioid_day_supply)/count(npi)) as avg_length_sub
from cc.PARTD_PUF_NPI_SUMMARY_2014;
proc print data=q6;run;

proc sql;
create table q6_1 as 
select nppes_provider_state, specialty_description,
sum(opioid_day_supply) as total_supply, count(nppes_provider_state) as total_count_of_providers,
(sum(opioid_day_supply)/count(nppes_provider_state)) as avg_length
from cc.PARTD_PUF_NPI_SUMMARY_2014
group by nppes_provider_state, specialty_description
having count(nppes_provider_state) > 100 and count(specialty_description) > 100;
proc print data=q6_1;run;

proc sql;
create table q6_2 as 
select specialty_description,
sum(opioid_day_supply) as total_supply, count(specialty_description) as total_count_of_providers,
(sum(opioid_day_supply)/count(specialty_description)) as avg_length
from cc.PARTD_PUF_NPI_SUMMARY_2014
group by specialty_description;
proc print data=q6_2;run;

proc sql;
select max(avg_length) as max_length, (select min(avg_length) from q6_2 where avg_length > 0) as min_length
from q6_1;



/*ans7*/
proc sql;
create table ans7a as
select NPI, sum(TOTAL_DRUG_COST)/sum(TOTAL_DAY_SUPPLY) as avg_days_14
from  cc.PARTD_PUF_NPI_SUMMARY_2014
group by NPI;

proc sort data =ans7a;by NPI;run;

proc sql;
create table ans7b as
select NPI, sum(TOTAL_DRUG_COST)/sum(TOTAL_DAY_SUPPLY) as avg_days_13
from  cc.PARTD_PUF_NPI_SUMMARY_2013
group by NPI;
proc sort data =ans7b;by NPI;run;
data cc.comb_7;
merge ans7a(IN=a) ans7b(IN=b);
by NPI;
run;

proc sql;
create table ans7f as
select NPI, sum(avg_days_14-avg_days_13) as inflation
from cc.comb_7
group by NPI;

/*
proc means data=ans7f;
var inflation;
run;
*/
proc sql;
create table ans7fsql as
select sum(inflation)/count(NPI),avg(inflation)
from ans7f;
proc print data = ans7fsql;run;


/* ans8*/

proc sql;
create table ans8a as
select count(NPI) as NPI_14, SPECIALTY_DESCRIPTION
from cc.PARTD_PUF_NPI_SUMMARY_2014
group by SPECIALTY_DESCRIPTION;



proc sql;
create table ans8b as
select count(NPI) as NPI_13, SPECIALTY_DESCRIPTION
from cc.PARTD_PUF_NPI_SUMMARY_2013
group by SPECIALTY_DESCRIPTION;

proc sort data =ans8a; by SPECIALTY_DESCRIPTION;run;
proc sort data =ans8b; by SPECIALTY_DESCRIPTION;run;

data cc.comb8f;
merge ans8a(in=a)  ans8b(in=b);
by SPECIALTY_DESCRIPTION;
run;

proc sql;
create table anser8a as
select SPECIALTY_DESCRIPTION,sum(NPI_14-NPI_13)/NPI_14 as frac
from cc.comb8f
group by SPECIALTY_DESCRIPTION
having NPI_13>1000;

proc means data =anser8a max;
var frac;
run;