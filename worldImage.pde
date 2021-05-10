int Year;
int Length;
String Title;
String Subject;
int rowCount;
int columnCount;
Table table;

float plotX1, plotY1;
float plotX2, plotY2;
float labelX, labelY;
PFont plotFont;

String[] country = new String[736];
int[] age = new int[736];

  String[] team = new String[32];
  float[] sumAge = new float[32]; 
  float[] teamNum = new float[32];

void setup() {
  size(1360, 700);
  
  table = loadTable("worldcupplayerinfo.tsv", "header");
  rowCount = table.getRowCount( );
  columnCount = table.getColumnCount( );
  println(table.getRowCount() + " total rows in table / " + table.getColumnCount() + " total col in table");
  int i = 0;
  for (TableRow row : table.rows()) {
    
    country[i] = row.getString("Country");
    age[i] = row.getInt("Age");
    
    i = i+1;
  }
  
  //for(int j=0 ; j<736 ; j++)
  //{
  //      println(j +":"+country[j] + "-->" + age[j] );
  //}
  
  //String[] team = new String[32];
  //double[] sumAge = new double[32]; 
  String tempTeam = "Brazil";
  double tempAge =0;
  int l=0 ;
  double diff = 0;
  int n = 1;
  for(int k=0 ; k<736 ; k++)
  {
    
      if( country[k].equals(tempTeam) == true ) 
      {
        tempAge = tempAge + age[k] + diff;
        team[l] = country[k];
        sumAge[l] = (float)(tempAge/n);
        tempTeam = country[k];
        diff = 0;
        n = n+1;
      }
      else if( country[k].equals(tempTeam) == false ) 
      {
        tempAge = 0;
        team[l+1] = country[k];
        sumAge[l+1] = (float)(tempAge + age[k]); 
        tempTeam = country[k];
        diff = sumAge[l+1];
        l = l+1;
        n = 1;
      }
    
        
  }
  
  
  
  //for(int j=0 ; j<32 ; j++)
  //{
  //      println(j +":"+team[j] + "-->" + sumAge[j] );
  //}
  
  
  // Corners of the plotted time series
    plotX1 = 180;
    plotX2 = width - 80;
    labelX = 50;
    plotY1 = 60;
    plotY2 = height - 70;
    labelY = height - 25;
    plotFont = createFont("SansSerif", 20);
    textFont(plotFont);
    smooth( );


    for(int q=0; q<32 ; q++){
      teamNum[q] = q+1;
    }

}

void draw() {
  background(#d0f3ff);
  // Show the plot area as a white box
  fill(255);
  rectMode(CORNERS);
  noStroke( );
  rect(plotX1, plotY1, plotX2, plotY2);
  drawTitle( );
  drawAxisLabels( );
  drawYearLabels( );
  drawVolumeLabels( );
  stroke(#f44949);
  strokeWeight(16);
  drawDataPoints();
  
}



void drawDataPoints(){
  for (int row = 0; row < 32; row++) {
        
    
        float x = map(teamNum[row], teamNum[0], teamNum[31], plotX1, plotX2);
        float y = map(sumAge[row], min(sumAge), max(sumAge), plotY1+40, plotY2-40);
        
        //println("x: " + teamNum[row] + "-->" + x + " y: " + sumAge[row] +"-->"+ y);
        //println("x: " + teamNum[row] + " y: " + sumAge[row]);
        point(x, y);
  }
}


void drawTitle( ) {
  fill(0);
  textSize(14);
  textAlign(LEFT);
  String title = "Mean of age World cup players";
  text(title, plotX1, plotY1 - 10);
}


void drawAxisLabels( ) {
  fill(0);
  textSize(13);
  textLeading(15);
  textAlign(CENTER, CENTER);
  // Use \n (aka enter or linefeed) to break the text into separate lines.
  text("mean of \n player age\n in world cup", labelX, (plotY1+plotY2)/2);
  textAlign(CENTER);
  text("Team", (plotX1+plotX2)/2, labelY);
}


void drawYearLabels( ) {
  int dis = 4;
  fill(0);
  textSize(8);
  textAlign(CENTER, TOP);
  // Use thin, gray lines to draw the grid.
  stroke(224);
  strokeWeight(1);
  for (int row = 0; row < 32; row++) {
    
      float x = map(teamNum[row], teamNum[0], teamNum[31], plotX1, plotX2);
      
      line(x, plotY1, x, plotY2);
      //rotate(45);
      text(team[row], x, plotY2 + dis);
      dis = -dis;

  }
}

float volumeIntervalMinor=0.05;
float volumeInterval = 0.1;
void drawVolumeLabels( ) {
  fill(0);
  textSize(8);
  stroke(128);
  strokeWeight(1);
  for (float v = min(sumAge); v <= max(sumAge); v = v + 0.2) {
    //if (v % volumeIntervalMinor == 0) { // If a tick mark
      float y = map(v, max(sumAge), min(sumAge), plotY1+40, plotY2-40);
     // if (v % volumeInterval == 0) { // If a major tick mark
        if (v == min(sumAge)) {
          textAlign(BOTTOM); // Align by the bottom
        } 
        else if (v == max(sumAge)) {
          textAlign(RIGHT, TOP); // Align by the top
        } 
        else {
          textAlign(RIGHT, CENTER); // Center vertically
        }
        text(v, plotX1 - 10, y);
        line(plotX1 - 4, y, plotX1, y); // Draw major tick
      //} 
      //else {
      // Commented out; too distracting visually
      //line(plotX1 - 2, y, plotX1, y); // Draw minor tick
     // }
    //}
  }
}
