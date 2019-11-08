final int GAME_START = 0, GAME_RUN_1 =1, GAME_WIN = 2, GAME_LOSE = 3;
int gameState = GAME_START; //testing!!!
PImage shuttle;
int song_index = 1;
String song_name = "bgm/ ("+song_index+").mp3";
float gameStartVol = 0.4;
float fireVol = 0.35;

void setup()
{
   minim = new Minim(this);
   
  fullScreen(P3D);
  //size(1080, 720, P3D);
  init_start();
  init_stage1();
  initBox(); 
  
  //
  shuttle = loadImage("img/shuttle.png");

}

void draw(){
  switch (gameState) {
    // Start Screen
    case GAME_START: 
     start_draw();
    
    break;
    
    //
    case GAME_RUN_1: 
     background(0);
     stage1_draw();
     rainbow_draw();
     
    break;
    
    //
   
  }
}
