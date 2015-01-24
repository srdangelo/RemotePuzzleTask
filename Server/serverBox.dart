part of simple_http_server;

//Box class, acting as general object
class Box{
  num x;
  num y;
  var color;
  num id;
  bool dragged;
  bool moved;
  num gl_newX = random.nextInt(400);
  num gl_newY = random.nextInt(400);
  //Image image;
  
  Box rightNeighbor = null;
  Box leftNeighbor = null;
  Box upperNeighbor = null;
  Box lowerNeighbor = null;
  
  Box parentGroup=null;//used to group boxes when they are connected to each other
  Box(this.id, this.x, this.y, this.color){
    dragged = false;
    moved=false;
    //image = decodeImage(new File("images/${color}.png").readAsBytesSync());
  }



  void move(num dx, num dy) {
    x = dx;
    y = dy;
    //Hard coded width and height here. The server cannot access image so...
    //That's the solution for now.
    //num width=image.width; 
    //num height=image.height;
    num width=100; 
    num height=100;
    //run recursively to move all boxes that are neighbors of the moved box
    if (leftNeighbor != null &&leftNeighbor.moved==false){
      leftNeighbor.moved=true;
      leftNeighbor.move(dx-width, dy);
    }
    if (rightNeighbor != null&&rightNeighbor.moved==false){
      rightNeighbor.moved=true;
      rightNeighbor.move(dx+width, dy);
    }
    if (upperNeighbor != null && upperNeighbor.moved==false){
      upperNeighbor.moved=true;
      upperNeighbor.move(dx, dy+height);
    }
    if (lowerNeighbor != null &&lowerNeighbor.moved==false){
      lowerNeighbor.moved=true;
      lowerNeighbor.move(dx, dy-height);
    }
  }

  void moveAround(){
        var dist = sqrt(pow((gl_newX - this.x), 2) + pow((gl_newY - this.y), 2));
        num head = atan2((gl_newY - this.y), (gl_newX - this.x));

        if(dist >= 1){
          num targetX = cos(head) + this.x;
          num targetY = sin(head) + this.y;
          move(targetX, targetY);
          }
        else{
          num targetX = (cos(head) * dist) + this.x;
          num targetY = (sin(head) * dist) + this.y;
          move(targetX, targetY);

          gl_newX = random.nextInt(1200);
          gl_newY = random.nextInt(800);
          //change to game width and hieght
        }

  }
  //return the root of the group to which box belongs
  Box getParent(Box box){
    if (box.parentGroup==null)
      return box;
    else return getParent(box.parentGroup);
  }
}

