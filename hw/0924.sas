ods pdf file='C:\Users\hcssk\Documents\SAS2024\hw\HW.pdf';

data basic;
	input subj 1-4 name$ 6-23 clinic$ 25-28 gender 30 no_vis 32-33 type_vis 35-37 expense 39-45;
	datalines;
1024 Alice Smith        LEWN 1 7 101 1001.98
1167 Maryann White      LEWN 1 2 101 2999.34
1168 Thomas Jones       ALTO 2 10 190 3904.89
1201 Benedictine Arnold ALTO 2 1 190 1450.23
1302 Felicia Ho         MNMC 1 7 190 1209.94
1471 John Smith         MNMC 2 6 187 1763.09
1980 Jane Smiley        MNMC 1 5 190 3567.00
;
run;

title "테스트";

proc print data=basic(FIRSTOBS = 2 OBS = 5);
	title "2~5번째 관측치";
	var subj name no_vis expense;
run;

proc print data=basic;
	title "no_vis가 5를 초과하는 관측치";
	var name no_vis type_vis expense;
	where no_vis > 5;
run;

proc print data=basic;
	title "이름에 Smi가 포함된 관측치";
	var name gender no_vis type_vis expense;
	where name contains 'Smi';
run;

proc sort data=basic out=srtd_basic;
	by clinic no_vis;
run;

proc print data=srtd_basic NOOBS;
	title "정렬된 basic 자료(관측 번호 제외)";
	var clinic no_vis subj name gender type_vis expense;
run;

proc sort data=basic out=srtd_basic;
	by descending clinic no_vis;
run;

proc print data=srtd_basic NOOBS;
	title "내림차순 정렬된 basic 자료(관측 번호 제외)";
	var clinic no_vis subj name gender type_vis expense;
run;

proc print data=basic;
	title "type_vis가 190인 관측치의 no_vis 총합";
	id name;
	var clinic no_vis;
	where type_vis = 190;
	sum no_vis;
run;

proc sort data=basic out=srtd_basic;
	by clinic;
run;

proc print data=srtd_basic;
	title "clinic 별 총 지출";
	by clinic;
	var subj name no_vis type_vis expense;
	sum expense;
run;

proc print data=basic LABEL;
	title "개인별 지출(달러)";
	label name = 'Name'
			clinic = "Clinic"
			expense = "Expense";
	format expense dollar9.2;
	id name;
	var clinic expense;
run;

/*sashelp.class 이용*/

proc contents data=sashelp.class position;
	title "sashelp.class 자료 정보 개요";
run;

proc freq data=sashelp.class;
	title "성별에 따른 빈도표";
	tables sex;
run;

proc freq data=sashelp.class;
	title "성별에 따른 빈도표(누적 통계량 제외)";
	table sex/nocum; /*누적 통계량 제외*/
run;

proc means data=sashelp.class;
	title "sashelp.class 전체 변수 별 기초통계량";
run;

proc means data=sashelp.class;
	title "일부 변수 기초통계량";
	var age height;
run;

proc means data=sashelp.class maxdec=2 fw=10;
	title "일부 변수 기초통계량 반올림 표시";
	var age height;
run;

proc means data=sashelp.class maxdec=2 fw=10 sum range median;
	title "일부 변수 총합, 범위, 중위수";
	var age height;
run;

proc means data=sashelp.class maxdec=2 fw=10;
	title "성별에 따른 변수 별 기초통계량(반올림 표시)";
	var age height;
	class sex;
run;

proc sort data=sashelp.class out=class2;
	by sex;
run;

proc means data=class2 NOPRINT;
	var age height;
	by sex;
	output out=clsummary
				mean = MeanAge MeanHeight
				median = MedianAge MedianHeight;
run;

proc contents data=clsummary;
	title "그룹화된 자료 정보 개요";
run;

proc univariate data=sashelp.class normal plot;
	title "키에 대한 단변량 분석 종합";
	var height;
run;

/*sashelp.cars 이용*/

proc contents data=sashelp.cars;
	title "sashelp.cars 자료 정보 개요";
run;

proc sgplot data=sashelp.cars;
	title "지역별 차량 마력 상자그림(category = origin)";
	vbox Horsepower / category=Origin;
run;

proc sgplot data=sashelp.cars;
	title "지역별 차량 마력 상자그림(group = origin)";
	vbox Horsepower / group=Origin;
run;

proc sgplot data=sashelp.cars;
	title "실린더별 차량 마력 상자그림";
	vbox horsepower / category=cylinders;
	xaxis type=linear; /*x축 타이트화*/
run;

proc sgplot data=sashelp.cars;
	where Type in ('SUV' 'Truck' 'Sedan');
	title "차종 및 지역별 차량 마력 상자그림";
	vbox horsepower / category=Origin group=Type;
run;

proc sgplot data=sashelp.cars;
	title "바퀴간 거리(x)와 차량무게(y)간 산점도(지역별)";
	scatter x=wheelbase y=weight / markerattrs=(symbol=CircleFilled);
run;

proc sgplot data=sashelp.cars;
	title "바퀴간 거리(x)와 차량무게(y)간 산점도(지역별)";
	scatter x=wheelbase y=weight / markerattrs=(symbol=CircleFilled)
	group=origin;
run;

proc sgplot data=sashelp.cars;
	title "미국 내 바퀴간 거리(x)와 차량무게(y)간 산점도";
	where origin="USA";
	scatter x=wheelbase y=weight /markerattrs=(symbol=CircleFilled);
run;

ods pdf close;
