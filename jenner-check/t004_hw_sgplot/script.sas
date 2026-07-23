/* Adapted from hw/0924.sas: the PROC SGPLOT graphics block over the
   built-in sashelp.cars dataset. The vbox box-plots (category= and
   group=, with a WHERE filter on Type) and the grouped scatter with
   markerattrs= are the author's; the script runs unmodified against
   sashelp.cars, which ships with the engine. Each plot is rendered to
   ods_output/*.png / *.svg in the run's files. */

proc sgplot data=sashelp.cars;
	title "Horsepower box plot, category = Origin";
	vbox Horsepower / category=Origin;
run;

proc sgplot data=sashelp.cars;
	where Type in ('SUV' 'Truck' 'Sedan');
	title "Horsepower box plot by Origin, grouped by Type";
	vbox horsepower / category=Origin group=Type;
run;

proc sgplot data=sashelp.cars;
	title "Wheelbase vs Weight scatter, grouped by Origin";
	scatter x=wheelbase y=weight / markerattrs=(symbol=CircleFilled)
	group=origin;
run;
