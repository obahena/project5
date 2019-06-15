//Beginning of Project 5


//Initialize global variables
FloatTable data;
int [] years;
float [] emissions;
int yearMin, yearMax;
int rowCount;
float dataMin,dataMax,plotX1,plotY1,plotX2,plotY2,labelX,labelY;
int yearInterval=5;
int emissionsInterval=7000;
int emissionsIntervalMinor=1000;
PFont plotFont;

void setup(){
  size(1020,720);
  
  //Initialize data
  String datapath = "/data/USmethaneemissions.txt";
  data = new FloatTable(datapath);
  rowCount = data.getRowCount();
  
  //Initialize array of years
  String[] lines = loadStrings(datapath);
  years = new int[rowCount];

  //Loop through rows to assign array of year values
  for( int row=1; row<=rowCount;row++){
    String[] linesplit = split(lines[row],'|');
    years[row-1] = int(linesplit[1]);
    }

  //Assign Min/Max for years and data values
  yearMin = int(data.getColumnMin(0));
  yearMax = int(data.getColumnMax(0));
  dataMin= ((round(data.getColumnMin(1))+999)/1000)*1000;
  dataMax = data.getColumnMax(1);
  
  
  //Create plot area
  plotX1 = 150;
  plotX2 = width - 80;
  labelX=60;
  plotY1 = 60;
  plotY2 = height - 70;
  labelY= height-25;
  
  plotFont = createFont("SansSerif",20);
  textFont(plotFont);
  
  smooth();
}

void draw(){
  
  //draw plot
  background(244);
  fill(255);
  rectMode(CORNERS);
  noStroke();
  rect(plotX1,plotY1,plotX2,plotY2);
  
  //drawing grids, labels, and plot
  drawXLabels();
  drawYLabels();
  drawAxisLabels();
  drawTitle();
  dataHighlight(1);
  
  //Draw Data Line
  strokeWeight(1);
  stroke(#5679C1);
  noFill();
  drawDataLine(1);
  
  
  //Draw points for data hovering
  strokeWeight(10);
  stroke(#5679C1);
  drawDataPoints(1);
}

//Connect points to create a line graph- using curveVertex() gives a smoother line
void drawDataLine(int col){
  beginShape();
  int rowCount = data.getRowCount();
  for(int row = 0; row < rowCount; row++){
    if (data.isValid(row,col)){
      float value = data.getFloat(row,col);
      float x = map(years[row],yearMin,yearMax,plotX1,plotX2);
      float y = map(value, dataMin,dataMax,plotY2,plotY1);
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
  int rowCount = data.getRowCount();
  for(int row = 0; row < rowCount; row++){
    if (data.isValid(row,col)){
      float value = data.getFloat(row,col);
      float x = map(years[row],yearMin,yearMax,plotX1,plotX2);
      float y = map(value, dataMin,dataMax,plotY2,plotY1);
      point(x,y);
      }
  }
}


//Drawing grid and years on X Axis
void drawXLabels(){
  fill(0);
  textSize(10);
  textAlign(CENTER,TOP);
  
  //Draw grid
  stroke(224);
  strokeWeight(1);
  
  for( int row =0; row <rowCount; row++){
  if(years[row] % yearInterval ==0) {
    float x = map(years[row],yearMin,yearMax,plotX1,plotX2);
    text(years[row],x,plotY2+5);
    line(x,plotY1,x,plotY2);
    }
  }
}

//Drawing X and Y Titles
void drawAxisLabels(){
  fill(0);
  textSize(15);
  textLeading(15);
  
  textAlign(CENTER);
  text("Methane Emissions\n in kilotonne\n CO2 equivalent",labelX,(plotY1+plotY2)/2);
  textAlign(CENTER);
  text("Year",(plotX1+plotX2)/2, labelY);
}

//Draw chart Title
void drawTitle(){
  fill(0);
  textSize(35);
  textLeading(15);
  
  text("Country Methane emissions ",(plotX1+plotX2)/2,plotY1-30);
}

//Draw labels for Y axis
void drawYLabels(){
  fill(0);
  textSize(10);
  textAlign(RIGHT);
  
  stroke(128);
  strokeWeight(1);
  
  for (float v = dataMin; v <= dataMax; v+=emissionsIntervalMinor){
    println(v);
    if (v% emissionsIntervalMinor == 0){ //<>//
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
      else {
     // line(plotX1-2,y,plotX1,y); uncomment for minor tick marks
           }
    }
  }
}

//Enable data hovering that will display the data if cursor is on points
void dataHighlight(int col){
  for (int row=0; row < rowCount; row++){
    if (data.isValid(row,col)){
    float value = data.getFloat(row,col);
    float x=map(years[row],yearMin,yearMax,plotX1,plotX2);
    float y = map(value,dataMin,dataMax,plotY2,plotY1);
    if (dist(mouseX,mouseY,x,y) < 6){
      strokeWeight(10);
      point(x,y);
      fill(0);
      textSize(15);
      textAlign(CENTER);
      text(nf(value,0,2) + "(Year " +years[row]+ ")",x,y-8);
      }
    }
  }   
}
