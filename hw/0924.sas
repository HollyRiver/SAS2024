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

title "�׽�Ʈ";

proc print data=basic(FIRSTOBS = 2 OBS = 5);
	title "2~5��° ����ġ";
	var subj name no_vis expense;
run;

proc print data=basic;
	title "no_vis�� 5�� �ʰ��ϴ� ����ġ";
	var name no_vis type_vis expense;
	where no_vis > 5;
run;

proc print data=basic;
	title "�̸��� Smi�� ���Ե� ����ġ";
	var name gender no_vis type_vis expense;
	where name contains 'Smi';
run;

proc sort data=basic out=srtd_basic;
	by clinic no_vis;
run;

proc print data=srtd_basic NOOBS;
	title "���ĵ� basic �ڷ�(���� ��ȣ ����)";
	var clinic no_vis subj name gender type_vis expense;
run;

proc sort data=basic out=srtd_basic;
	by descending clinic no_vis;
run;

proc print data=srtd_basic NOOBS;
	title "�������� ���ĵ� basic �ڷ�(���� ��ȣ ����)";
	var clinic no_vis subj name gender type_vis expense;
run;

proc print data=basic;
	title "type_vis�� 190�� ����ġ�� no_vis ����";
	id name;
	var clinic no_vis;
	where type_vis = 190;
	sum no_vis;
run;

proc sort data=basic out=srtd_basic;
	by clinic;
run;

proc print data=srtd_basic;
	title "clinic �� �� ����";
	by clinic;
	var subj name no_vis type_vis expense;
	sum expense;
run;

proc print data=basic LABEL;
	title "���κ� ����(�޷�)";
	label name = 'Name'
			clinic = "Clinic"
			expense = "Expense";
	format expense dollar9.2;
	id name;
	var clinic expense;
run;

/*sashelp.class �̿�*/

proc contents data=sashelp.class position;
	title "sashelp.class �ڷ� ���� ����";
run;

proc freq data=sashelp.class;
	title "������ ���� ��ǥ";
	tables sex;
run;

proc freq data=sashelp.class;
	title "������ ���� ��ǥ(���� ��跮 ����)";
	table sex/nocum; /*���� ��跮 ����*/
run;

proc means data=sashelp.class;
	title "sashelp.class ��ü ���� �� ������跮";
run;

proc means data=sashelp.class;
	title "�Ϻ� ���� ������跮";
	var age height;
run;

proc means data=sashelp.class maxdec=2 fw=10;
	title "�Ϻ� ���� ������跮 �ݿø� ǥ��";
	var age height;
run;

proc means data=sashelp.class maxdec=2 fw=10 sum range median;
	title "�Ϻ� ���� ����, ����, ������";
	var age height;
run;

proc means data=sashelp.class maxdec=2 fw=10;
	title "������ ���� ���� �� ������跮(�ݿø� ǥ��)";
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
	title "�׷�ȭ�� �ڷ� ���� ����";
run;

proc univariate data=sashelp.class normal plot;
	title "Ű�� ���� �ܺ��� �м� ����";
	var height;
run;

/*sashelp.cars �̿�*/

proc contents data=sashelp.cars;
	title "sashelp.cars �ڷ� ���� ����";
run;

proc sgplot data=sashelp.cars;
	title "������ ���� ���� ���ڱ׸�(category = origin)";
	vbox Horsepower / category=Origin;
run;

proc sgplot data=sashelp.cars;
	title "������ ���� ���� ���ڱ׸�(group = origin)";
	vbox Horsepower / group=Origin;
run;

proc sgplot data=sashelp.cars;
	title "�Ǹ����� ���� ���� ���ڱ׸�";
	vbox horsepower / category=cylinders;
	xaxis type=linear; /*x�� Ÿ��Ʈȭ*/
run;

proc sgplot data=sashelp.cars;
	where Type in ('SUV' 'Truck' 'Sedan');
	title "���� �� ������ ���� ���� ���ڱ׸�";
	vbox horsepower / category=Origin group=Type;
run;

proc sgplot data=sashelp.cars;
	title "������ �Ÿ�(x)�� ��������(y)�� ������(������)";
	scatter x=wheelbase y=weight / markerattrs=(symbol=CircleFilled);
run;

proc sgplot data=sashelp.cars;
	title "������ �Ÿ�(x)�� ��������(y)�� ������(������)";
	scatter x=wheelbase y=weight / markerattrs=(symbol=CircleFilled)
	group=origin;
run;

proc sgplot data=sashelp.cars;
	title "�̱� �� ������ �Ÿ�(x)�� ��������(y)�� ������";
	where origin="USA";
	scatter x=wheelbase y=weight /markerattrs=(symbol=CircleFilled);
run;

ods pdf close;
