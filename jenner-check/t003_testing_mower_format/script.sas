/* Adapted from testing.sas: the mower-data handling workflow.
   The DATA-step subsetting (yes/no split, one-pass OUTPUT to two
   datasets), the PROC FORMAT value/value-$ definitions (incgrp income
   bands, $yngrp), and the PROC FREQ crosstab are the author's, run over
   the repo's own riding-mower survey (data/mower(1).csv). The survey is
   loaded here with an inline DATA step so the bundle is self-contained;
   in the original it arrives via PROC IMPORT of the CSV. */

data mower;
	input income lotsize ridingmower $;
	datalines;
60 18.4 yes
85.5 16.8 yes
64.8 21.6 yes
61.5 20.8 yes
87 23.6 yes
110.1 19.2 yes
108 17.6 yes
82.8 22.4 yes
69 20 yes
93 20.8 yes
51 22 yes
81 20 yes
75 19.6 no
52.8 20.8 no
64.8 17.2 no
43.2 20.4 no
84 17.6 no
49.2 17.6 no
59.4 16 no
66 18.4 no
47.4 16.4 no
33 18.8 no
51 14 no
63 14.8 no
;
run;

/* Data handling */
data mow_y;
	set mower;
	if ridingmower='yes';
run;

proc print data=mow_y;
	title "Households with a riding mower";
run;

data mow_n;
	set mower;
	if ridingmower ne 'yes';
run;

/* split into two datasets in one pass */
data mow_y1 mow_n1;
	set mower;
	if ridingmower="yes" then output mow_y1;
	else output mow_n1;
run;

proc contents data=mower;
	title "Mower structure";
run;

/* Grouping formats */
proc format;
	value incgrp low-40="Low"
						40-80="Middle"
						80<-high="High";
	value $yngrp "yes"="Y"
						"no"="N";
run;

data mower_f;
	set mower;
	format income incgrp. ridingmower $yngrp.;
run;

proc means data=mower_f;
	title "Income summary";
	var income;
run;

/* crosstab */
proc freq data=mower_f;
	title "Income by riding-mower crosstab";
	table income ridingmower income*ridingmower;
run;
