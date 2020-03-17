//////////////////////////////////////////////////////////////////////////////////////////
// Plugin "Readplate"
// This macro measures the color channels (RGB) of an image of a multi-well plate
// of up to 96 wells.
// Original version written 12-16-2015; latest version (Readplate5) finished 03-10-2016
//
// Jose Maria Delfino
// Department of Biological Chemistry
// School of Pharmacy & Biochemistry
// University of Buenos Aires
// 1113 Buenos Aires, Argentina.
// E-mail: delfino@qb.ffyb.uba.ar
// Phone: 54 11 4962 5506, 54 11 4964 8289/8290/8291, extension 116
//////////////////////////////////////////////////////////////////////////////////////////
//
// INSTALLATION:
// ImageJ is a high-quality public domain software very useful for image processing.
// Download the software from the imagej.nih.gov site. 
// You should have ImageJ installed in your machine in the first place.
// This plugin is a script written in ImageJ macro language (.ijm file).
// After opening ImageJ, install this plugin by doing Plugins > Install… and choosing 
// Readplate from the appropriate directory.
// The plugin readplate should now appear listed under the Plugins menu, and is ready to 
// be launched by clicking Plugins > Readplate. 
//
//////////////////////////////////////////////////////////////////////////////////////////
// Clearing table with results and removing overlay

run("Clear Results");
run("Remove Overlay");

//////////////////////////////////////////////////////////////////////////////////////////

// Setting default grid parameter values

nc=12; nr=8; xo=192; yo=150; xf=1180; yf=784; csize=50;

//////////////////////////////////////////////////////////////////////////////////////////
// Clear any previous grid, 

 run("Remove Overlay");

//////////////////////////////////////////////////////////////////////////////////////////
// Entering grid parameter values

Dialog.create("Grid Parameters");

Dialog.addNumber("Number of Columns (max 12):", nc);

Dialog.addNumber("Number of Rows (max 8):", nr);

Dialog.addNumber("Center of well A1: X origin (in pixels, left equals zero):", xo);

Dialog.addNumber("Center of well A1: Y origin (in pixels, up equals zero):", yo);

Dialog.addNumber("Center of well H12: X end (in pixels):", xf);

Dialog.addNumber("Center of well H12: Y end (in pixels):", yf);

Dialog.addNumber("Circle Size (Diameter in pixels):", csize);

Dialog.show();

//////////////////////////////////////////////////////////////////////////////////////////
// Checking grid parameter values

nc=Dialog.getNumber();

if (nc > 12)
	exit ("The number of columns should be less than or equal to 12");
if (nc < 1)
	exit ("The number of columns should be at least 1");

nr=Dialog.getNumber();

if (nr > 8)
	exit ("The number of rows should be less than or equal to 8");
if (nr < 1)
	exit ("The number of rows should be at least 1");

xo=Dialog.getNumber();

if (xo < 0)
	exit ("The X origin cannot be negative");

yo=Dialog.getNumber();

if (yo < 0)
	exit ("The Y origin cannot be negative");

xf=Dialog.getNumber();

if (xf < xo)
	exit ("The X end cannot be lower than the X origin");

yf=Dialog.getNumber();

if (yf < yo)
	exit ("The Y end cannot be lower than the Y origin");

csize=Dialog.getNumber();

if (csize < 1)
	exit ("The Diameter should be at least one pixel");

csepx=(xf - xo)/11; 

csepy=(yf - yo)/7;

//////////////////////////////////////////////////////////////////////////////////////////
// Building the grid

run("Remove Overlay");

for (i=0; i<nr; i++) {
 
	for (j=0; j<nc; j++) {

	        makeOval(xo-csize/2+j*csepx, yo-csize/2+i*csepy, csize, csize);
	        run("Measure");
	        updateResults();
	} 
 }  

run("Clear Results");

//////////////////////////////////////////////////////////////////////////////////////////
// Checking the grid

ax=0; ay=0; hx=0; hy=0;
grid = "Adjust";

do {
	
grid=newArray("Adjust","Yes");

Dialog.create("Grid check-up");

Dialog.addChoice("Does the grid fit the position of each well?", grid);

Dialog.addSlider("Adjust A1 x", -20, 20, 0);

Dialog.addSlider("Adjust A1 y", -20, 20, 0);

Dialog.addSlider("Adjust H12 x", -20, 20, 0);

Dialog.addSlider("Adjust H12 y", -20, 20, 0);

Dialog.addSlider("Adjust Circumference", -20, 20, 0);
 
Dialog.show();

grid = Dialog.getChoice();

ax = Dialog.getNumber();

ay = Dialog.getNumber();

hx = Dialog.getNumber();

hy = Dialog.getNumber();

cadjust = Dialog.getNumber();

// Makes specified adjustments to the A1 and H12 positions.

xo = xo + ax;
yo = yo + ay;
xf = xf + hx;
yf = yf + hy;
csize = csize + cadjust;

csepx=(xf - xo)/11; 

csepy=(yf - yo)/7;


/// Re-constructs the plate array with the adjustments.

run("Remove Overlay");

for (i=0; i<nr; i++) {
 
	for (j=0; j<nc; j++) {

	        makeOval(xo+ax-csize/2+j*csepx, yo-csize/2+i*csepy, csize, csize);
	        run("Measure");
	        updateResults();
	} 
 }  

run("Clear Results");
} while (grid=="Adjust");


//////////////////////////////////////////////////////////////////////////////////////////
// Doing measurements on the chosen grid

for (i=0; i<nr; i++) {

	row=substring("ABCDEFGH",i,i+1);
	
	for (j=0; j<nc; j++) {

	makeOval(xo-csize/2+j*csepx, yo-csize/2+i*csepy, csize, csize);

                	run("Measure");
                	intensity = getResult("Mean");
	setResult("Row", nResults-1, row);
	setResult("Column", nResults-1, j+1);
	//setResult("Absorbance", nResults-1, -(log(intensity/255)/log(10)));
	setResult("Absorbance", nResults-1, intensity);
	updateResults();

	} 
 }  

//////////////////////////////////////////////////////////////////////////////////////////
// End of plugin FRETplate
//////////////////////////////////////////////////////////////////////////////////////////