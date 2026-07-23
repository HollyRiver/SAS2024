/* Adapted from hw/0924.sas: fixed-column INPUT + PROC PRINT/SORT
   selection (FIRSTOBS/OBS, WHERE, CONTAINS, descending sort, ID/SUM).
   The clinic-visits DATA step and its PROC PRINT logic are the author's;
   only the ODS PDF destination (a Windows path) was removed so the run
   is self-contained and the listing is captured directly. */

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

proc print data=basic(FIRSTOBS = 2 OBS = 5);
	title "Observations 2-5";
	var subj name no_vis expense;
run;

proc print data=basic;
	title "no_vis greater than 5";
	var name no_vis type_vis expense;
	where no_vis > 5;
run;

proc print data=basic;
	title "name contains Smi";
	var name gender no_vis type_vis expense;
	where name contains 'Smi';
run;

proc sort data=basic out=srtd_basic;
	by descending clinic no_vis;
run;

proc print data=srtd_basic NOOBS;
	title "Sorted basic (descending clinic, no_vis)";
	var clinic no_vis subj name gender type_vis expense;
run;

proc print data=basic;
	title "no_vis total for type_vis = 190";
	id name;
	var clinic no_vis;
	where type_vis = 190;
	sum no_vis;
run;
