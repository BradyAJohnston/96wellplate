//////////////////////////////////////////////////////////////////////////////////////////
// Overhall of the FRET plate / Platereader plugin that I started with. 
//////////////////////////////////////////////////////////////////////////////////////////
// Clearing table with results and removing overlay

run("Clear Results");
run("Remove Overlay");

//////////////////////////////////////////////////////////////////////////////////////////

// Setting default grid parameter values

nc=12; nr=8; xo=192; yo=150; xf=1180; yf=784; csize=40;

//////////////////////////////////////////////////////////////////////////////////////////
// Clear any previous grid, 

 run("Remove Overlay");
//////////////////////////////////////////////////////////////////////////////////////////

waitForUser("Draw a straight line from the middle of A1 to the middle of A12 and press OK.");


//////////////////////////////////////////////////////////////////////////////////////////
//read in line selection coordinates
getLine(x1, y1, x2, y2, lineWidth);
   if (x1==-1)
   //   exit("This macro requires a straight line selection");
 //  getPixelSize(unit, pw, ph);
 //  x1*=pw; y1=ph; x2=pw; y2=ph;
   print("Starting point: (" + x1 + ", " + y1 + ")");
   print("Ending point: (" + x2 + ", " + y2 + ")");
   print("Width:", lineWidth, "pixels");
   dx = x2-x1; dy = y2-y1;
 //  length = sqrt(dx*dx+dy*dy);
 //  print("Length:", length, unit);

   a01x = x1; a01y = y1; a12x = x2; a12y = y2; dax = dx; day = dy;
//////////////////////////////////////////////////////////////////////////////////////////

waitForUser("Draw a line selection from the middle of H1 to the middle of H12 and press OK.");

//////////////////////////////////////////////////////////////////////////////////////////
getLine(x1, y1, x2, y2, lineWidth);
   if (x1==-1)
      exit("This macro requires a straight line selection");
   //getPixelSize(unit, pw, ph);
   //x1*=pw; y1=ph; x2=pw; y2=ph;
   print("Starting point: (" + x1 + ", " + y1 + ")");
   print("Ending point: (" + x2 + ", " + y2 + ")");
   print("Width:", lineWidth, "pixels");
   dx = x2-x1; dy = y2-y1;
 //  length = sqrt(dx*dx+dy*dy);
 //  print("Length:", length, unit);

   h01x = x1; h01y = y1; h12x = x2; h12y = y2; dhx = dx; dhy = dy;
//////////////////////////////////////////////////////////////////////////////////////////

nc=12; nr=8; xo=a01x; yo=a01y; xf=h12x; yf=h12y; csize=40;

csepx=(xf - xo)/11; 

csepy=(yf - yo)/7;

run("Remove Overlay");

for (i=0; i<nr; i++) {
 
	for (j=0; j<nc; j++) {
			xadj = dhx / 7;
			yadj = dhy / 11;
	        makeOval(xo-csize/2+j*(csepx), yo-csize/2+i*(csepy), csize, csize);
	        run("Measure");
	        updateResults();
	} 
 }  

run("Clear Results");

//////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////
// Doing measurements on the chosen grid

for (i=0; i<nr; i++) {

	row=substring("ABCDEFGH",i,i+1);
	
	for (j=0; j<nc; j++) {
			xadj = dhx / 7;
			yadj = dhy / 11;
	        makeOval(xo-csize/2+j*(csepx), yo-csize/2+i*(csepy), csize, csize);
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
// Save out the results.

dir = getDirectory("Choose a Directory"); 
name = getTitle(); 
saveAs("Results",  dir + name + ".csv"); 
//////////////////////////////////////////////////////////////////////////////////////////

