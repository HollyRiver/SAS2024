title "Example Formation";

data grade;
	input subject gender$ exam1 exam2 hwgrade$; /* $ ǥ�ô� VARCHAR ���, ����Ʈ�� NUMBER */
	datalines; /* cards;�� �����ϴ�. */
	10 M 80 84 A
	7 . 85 89 A
	4 F 90 . B
	20 M 82 85 B
	25 F 94 94 A
	14 F 88 84 C
	;
run;

/* ��� �۾� �����ʹ� Library/Work ���� ���� ������ ���Ϸ� �����  */

proc print data=grade;
	var subject gender;
run;

data test;
	input char$;
	datalines;
	" "
	;
run;

proc print data=test;
run;

/*�ܺ� ���Ϸ� �����ϱ�*/
PROC EXPORT DATA=mower OUTFILE="C:\Users\user\Documents\SAS2024\mower(1).xlsx" DBMS=XLSX REPLACE;

SHEET="MYSHEET";

NEWFILE=YES;

RUN;

/* ��ũ ���̺귯���� �������� ������ ���� */

LIBNAME bios "C:\Users\user\Documents\SAS2024\Data"; /* ���������� ����� ���̺귯�� ���� */

data bios.x;
	input x1-x3; /* ���� �̸��� -�� ��Ʈ���̵� �� �� ���� */
	datalines;
		1 1 12.4 
		1 2 11.3 
		1 3 1.4 
		2 1 2.1 
		2 2 19.4 
		2 3 10.0 
		;
run;

proc print data=bios.x; run;

/* �ܺ� ������ �������� : ���ν��� ��� */
PROC IMPORT OUT=BIOS.mower DATAFILE="C:\Users\user\Documents\SAS2024\Data\mower.csv" DBMS=csv REPLACE;
	GETNAMES=YES;
	DATAROW=2;
run;

/* Data handling */
data mow_y;
	set Bios.mower; /* ���Ե� �������� ������ ���� �����ͼ��� ���� */
	if ridingmower='yes'; *or where ridingmower='yes';
run;

proc print data=mow_y;
run;

data mow_n;
	set Bios.mower;
	if ridingmower ne 'yes'; /* ne : not equal */
run;

/* �ѹ��� �� �� �����ϱ� */
data mow_y1 mow_n1;
	set mower;
	if ridingmower="yes" then output mow_y1;
	else output mow_n1;
run;

/* Concatanate datasets */
data mow_yn;
	set mow_y mow_n;
	label ridingmower="Do they have a riding mower?"; /* ���� �̸� ���� */
run;

/* mower data�� ������ ������ ���� ���� �ľ�, �������� �Է¼��� �ƴ� �������� ���� */
proc contents data=bios.mower;
run;

/* ���̺��� ������ ���̺� �������� ǥ��, �������� �Է¼������ ���� */
proc contents data=mow_yn order=varnum;
run;

/* Projection. ������ �� �����̽� */
data mow_yn_sliced;
	set mow_yn(keep=lotsize ridingmower); /* Drop���� Ư�� ���� ���ŵ� ���� */
run;

/* appending */
proc append base=mow_y data=mow_n;
run;

data mow_inc;
	set Bios.mower(keep=income ridingmower);
	id=_n_; /* 1���� �����ϴ� ���� */
run;

proc sort data=mow_inc;
	by id;
run;

data mow_lot;
	set Bios.mower(drop=income);
	id=_n_;
run;

/* ��ǻ� Merge��⺸��, Concat�� ������. */
data mow_inclot;
	merge mow_inc mow_lot; /* Sorting�� ������� ������ Merge�� �� ����. */
	by id;
run;

/* 4�������� ������ SAS�� ���� �ִ� */

/* heading */
proc print data=Bios.mower(obs=10);
run;

/* Generating Grouping Format */
proc format;
	value incgrp low-40="Low"
						40-80="Middle"
						80<-high="High";
	value $yngrp "yes"="Y"
						"no"="N";
run;

