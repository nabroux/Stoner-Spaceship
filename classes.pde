//Classe pour les cubes qui flottent dans l'espace
class Cube {
  //Position Z de "spawn" et position Z maximale
  float startingZ = -10000;
  float maxZ = 1000;
  
  //Valeurs de positions
  float x, y, z;
  float rotX, rotY, rotZ;
  float sumRotX, sumRotY, sumRotZ;
  
  //Constructeur
  Cube() {
    //Faire apparaitre le cube à un endroit aléatoire
    x = random(0, width);
    y = random(0, height);
    z = random(startingZ, maxZ);
    
    //Donner au cube une rotation aléatoire
    rotX = random(0, 1);
    rotY = random(0, 1);
    rotZ = random(0, 1);
  }
  
  void display(float scoreLow, float scoreMid, float scoreHi, float intensity, float scoreGlobal) {
    //Sélection de la couleur, opacité déterminée par l'intensité (volume de la bande)
    color displayColor = color(scoreLow*0.67, scoreMid*0.67, scoreHi*0.67, intensity*5);
    fill(displayColor, 255);
    
    //Couleur lignes, elles disparaissent avec l'intensité individuelle du cube
    color strokeColor = color(255, 150-(20*intensity));
    stroke(strokeColor);
    strokeWeight(1 + (scoreGlobal/300));
    
    //Création d'une matrice de transformation pour effectuer des rotations, agrandissements
    pushMatrix();
    
    //Déplacement
    translate(x, y, z);
    
    //Calcul de la rotation en fonction de l'intensité pour le cube
    sumRotX += intensity*(rotX/1000);
    sumRotY += intensity*(rotY/1000);
    sumRotZ += intensity*(rotZ/1000);
    
    //Application de la rotation
    rotateX(sumRotX);
    rotateY(sumRotY);
    rotateZ(sumRotZ);
    
    //Création de la boite, taille variable en fonction de l'intensité pour le cube
    box(100+(intensity/2));
    
    //Application de la matrice
    popMatrix();
    
    //Déplacement Z
    z+= (1+(intensity/5)+(pow((scoreGlobal/150), 2)));
    
    //Replacer la boite à l'arrière lorsqu'elle n'est plus visible
    if (z >= maxZ) {
      x = random(0, width);
      y = random(0, height);
      z = startingZ;
    }
  }
}


//Classe pour afficher les lignes sur les cotés
class Mur {
  //Position minimale et maximale Z
  float startingZ = -10000;
  float maxZ = 50;
  
  //Valeurs de position
  float x, y, z;
  float sizeX, sizeY;
  
  //Constructeur
  Mur(float x, float y, float sizeX, float sizeY) {
    //Faire apparaitre la ligne à l'endroit spécifié
    this.x = x;
    this.y = y;
    //Profondeur aléatoire
    this.z = random(startingZ, maxZ);  
    
    //On détermine la taille car les murs au planchers ont une taille différente que ceux sur les côtés
    this.sizeX = sizeX;
    this.sizeY = sizeY;
  }
  
  //Fonction d'affichage
  void display(float scoreLow, float scoreMid, float scoreHi, float intensity, float scoreGlobal) {
    //Couleur déterminée par les sons bas, moyens et élevé
    //Opacité déterminé par le volume global
    color displayColor = color(scoreLow*0.67, scoreMid*0.67, scoreHi*0.67, scoreGlobal);
    
    //Faire disparaitre les lignes au loin pour donner une illusion de brouillard
    fill(displayColor, ((scoreGlobal-5)/1000)*(255+(z/25)));
    noStroke();
    
    //Première bande, celle qui bouge en fonction de la force
    //Matrice de transformation
    pushMatrix();
    
    //Déplacement
    translate(x, y, z);
    
    //Agrandissement
    if (intensity > 100) intensity = 100;
    scale(sizeX*(intensity/100), sizeY*(intensity/100), 20);
    
    //Création de la "boite"
    box(1);
    popMatrix();
    
    //Deuxième bande, celle qui est toujours de la même taille
    displayColor = color(scoreLow*0.5, scoreMid*0.5, scoreHi*0.5, scoreGlobal);
    fill(displayColor, (scoreGlobal/5000)*(255+(z/25)));
    //Matrice de transformation
    pushMatrix();
    
    //Déplacement
    translate(x, y, z);
    
    //Agrandissement
    scale(sizeX, sizeY, 10);
    
    //Création de la "boite"
    box(1);
    popMatrix();
    
    //Déplacement Z
    z+= (pow((scoreGlobal/150), 2));
    if (z >= maxZ) {
      z = startingZ;  
    }
  }
}

