//Beginning of Project 5

FloatTable data;
int [27] years;
float [] emissions;
int yearMin, yearMax;

void setup(){
size(720,480);
data = new FloatTable("/data/USmethaneemissions.txt");
int rowCount = data.getRowCount();

String[] lines = data.getRowNames();
println(lines[0]);
for( int row=0; row<=rowCount-1;row++){
  String[] linesplit = split(lines[row],'|');
  //years[row] = int(linesplit[1]);
 // emissions[row] = float(linesplit[2]);
 println(linesplit[1]);
}
//println(years+"   "+ emissions);
}
