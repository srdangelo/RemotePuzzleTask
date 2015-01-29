
part of remotepuzzletask;

//object class, unlike server, this one is touchable but otherwise has the same properties
class Box implements Touchable{
  num x;
  num y;
  var color;
  num id;
  bool dragged;
  int imageWidth;
  int imageHeight;
  
  num touched_x_offset;
  num touched_y_offset;
  
  ImageElement img = new ImageElement();
  
  Box rightBuddy = null;
  Box leftBuddy = null;
  Box upperBuddy = null;
  Box lowerBuddy = null;
  Box leftNeighbor = null;
  Box rightNeighbor = null;
  Box upperNeighbor = null;
  Box lowerNeighbor = null;
  
  
  Timer dragTimer;

  Box(this.id, this.x, this.y, this.color){
    dragged= false;
    img.src = "images/${this.color}.png";
    imageWidth=img.width;
    imageHeight=img.height;
  }

  //when this object is dragged, send a 'd' message with id, x, y, color
  sendDrag(num newX, num newY){

    if (rightNeighbor != null && leftNeighbor != null){
      ws.send("d:${id},${newX},${newY},${color},${leftNeighbor.color},${rightNeighbor.color}, Client#${game.clientID}");
    }
    else {
      ws.send("d:${id},${newX},${newY},${color}, ${game.clientID}");
    }
    //
    }


  bool containsTouch(Contact e) {
    if((e.touchX > x && e.touchX  < x +img.width) && 
      (e.touchY > y && e.touchY < y + img.height)){
        return true;
      }
    return false;
  }

  bool touchDown(Contact e) {
    dragged = true;
    touched_x_offset=x-e.touchX;
    touched_y_offset=y-e.touchY;
    return true;
  }

  void touchUp(Contact event) {
    dragged = false;
    try{
          //dragTimer.cancel();
    }
    catch(exception){
          print(exception);
    }
    //pieceLocation();
    ws.send("b:${id}, ${color}, ${game.clientID}");
  }

  void touchDrag(Contact e) {
    //since touchUp has issues it impacts touchDrag so have extra bool to makes sure this are being dragged
    if(dragged){
      sendDrag(touched_x_offset+ e.touchX,touched_y_offset+ e.touchY);
      //print(e.touchX);
    }
  }

  void touchSlide(Contact event) { }



//  void pieceLocation ()
//  //small bug. One must drag the correct box in order to assign neighbors.
//  //for example. 1 and 2 are connected. 1 and 3 should be neighbors. User drags 2 and puts
//  //1 on top of 3. 1 and 3 should be combined but they;re not. Because this program only
//  //checks for 2.
//  {
//    Box box=this;
//    imageWidth=box.img.width;
//    imageHeight=box.img.height;
//      //When the boxes touch each other
//      //assign the Neighbors according to the predetermined pattern.
//      if (box.rightBuddy != null &&box.rightNeighbor==null){
//        if (box.rightBuddy.x + 10 + imageWidth/2 >= box.x &&
//            box.rightBuddy.y + 10 + imageHeight/2 >= box.y &&
//            box.rightBuddy.x + 10  <= box.x + imageWidth/2 + 20 &&
//            box.rightBuddy.y + 10  <= box.y + 20 + imageHeight/2){
//           box.rightNeighbor = box.rightBuddy;
//           box.rightBuddy.leftNeighbor = box;
//           print ('rightneighbors!');
//           ws.send("n:${box.id},right,${box.rightNeighbor.id}");
//        }
//      }
//      if (box.leftBuddy != null && box.leftNeighbor==null){
//        if (box.leftBuddy.x + 10 + imageWidth/2 >= box.x &&
//            box.leftBuddy.y + 10 + imageHeight/2 >= box.y &&
//            box.leftBuddy.x + 10  <= box.x + 20 + imageWidth/2 &&
//            box.leftBuddy.y + 10  <= box.y + 20 + imageHeight/2){
//           box.leftNeighbor = box.leftBuddy;
//           box.leftBuddy.rightNeighbor = box;
//           print ('left neighbors!');
//           ws.send("n:${box.id},left,${box.leftNeighbor.id}");
//        }
//      }
//      if (box.upperBuddy != null && box.upperNeighbor==null){
//        if (box.upperBuddy.x + 10 + imageWidth/2 >= box.x &&
//            box.upperBuddy.y + 10 + imageHeight/2 >= box.y &&
//            box.upperBuddy.x + 10 <= box.x + 20 + imageWidth/2 &&
//            box.upperBuddy.y + 10 <= box.y + 20 + imageHeight/2){
//           box.upperNeighbor = box.upperBuddy;
//           box.upperBuddy.lowerNeighbor = box;
//           print ('upper neighbors!');
//           ws.send("n:${box.id},upper,${box.upperNeighbor.id}");
//        }
//      }
//      if (box.lowerBuddy != null && box.lowerNeighbor==null){
//        if (box.lowerBuddy.x + 10 + imageWidth/2 >= box.x &&
//            box.lowerBuddy.y + 10 + imageHeight/2 >= box.y &&
//            box.lowerBuddy.x + 10 <= box.x + 20 + imageWidth/2 &&
//            box.lowerBuddy.y + 10 <= box.y + 20 + imageHeight/2){
//           box.lowerNeighbor = box.lowerBuddy;
//           box.lowerBuddy.upperNeighbor = box;
//           print ('lower neighbors!');
//           ws.send("n:${box.id},lower,${box.lowerNeighbor.id}");
//        }
//      }
//    }



  
  void draw(CanvasRenderingContext2D ctx){
    ctx.save();
    {
    num boxWidth = img.width;
    num boxHeight = img.height;
    ctx.translate(x, y);
    ctx.drawImage(img, 0, 0);
    }
    ctx.restore();
  }

}

