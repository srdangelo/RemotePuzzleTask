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
  
  void pieceLocation ()
   //small bug. One must drag the correct box in order to assign neighbors.
   //for example. 1 and 2 are connected. 1 and 3 should be neighbors. User drags 2 and puts
   //1 on top of 3. 1 and 3 should be combined but they;re not. Because this program only
   //checks for 2.
   {
     Box box=this;
     var imageWidth=100;
     var imageHeight=100;
       //When the boxes touch each other
       //assign the Neighbors according to the predetermined pattern.
       if (box.rightNeighbor != null &&box.rightNeighbor==null){
         if (box.rightNeighbor.x + 10 + imageWidth/2 >= box.x &&
             box.rightNeighbor.y + 10 + imageHeight/2 >= box.y &&
             box.rightNeighbor.x + 10  <= box.x + imageWidth/2 + 20 &&
             box.rightNeighbor.y + 10  <= box.y + 20 + imageHeight/2){
            box.rightNeighbor = box.rightNeighbor;
            box.rightNeighbor.leftNeighbor = box;
            print ('rightneighbors!');
            myState.assignNeighbor(box.id,"right",box.rightNeighbor.id);
         }
       }
       if (box.leftNeighbor != null && box.leftNeighbor==null){
         if (box.leftNeighbor.x + 10 + imageWidth/2 >= box.x &&
             box.leftNeighbor.y + 10 + imageHeight/2 >= box.y &&
             box.leftNeighbor.x + 10  <= box.x + 20 + imageWidth/2 &&
             box.leftNeighbor.y + 10  <= box.y + 20 + imageHeight/2){
            box.leftNeighbor = box.leftNeighbor;
            box.leftNeighbor.rightNeighbor = box;
            print ('left neighbors!');
            myState.assignNeighbor(box.id,"left",box.leftNeighbor.id);
         }
       }
       if (box.upperNeighbor != null && box.upperNeighbor==null){
         if (box.upperNeighbor.x + 10 + imageWidth/2 >= box.x &&
             box.upperNeighbor.y + 10 + imageHeight/2 >= box.y &&
             box.upperNeighbor.x + 10 <= box.x + 20 + imageWidth/2 &&
             box.upperNeighbor.y + 10 <= box.y + 20 + imageHeight/2){
            box.upperNeighbor = box.upperNeighbor;
            box.upperNeighbor.lowerNeighbor = box;
            myState.assignNeighbor(box.id,"upper",box.upperNeighbor.id);
         }
       }
       if (box.lowerNeighbor != null && box.lowerNeighbor==null){
         if (box.lowerNeighbor.x + 10 + imageWidth/2 >= box.x &&
             box.lowerNeighbor.y + 10 + imageHeight/2 >= box.y &&
             box.lowerNeighbor.x + 10 <= box.x + 20 + imageWidth/2 &&
             box.lowerNeighbor.y + 10 <= box.y + 20 + imageHeight/2){
            box.lowerNeighbor = box.lowerNeighbor;
            box.lowerNeighbor.upperNeighbor = box;
            myState.assignNeighbor(box.id,"lower",box.lowerNeighbor.id);
         }
       }
     }
}

