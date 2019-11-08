Planet[] planets = new Planet[7];
Enemy[] enemies = new Enemy[1000];
Bullet[] bullets = new Bullet[50];
float player_x = 50;
float player_y = height/2;
boolean rightState,upState,downState;
float playerSpeed = 2;
int timer;
int currentE;
int score = 0;

void init_stage1(){
  currentE = 10;
  timer = 0;
  
   player_x = 50;
   player_y = height/2;
  //bg
  planets[0] = new Planet(width+300,200,35,300,100);
  planets[1] = new Planet(width+900,height/2+300,70,40,200);
  planets[2] = new Planet(width+1400,100,15,100,50);
  planets[3] = new Planet(width+1800,50,10,50,200);
  planets[4] = new Planet(width+2200,500,200,200,100);
  planets[5] = new Planet(width+2600,300,200,20,100);
  planets[6] = new Planet(width+2800,height,200,20,40);
  rightState=false;
  upState = false;
  downState=false;
  
  //enemies
  for(int i=0; i<currentE;i++){
    enemies[i] = new Enemy(width+1000,0,35,300,100);
    enemies[i].reset_E();
  }
  
  //bullets
  for(int i=0;i<bullets.length;i++){
    bullets[i] = null;
  }
  
}

void stage1_draw(){
  timer += 1;
  score += 1;
  
  if(timer == 120){
    if(currentE < enemies.length){
      enemies[currentE] = new Enemy(width+1000,0,35,300,100);
      enemies[currentE].reset_E();
      currentE+=1;
    }
    timer = 0;
  }
  
  //background planets
    stroke(150);
    for(int i=0; i<planets.length;i++){
      planets[i].update();
      planets[i].display();
    }
   
  //Enemy Object
   
    for(int i=0; i<currentE;i++){
      enemies[i].update();
      enemies[i].display();
      
      if (enemies[i].isCollapse(player_x,player_y,60,60)){
        gameState = GAME_START;
        init_stage1();
      }
  }
  
  //bullet
  for(int i=0;i<bullets.length;i++){
    if (bullets[i] == null){
     continue;
    }else{
     bullets[i].display();
     bullets[i].update();
     bullets[i].hitting();
     if(bullets[i].x >width+100){
       bullets[i] = null;
     }
    }
  }
    //fire

  if(in.left.level()>fireVol){
    fire();
  }
  
  //player
    image(shuttle,player_x,player_y,60,60);
    if(player_x<-10){ player_x=-10;}// Check left boundary
    if(upState){
         player_y -= 3;}
    if(downState){
         player_y += 3;}
    if(rightState){
         player_x += playerSpeed;
       }else{player_x -= 1;}
    
    if(player_x>880){
      playerSpeed = 0.6;
    }else if(player_x>700){
      playerSpeed = 1;
    }else if(player_x>500){
      playerSpeed = 1.4;
    }else{
      playerSpeed = 2;
    }
}

void keyPressed(){
  switch(gameState){
  case GAME_RUN_1:
      if(key==CODED){
        switch(keyCode){
          case UP:
          upState = true;
          break;
          case DOWN:
          downState = true;
          break;
          case RIGHT:
          rightState = true;
          break;
        }
      }
    if( key == 'a'|| key == 'A' ){
        changeMusic();
    }
    
    if( key == 'f'|| key == 'F' ){
        fire();
    }
   
 }
}

void keyReleased(){
  switch(gameState){
    case GAME_RUN_1:
      if(key==CODED){
        switch(keyCode){
          case UP:
          upState = false;
          break;
          case DOWN:
          downState = false;
          break;
          case RIGHT:
          rightState = false;
          break;
        }
      }
   break;
  }
}

void changeMusic(){
  if (song_index == 50){
          song_index = 1;
        }else{
          song_index += 1;
        }
        song.close();
        song_name = "bgm/ ("+song_index+").mp3";
        song = minim.loadFile(song_name);
        song.play(0);
}

void fire(){
  for(int i=0;i<bullets.length;i++){
    if (bullets[i] == null){
      bullets[i] = new Bullet();
      break;
    }
  }
  
}
