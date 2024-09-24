title "Example Formation";

data grade;
	input subject gender$ exam1 exam2 hwgrade$; /* $ 표시는 VARCHAR 명시, 디폴트는 NUMBER */
	datalines; /* cards;와 동일하다. */
	10 M 80 84 A
	7 . 85 89 A
	4 F 90 . B
	20 M 82 85 B
	25 F 94 94 A
	14 F 88 84 C
	;
run;

/* 모든 작업 데이터는 Library/Work 폴더 내에 데이터 파일로 저장됨  */

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

/*외부 파일로 저장하기*/
PROC EXPORT DATA=mower OUTFILE="C:\Users\user\Documents\SAS2024\mower(1).xlsx" DBMS=XLSX REPLACE;

SHEET="MYSHEET";

NEWFILE=YES;

RUN;

/* 워크 라이브러리에 영구적인 데이터 생성 */

LIBNAME bios "C:\Users\user\Documents\SAS2024\Data"; /* 영구적으로 저장될 라이브러리 생성 */

data bios.x;
	input x1-x3; /* 변수 이름을 -로 스트라이딩 할 수 있음 */
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

/* 외부 파일을 가져오기 : 프로시저 사용 */
PROC IMPORT OUT=BIOS.mower DATAFILE="C:\Users\user\Documents\SAS2024\Data\mower.csv" DBMS=csv REPLACE;
	GETNAMES=YES;
	DATAROW=2;
run;

/* Data handling */
data mow_y;
	set Bios.mower; /* 포함된 변수들이 동일한 여러 데이터셋의 병합 */
	if ridingmower='yes'; *or where ridingmower='yes';
run;

proc print data=mow_y;
run;

data mow_n;
	set Bios.mower;
	if ridingmower ne 'yes'; /* ne : not equal */
run;

/* 한번에 두 개 생성하기 */
data mow_y1 mow_n1;
	set mower;
	if ridingmower="yes" then output mow_y1;
	else output mow_n1;
run;

/* Concatanate datasets */
data mow_yn;
	set mow_y mow_n;
	label ridingmower="Do they have a riding mower?"; /* 변수 이름 설명 */
run;

/* mower data의 구조와 변수의 형식 등을 파악, 변수명은 입력순이 아닌 오름차순 정렬 */
proc contents data=bios.mower;
run;

/* 레이블이 있으면 레이블 정보까지 표시, 변수명을 입력순서대로 정렬 */
proc contents data=mow_yn order=varnum;
run;

/* Projection. 데이터 열 슬라이싱 */
data mow_yn_sliced;
	set mow_yn(keep=lotsize ridingmower); /* Drop으로 특정 열을 제거도 가능 */
run;

/* appending */
proc append base=mow_y data=mow_n;
run;

data mow_inc;
	set Bios.mower(keep=income ridingmower);
	id=_n_; /* 1부터 시작하는 정수 */
run;

proc sort data=mow_inc;
	by id;
run;

data mow_lot;
	set Bios.mower(drop=income);
	id=_n_;
run;

/* 사실상 Merge라기보단, Concat에 가까운듯. */
data mow_inclot;
	merge mow_inc mow_lot; /* Sorting이 선행되지 않으면 Merge할 수 없음. */
	by id;
run;

/* 4주차지만 여전히 SAS를 배우고 있다 */

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

/* 원본 데이터를 보존 */
data mower_f;
	set Bios.mower;
	format income incgrp. ridingmower $yngrp.;
run;

/* 기본적인 추정량 산출 */
proc means data=mower_f;
	var income;
run;

/* 도수분포표 */
proc freq data=mower_f;
	table income ridingmower income*ridingmower;
run;

proc sort data=Bios.mower out=mower_s; /* mower data를 income으로 정렬하여 mower_s로 저장 */
	by income;
run;

/* 사이에 해당하는 결과를 파일로 저장 */
ods pdf file='mower_mean.pdf'; /*pdf, html, xls, word로 저장, html이 디폴트 */
proc means data=Bios.mower;
	var income lotsize;
run;
ods pdf close;
/*특정 표만 출력하고 싶다면 ods select <output table name>. sas proc ods table names */

/* 파일에 table을 dataset으로 저장하고 싶다면 ods output <output table 이름=데이터셋 이름>*/

/* 띄어쓰기 입력(Name 등) */
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


/* SASHELP 내장 데이터 */
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

proc means data=sashelp.class maxdec=2 fw=10 sum range median; /*sum, range, median만 표시*/
	var age height;
run;

proc means data=sashelp.

/*일변량으로 가능한 모든 것을 해줌*/
proc univariate data=sashelp.class normal plot; /*normal plot : QQ plot을 그려줌*/
	var height;
run;

proc contents data=sashelp.cars;
run;

proc sgplot data=sashelp.cars;
	title "Box Plot: Category = Origin";
	vbox Horsepower / category=Origin; /*y축,x축 변수 표기*/
run;

proc sgplot data=sashelp.cars;
	title

/* 과제 : 지금까지 해온 내용들 전부 해보고 결과를 pdf로 저장해서 올려주시면 됩니다. */