proc print data=Bios.mower;
	format income incgrp. ridingmower $yngrp.;
run;

/* ���� �����͸� ���� */
data mower_f;
	set Bios.mower;
	format income incgrp. ridingmower $yngrp.;
run;

/* �⺻���� ������ ���� */
proc means data=mower_f;
	var income;
run;

/* ��������ǥ */
proc freq data=mower_f;
	table income ridingmower income*ridingmower;
run;

proc sort data=Bios.mower out=mower_s; /* mower data�� income���� �����Ͽ� mower_s�� ���� */
	by income;
run;

/* ���̿� �ش��ϴ� ����� ���Ϸ� ���� */
ods pdf file='mower_mean.pdf'; /*pdf, html, xls, word�� ����, html�� ����Ʈ */
proc means data=Bios.mower;
	var income lotsize;
run;
ods pdf close;
/*Ư�� ǥ�� ����ϰ� �ʹٸ� ods select <output table name>. sas proc ods table names */

/* ���Ͽ� table�� dataset���� �����ϰ� �ʹٸ� ods output <output table �̸�=�����ͼ� �̸�>*/

/* ���� �Է�(Name ��) */
data basic;
	input subj 1-4 name $ 6-23 clinic $ 25-28 gender 30 no_vis 32-33 type_vis 35-37 expense 39-45;
	datalines;
1024 Alice Smith		 	LEWN 1 7 101 1001.98
1167 Maryann White		LEWN 1 2 101 2999.34
1168 Thomas Jones 	ALTO 2 10 190 3904.89
1201 Benedictine Arnold ALTO 2 1 190 1450.23
1302 Felicia Ho 			MNMC 1 7 190 1209.94
1471 John Smith 			MNMC 2 6 187 1763.09
1980 Jane Smiley 			MNMC 1 5 190 3567.00
	;
run;

/*selecting observations*/
proc print data=basic(firstobs=2 obs=5);
	var subj name no_vis expense;
run;

proc print data=basic;
	var name no_vis type_vis expense;
	where no_vis > 5;
run;

proc print data=basic;
	var name gender no_vis type_vis expense;
	where name contains 'Smi';
run;

proc sort data=basic out=srtd_basic;
	by clinic no_vis;
run;

proc print data=srtd_basic NOOBS;
	var clinic no_vis subj name gender type_vis expense;
run;

proc sort data=basic out=srtd_basic;
	by descending clinic no_vis;
run;

/* Column Totals */
proc print data=basic;
	id name;
	var clinic no_vis;
	where type_vis=190;
	sum no_vis;
run;

proc sort data=basic out=srtd_basic;
	by clinic;
run;

proc print data = srtd_basic;
	by clinic;
	var subj name no_vis type_vis expense;
	sum expense;
run;


/* SASHELP ���� ������ */
proc contents data=sashelp.class position;
run;

title 'Frequency of Sex';
proc freq data=sashelp.class;
	tables sex;
run;

proc freq data=sashelp.class;
	tables sex/nocum; /* no cumulate */
run;

proc means data=sashelp.class;
run;

proc means data=sashelp.class;
	var age height;
run;

proc means data=sashelp.class maxdec=2 fw=10; /*max decimal, full wording*/
	var age height;
run;

proc means data=sashelp.class maxdec=2 fw=10 sum range median; /*sum, range, median�� ǥ��*/
	var age height;
run;

proc means data=sashelp.

/*�Ϻ������� ������ ��� ���� ����*/
proc univariate data=sashelp.class normal plot; /*normal plot : QQ plot�� �׷���*/
	var height;
run;

proc contents data=sashelp.cars;
run;

proc sgplot data=sashelp.cars;
	title "Box Plot: Category = Origin";
	vbox Horsepower / category=Origin; /*y��,x�� ���� ǥ��*/
run;

proc sgplot data=sashelp.cars;
	title

/* ���� : ���ݱ��� �ؿ� ����� ���� �غ��� ����� pdf�� �����ؼ� �÷��ֽø� �˴ϴ�. */
