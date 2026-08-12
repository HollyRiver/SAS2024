/* Adapted from hw/0924.sas: descriptive-statistics workflow over the
   built-in sashelp.class dataset. PROC CONTENTS, FREQ (with /nocum),
   MEANS (maxdec/fw options, CLASS grouping, NOPRINT + OUTPUT summary),
   and UNIVARIATE with the normal/plot options are all the author's;
   the script runs verbatim against sashelp.class, which ships with the
   engine, so no data substitution was needed. */

proc contents data=sashelp.class position;
	title "sashelp.class structure";
run;

proc freq data=sashelp.class;
	title "Frequency of Sex";
	tables sex;
run;

proc freq data=sashelp.class;
	title "Frequency of Sex (no cumulative)";
	table sex/nocum;
run;

proc means data=sashelp.class;
	title "Descriptive statistics for age and height";
	var age height;
run;

proc means data=sashelp.class maxdec=2 fw=10 sum range median;
	title "Sum, range, median";
	var age height;
run;

proc means data=sashelp.class maxdec=2 fw=10;
	title "By sex";
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
	title "Summary dataset structure";
run;

proc univariate data=sashelp.class normal plot;
	title "Height distribution";
	var height;
run;