class Planet{
  float x,x2;
  float y,y2;
  int angle,size;
  int intensity; //1000
  float speed;
  
  Planet(int x,int x2,int y,int y2,int angle,int size,int intensity){
    this.x = x;
    this.x2 = x2;
    this.y = y;
    this.y2 = y2;
    this.angle = angle;
    this.size = size;
    this.intensity = intensity;
    this.speed=1;
    }
    
  Planet(int x,int y,int angle,int size,int intensity){
    this.x = x;
    this.x2 = x;
    this.y = y;
    this.y2 = y;
    this.angle = angle;
    this.size = size;
    this.intensity = intensity; 
    this.speed=1;
    }
  
//method
  void display(){
      float a = 0;  
      int step = in.bufferSize() / 200;
      
    for(int i=0; i < in.bufferSize() - step; i+=step) {
      float angle = (2*PI) / this.angle;
      float x = this.x + cos(a) * (this.intensity* in.mix.get(i) + this.size);
      float y = this.y + sin(a) * (this.intensity * in.mix.get(i) + this.size);
      float x2 = this.x2 + cos(a + angle) * (this.intensity * in.mix.get(i+step) + this.size);
      float y2 = this.y2 + sin(a + angle) * (this.intensity * in.mix.get(i+step) + this.size);
      line(x,y,x2,y2);
      a += angle;
      }
  }
  
  void update(int move_x,int move_y){
    this.x += move_x;
    this.x2 += move_x;
    this.y += move_y;
    this.y2 += move_y;
    }
  
  void update(){
    this.x -= this.speed;
    this.x2 -= this.speed;
  
    if (this.x <= -this.size){
      this.reset_P();
    }
  }
  
  void reset_P(){
    float nX = width + this.size * 4;
    float nY = random(height)+this.size;
    this.x = nX;
    this.x2 = nX;
    this.y = nY;
    this.y2 = nY;
    
    float b_o_s = random(0,3);
    if(b_o_s>2.4){  //b
      this.size = int(random(150,250));
      this.speed = random(0.3,0.8);
    }else{       //s
      this.size = int(random(30,90));
      this.speed = random(0.8,2);
    }
  }
}

class Enemy{
  float x,x2;
  float y,y2;
  int angle,size;
  int intensity; //1000
  float speed;
  
  Enemy(int x,int x2,int y,int y2,int angle,int size,int intensity){
    this.x = x;
    this.x2 = x2;
    this.y = y;
    this.y2 = y2;
    this.angle = angle;
    this.size = size;
    this.intensity = intensity;
    this.speed=1;
    }
    
  Enemy(int x,int y,int angle,int size,int intensity){
    this.x = x;
    this.x2 = x;
    this.y = y;
    this.y2 = y;
    this.angle = angle;
    this.size = size;
    this.intensity = intensity; 
    this.speed=1;
    }
  
//method
  void display(){
     pushMatrix();
     float a = 0;  
     int step = in.bufferSize() / 200;
     float E_color = random(0,255);
     float E_dev = random(0,1); //4.7 O&R
     stroke(E_color/E_dev, 255, 255);
    for(int i=0; i < song.bufferSize() - step; i+=step) {
      float angle = (2*PI) / this.angle;
      float x = this.x + cos(a) * (this.intensity* song.mix.get(i) + this.size);
      float y = this.y + sin(a) * (this.intensity * song.mix.get(i) + this.size);
      float x2 = this.x2 + cos(a + angle) * (this.intensity * song.mix.get(i+step) + this.size);
      float y2 = this.y2 + sin(a + angle) * (this.intensity * song.mix.get(i+step) + this.size);
      line(x,y,x2,y2);
      a += angle;
      }
     popMatrix();
  }
  
