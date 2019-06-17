//Beginning of Project 5


//Initialize global variables
FloatTable data;
int [] years;
float [] emissions;
int yearMin, yearMax;
int rowCount;
float dataMin,dataMax,plotX1,plotY1,plotX2,plotY2,labelX,labelY;
int yearInterval = 1;
int emissionsInterval = 7000;
int emissionsIntervalMinor = 100;
PFont plotFont;

////////////////////////
int updateNum;
Integrator[] interpolators;
// REFINE AND INTERACT VARIABLES
int currentColumn = 0;
int columnCount;

int toggleLine = 0;
float xTrans = 0;
float yTrans = 0;
float zoom = 1;

float tabTop, tabBottom;
float[] tabLeft, tabRight;
float tabPad = 10;
//////////////////////////
void setup(){
  size(1120,720);
  
  //Initialize data
  String datapath = "/data/USmethaneemissions.txt";
  data = new FloatTable(datapath);
  columnCount = data.getColumnCount();
  years = int(data.getRowNames());
  yearMin = years[years.length-1];
  yearMax = years[0];
  dataMax = (round(data.getColumnMax(0))+5000);//data.getTableMax();
  dataMin = (round(data.getColumnMin(0))-1000);
  
  //println(years);
  //println(yearMax);
  //println(yearMin);
  //println(dataMax);
  //println(dataMin);
  
  //Create plot area
  plotX1 = 250;
  plotX2 = width - 80;
  labelX= 160;
  plotY1 = 60;
  plotY2 = height - 70;
  labelY= height - 25;
  rowCount = data.getRowCount();
  
  plotFont = createFont("SansSerif",20);
  textFont(plotFont);

   interpolators = new Integrator[rowCount];
   for ( int row= 0 ; row < rowCount; row++ ) {
     float initialValue = data.getFloat(row,0); 
     interpolators[row] = new Integrator(initialValue);
     interpolators[row].attraction = 0.5; 
   }
   
  updateNum = 0;

  smooth();
}

void draw(){
  
   background(224); // Offwhite background
   
   // Draw the visualization window 
   fill(255);
   rectMode(CORNERS);
   rect(plotX1,plotY1,plotX2,plotY2);
   
   translate(xTrans,yTrans);
   scale(zoom);
  
  //drawing grids, labels, and plot
   drawTitle(); 
   drawAxisLabels();
   drawXDataLabels();
   drawYDataLabels();
   //drawTitleTabs();
   drawDataLine(currentColumn); //1
   dataHighlight(currentColumn); //1
   drawDataPoints(currentColumn); //1
   // drawDataArea(currentColumn);
   // drawDataBars(currentColumn);
   
   for (int row = 0; row < rowCount; row++) { 
    interpolators[row].update( );
  }
}

//Draw chart Title
void drawTitle(){
  fill(0);
  textSize(35);
  textAlign(CENTER);
  //textLeading(15);
  text("Country Methane Emissions ", (plotX1+plotX2)/2, plotY1 - 10);
  //text("Country Methane emissions ",(plotX1+plotX2)/2,plotY1-30);
}

void drawAxisLabels(){
  fill(0);
  textSize(15);
  textLeading(15);
  
  textAlign(CENTER);
  text("Methane Emissions\n in kilotonne\n CO2 equivalent",labelX-50,(plotY1+plotY2)/2);
  textAlign(CENTER);
  text("Year",(plotX1+plotX2)/2, labelY);
}

boolean spaceBarToggle = false;

//Drawing grid and years on X Axis
void drawXDataLabels(){
  fill(0);
  textSize(10);
  textAlign(CENTER,TOP);
  
  // Use thin, gray lines to draw the grid.
  stroke(224);
  strokeWeight(1);


  for (int row = 0; row < rowCount; row++) {
    if (years[row] % yearInterval == 0) {
      float x = map(years[row], yearMin, yearMax, plotX1, plotX2);
      text(years[row], x, plotY2 + 10);
      
      if (toggleLine == 1) {
          line(x, plotY1, x, plotY2);
      }
    }
  }
}

//Draw labels for Y axis
void drawYDataLabels(){
  fill(0);
  textSize(10);
  textAlign(RIGHT);
  
  stroke(128);
  strokeWeight(1);
  
  for (float v = dataMin; v <= dataMax; v += emissionsIntervalMinor){
    //println(v);
    if (v% emissionsIntervalMinor == 0){
      float y = map(v, dataMin,dataMax,plotY2,plotY1);
      if (v % emissionsInterval == 0){
        float textOffset = textAscent()/2;
        if(v ==dataMin){
          textOffset =0 ;
          } 
        else if (v==dataMax) {
        textOffset = textAscent();
          }
        text(floor(v),plotX1-10,y+textOffset);
        line(plotX1-4,y,plotX1,y);
      }   
    }
  }
}

