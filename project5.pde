//Beginning of Project 5

FloatTable data;
int [] years;
float [] emissions;
int yearMin, yearMax,rowCount;
float dataMin,dataMax,plotX1,plotY1,plotX2,plotY2;
int yearInterval=5;

void setup(){
  size(720,480);
  
  //Initialize data
  String datapath = "/data/USmethaneemissions.txt";
  data = new FloatTable(datapath);
  rowCount = data.getRowCount();
  
  String[] lines = loadStrings(datapath);
  years = new int[rowCount];

  //Loop through rows to get array of year values
  for( int row=1; row<=rowCount;row++){
    String[] linesplit = split(lines[row],'|');
    years[row-1] = int(linesplit[1]);
    }

  //Assign Min Max for years and data values
  yearMin = int(data.getColumnMin(0));
  yearMax = int(data.getColumnMax(0));
  dataMin= data.getColumnMin(1);
  dataMax = data.getColumnMax(1);
  
  
  //Create plot area
  plotX1 = 50;
  plotX2 = width - plotX1;
  plotY1 = 60;
  plotY2 = height - plotY1;
  
  smooth();
}

void draw(){
  background(244);
  
  fill(255);
  rectMode(CORNERS);
  noStroke();
  rect(plotX1,plotY1,plotX2,plotY2);
  
  drawYearLabels();
  
  strokeWeight(5);
  stroke(#5679C1);
  drawDataPoints(1);
}

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

void drawYearLabels(){
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
