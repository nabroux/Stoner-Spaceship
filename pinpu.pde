void pinpu_draw(){
 
 //roman_draw(); 
 rainbow_draw();
}

void roman_draw(){
  stroke(255);
  for(int i=0; i<song.left.size()-1; i++){
    strokeWeight(abs(song.left.get(i)*20));
    line(i+50, 150+song.left.get(i)*50, i+51, 150+song.left.get(i+1)*50);
    line(i+50, 250+song.right.get(i)*50, i+51, 250+song.right.get(i+1)*50);
  }
}

void rainbow_draw(){
  pushMatrix();
  smooth();
  colorMode(HSB, 255, 255, 255);
   for (int i=0; i<song.bufferSize()-1; i++) {
    stroke(i/4.7, 255, 255);
    strokeWeight(abs(song.left.get(i)*40));
    int r_len = 1025;
    line(i+player_x-r_len, player_y+32 +song.left.get(i)*25, i+player_x+5-r_len, player_y+32 +song.left.get(i+1)*25);
    //line(i, 400+song.right.get(i)*50, i+1, 400+song.right.get(i+1)*50);
  }
  popMatrix();
}