//Connect points to create a line graph- using curveVertex() gives a smoother line
void drawDataLine(int col){
  beginShape();
    strokeWeight(1);
    stroke(#5679C1);
    noFill();
    int rowCount = data.getRowCount();
    for ( int row = 0; row < rowCount; row++ ) {
      if (data.isValid(row,col) ) {
          // float value = interpolators[row].value;
          float value = data.getFloat(row,col);
          float x = map(years[row], yearMin, yearMax, plotX1, plotX2);
          float y = map(value, dataMin, dataMax, plotY2, plotY1);
          curveVertex(x,y);
          if ((row ==0)||(row ==rowCount-1)){
            curveVertex(x,y);
          }
        }
      }
      
  endShape();
}

//Points of the data by x and y
void drawDataPoints(int col){
  strokeWeight(10);
  stroke(#5679C1);
  int rowCount = data.getRowCount();
  for(int row = 0; row < rowCount; row++){
    if (data.isValid(row,col)){
      float value = data.getFloat(row,col);
      float x = map(years[row], yearMin, yearMax, plotX1, plotX2);
      float y = map(value, dataMin, dataMax, plotY2, plotY1);
      point(x,y);
      }
  }
} //<>//

//Enable data hovering that will display the data if cursor is on points
void dataHighlight(int col){
      for ( int row = 0; row < rowCount; row++ ) {
      if (data.isValid(row,col) ) {
          float value = interpolators[row].value;
          float x = map(years[row], yearMin, yearMax, plotX1, plotX2);
          float y = map(value, dataMin, dataMax, plotY2, plotY1);
          if ( dist(mouseX,mouseY, x,y) < 6) {
             strokeWeight(10);
             point(x,y);
             fill(0);
             // We want to generate the text over the point
             textSize(15);
             textAlign(CENTER);
             text( nf(value, 0, 2) + "(" + years[row] + " )" , x, y -10);
            
          }
      }
    }
}

void drawTitleTabs() {
 
  rectMode(CORNERS); 
  noStroke( ); 
  textSize(20); 
  textAlign(LEFT);
  
  // On first use of this method, allocate space for an array
  // to store the values for the left and right edges of the tabs.
  if (tabLeft == null) {
    tabLeft = new float[columnCount];
    tabRight = new float[columnCount];
  }
  float runningX = plotX1;
  tabTop = plotY1 - textAscent() - 15; 
  tabBottom = plotY1;
  for (int col = 0; col < columnCount; col++) {
    String title = data.getColumnName(col);
    tabLeft[col] = runningX;
    float titleWidth = textWidth(title);
    tabRight[col] = tabLeft[col] + tabPad + titleWidth + tabPad;
    // If the current tab, set its background white; otherwise use pale gray.
    fill(col == currentColumn ? 255 : 224);
    rect(tabLeft[col], tabTop, tabRight[col], tabBottom);
    // If the current tab, use black for the text; otherwise use dark gray.
    fill(col == currentColumn ? 0 : 64);
    text(title, runningX + tabPad, plotY1 - 10);
    runningX = tabRight[col];
  }
}

//Ability to turn on/off gridlines – using a button on the screen or by a keyboard button
void mousePressed() {
   if (toggleLine == 0) toggleLine = 1;
  else toggleLine = 0;
  
  xTrans = 0;
  yTrans = 0;
  zoom = 1;


  if (mouseY > tabTop && mouseY < tabBottom) {
    for (int col = 0; col < columnCount; col++) {
      if (mouseX > tabLeft[col] && mouseX < tabRight[col]) {
        setColumn(col);
      }
    }
  }
}

void setColumn(int col) {
    
      if (col != currentColumn) {
         currentColumn = col;
       }
       
      for (int row = 0; row < rowCount; row++) {
          interpolators[row].target(data.getFloat(row, col));
       } 
  
}

void mouseWheel( MouseEvent event) {
  
  xTrans = xTrans-event.getCount()*(mouseX)/100;
  yTrans = yTrans-event.getCount()*(mouseY)/100;
  zoom += event.getAmount() / 100;
  
  
}
