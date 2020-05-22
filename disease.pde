class person{
  int x, y;
  int oldx, oldy;
  int state;
  int sicktime=0;
  int targetx, targety;
  
  person(int xcord, int ycord, int s){
    x=xcord;
    y=ycord;
    state=s;
    
    targetx = x + int(random(-30,30));
    targety = y + int(random(-30,30));
  }
  
  void update(){
    x+=((targetx-x)/10);
    y+=((targety-y)/10);
    
    if(random(1)>0.9 || targetx==x || targety==y){
      targetx = x + int(random(-30,30));
      targety = y + int(random(-30,30));      
    }
    
    if(x<200){x=200;}
    if(x>800){x=800;}
    if(y<200){y=200;}
    if(y>800){y=800;}        
  
    
    if(state==0){fill(0);}
    if(state==1){fill(255, 0, 0);}
    if(state==2){fill(0, 150, 0);}
    circle(x, y, 10);

    
    if(distancing){
      for(int i=0; i<numDots; i++){
        if(sqrt(sq(people.get(i).x-x)+sq(people.get(i).y-y))<distRadius && people.get(i).x!=x && people.get(i).y!=y){
          x-=40/(people.get(i).x-x);
          y-=40/(people.get(i).y-y);
        }    
      }
    }
    
    if(state==1){
      sicktime++;
      if(sicktime>600){
        totInf--;
        totRec++;
        state=2;
        return;
      }
      
      for(int i=0; i<numDots; i++){
        if(people.get(i).state==0){          
          if(sqrt(sq(people.get(i).x-x)+sq(people.get(i).y-y))<sickRadius && people.get(i).x!=x && people.get(i).y!=y){
            totUnInf--;
            totInf++;
            people.get(i).state=1;
          }
        }
      }
    }
  }
}

String[] settings;

int sickRadius=25;
int t = 0;
boolean distancing = false;
int distAfterNumCases = 10;
int distRadius = 45;

int numDots = 200;
ArrayList<person> people = new ArrayList<person>();
float percUnInf = 0;
float percInf = 0;
float percRec = 0;
float percDead = 0;
int totUnInf;
int totInf = 1;
int totRec = 0;
int totDead = 0;

void setup(){
  settings = loadStrings("data/disease_settings.txt");
  if(match(settings[0], "[0-9]+") != null){
    numDots = int(match(settings[0], "[0-9]+")[0]);
  }
  
  if(match(settings[1], "[0-9]+") != null){
    sickRadius = int(match(settings[1], "[0-9]+")[0]);
  }
  
  if(match(settings[2], "[0-9]+") != null){
    distRadius = int(match(settings[2], "[0-9]+")[0]);
  }
  
  if(match(settings[3], "[0-9]+") != null){
    distAfterNumCases = int(match(settings[3], "[0-9]+")[0]);
  }  
  totUnInf = numDots-1;
  
  size(1000, 1000);
  fill(0);
  for(int i=0; i<numDots-1; i++){
    people.add(new person(int(random(200, 800)), int(random(200, 800)), 0));
  }
  people.add(new person(int(random(200, 800)), int(random(200, 800)), 1));
  fill(255);
  background(255, 255, 255);
  rect(200, 25, 600, 100);
}

void draw(){
  t++;
  fill(255);
  noStroke();
  rect(190, 190, 1000, 1000);
  stroke(0);
  rect(200, 200, 600, 600);
  noStroke();
  for(int i=0; i<numDots; i++){
    people.get(i).update();
  }
  updatePercs();
  if(t%4==0){
    stroke(0);
    line(t/4+200, 25, t/4+200, 125);
    stroke(255, 0, 0);
    line(t/4+200, 125, t/4+200, 125-percInf);
    stroke(0, 150, 0);
    line(t/4+200, 25, t/4+200, 25+percRec);
  }
  
  if(totInf>=distAfterNumCases){
    distancing=true;
  }
  
  noStroke();
  fill(255);
  rect(801, 0, 300, 150);
}

void updatePercs(){
  percUnInf=(float(totUnInf)/float(numDots))*100.0;
  percInf=(float(totInf)/float(numDots))*100.0;
  percRec=(float(totRec)/float(numDots))*100.0;
  percDead=(float(totDead)/float(numDots))*100.0;
}