  void update(int move_x,int move_y){
    this.x += move_x;
    this.x2 += move_x;
    this.y += move_y;
    this.y2 += move_y;
    }
  
  void update(){
    this.x -= this.speed;
    this.x2 -= this.speed;
  
    if (this.x <= -this.size){
      this.reset_E();
    }
  }
  
  void reset_E(){
    float nX = width + this.size * 4;
    float nY = random(height)+this.size;
    int nI = int(random(30,200));
    int new_angle = int(random(3,15));
    this.angle = new_angle;
    this.x = nX;
    this.x2 = nX;
    this.y = nY;
    this.y2 = nY;
    this.intensity = nI;
    
    float b_o_s = random(0,3);
    if(b_o_s>2.4){  //b
      this.size = int(random(100,150));
      this.speed = random(1,3);
    }else{       //s
      this.size = int(random(30,70));
      this.speed = random(2.5,5);
    }
  }
  
  boolean isCollapse(float rx, float ry, float rw, float rh){
    //circle = {x, y, r}; 
    //rect = {x, y, w, h}; 
    //closestPoint = {x, y};
    float cx = this.x;
    float cy = this.y;
    float cr = this.size;
    float closestPointx, closestPointy;
    
    if(cx > rx && cx < rx+rw){closestPointx = cx;
     }else if(cx > rx + rw){closestPointx = rx + rw;
     }else{closestPointx = rx;}
     
    if(cy > ry && cy < ry+rh){closestPointy = cy;
     }else if(cy > ry + rh){closestPointy = ry + rh;
     }else{closestPointy = ry;}
    
  double distance = Math.sqrt(Math.pow(closestPointx - cx, 2) + Math.pow(closestPointy - cy, 2));
    if(distance < cr)
    {return  true;
    }else{return false;}
  }
 
}

class Bullet{
  float x;
  float y;
  float speed;
  float B_color;
  float B_dev;
  float boxSize;
  float boxColor;
  
  Bullet(){
    this.x = player_x + 60;
    this.y = player_y + 30;
    this.speed = 25;
    this.B_color = random(0,255);
    this.B_dev = random(0,1);
    this.boxSize = in.left.level() * 100;
    this.boxColor = this.B_color/this.B_dev;
  }
  
  void display(){
    pushMatrix();
    rectMode(CENTER);
    stroke(boxColor);
    fill(boxColor);
    rect(this.x,this.y,boxSize,boxSize/2);
    popMatrix();
  }
  
  void update(){
    this.x += this.speed;
  }
  
  void hitting(){
    float bx = this.x;
    float by = this.y;
    float bw = this.boxSize;
    float bh = this.boxSize/2;
    
    float closestPointx, closestPointy;
    
    for(int i=0;i<currentE;i++){
      float cx = enemies[i].x;
      float cy = enemies[i].y;
      float cr = enemies[i].size;
      if(cx > bx && cx < bx+bw){closestPointx = cx;
       }else if(cx > bx + bw){closestPointx = bx + bw;
       }else{closestPointx = bx;}
       
      if(cy > by && cy < by+bh){closestPointy = cy;
       }else if(cy > by + bh){closestPointy = by + bh;
       }else{closestPointy = by;}
       
      double distance = Math.sqrt(Math.pow(closestPointx - cx, 2) + Math.pow(closestPointy - cy, 2));
      if(distance < cr) {
        if(enemies[i].size > 3){
          enemies[i].size -= 1;
         }else if(enemies[i].size <= 3){
          enemies[i].reset_E();
         }
      }
    }
  }
   
}
