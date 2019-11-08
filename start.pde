
AudioInput in;
float rotate_angle = 0;
Planet center,big1,big2,a1,a2,a3,a4;

void init_start(){

  in = minim.getLineIn();
  
  //planet object (int x,int x2,int y,int y2,int angle,int size,int intensity)
  center = new Planet(0,0,0,0,20,400,400);
  big1 = new Planet(800,800,800,800,35,300,1000);
  big2 = new Planet(-700,-700,-700,-700,200,300,1000);
  a1 = new Planet(-700,-700,0,0,70,40,2000);
  a2 = new Planet(0,0,-700,-700,15,100,500);
  a3 = new Planet(0,0,700,700,10,50,800);
  a4 = new Planet(500,500,-500,-500,200,20,500);
}

void start_draw(){    
    background(0);
    fill(255);
    textSize(40); 
      text("Scream high to start the game.", 650, 50 );
    textSize(30); 
      text("Your Score : " + score, 850, 1050 );
    stroke(255);
    strokeWeight(2);
    float a = 0;
    
    int step = in.bufferSize() / 200;
    
    pushMatrix();
    translate(width/2,height/2);
    rotate(radians(rotate_angle));
    
    if (rotate_angle >= 360){
      rotate_angle=0;
    }else{
      rotate_angle += 0.15;
    }
    
    //center
    center.display();
    
    //big1
    big1.display();
    
    //big2
    big2.display();
    
    //a1
    a1.display();
    
    //a2
    a2.display();
    
    //a3
    a3.display();

    //a4
    if(a4.x<800){
      a4.update(1,1);
    }else{
      a4.update(-1,-1);
    }
    a4.display();
    
    //a5
    for(int i=0; i < in.bufferSize() - step; i+=step) {
      float angle = (2*PI) / 200;
      float x = 700 + cos(a) * (1000 * in.mix.get(i) + 80);
      float y = 0 + sin(a) * (1000 * in.mix.get(i) + 80);
      float x2 = 700 + cos(a + angle) * ((1000+rotate_angle) * in.mix.get(i+step) + 80);
      float y2 = 0 + sin(a + angle) * (1000 * in.mix.get(i+step) + 80);
      line(x,y,x2,y2);
      a += angle;
    }    
    
   if(in.left.level()>gameStartVol){
     gameState = GAME_RUN_1;
   }
    
    popMatrix();
}
