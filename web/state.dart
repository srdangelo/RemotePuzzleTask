part of remotepuzzletask;

//client state class, doesn't need update or send state, just need to keep track of objects via updateBox()
class State{
  Game boxGame;
  List<Box> myBoxes;
  //TouchLayer tlayer;
  int lastLength=0;
  State(game){
    boxGame = game;
    myBoxes = new List<Box>();
  }

  addBox(Box newBox){
    myBoxes.add(newBox);
  }

  updateState(){
  }

  sendState(){
  }

  updateBox(num id, num x, num y, String color){
    bool found = false;
    int myBoxesLength=myBoxes.length;

    int myBoxesLengthSqrt=sqrt(myBoxesLength).toInt();
    if (myBoxesLengthSqrt*myBoxesLengthSqrt!=myBoxesLength){
    }
    for(Box box in myBoxes){
      if(id == box.id){
        box.x = x;
        box.y = y;
        box.color = color;
        found = true;
        //lastLength!=myBoxesLength
        if (true){
          int i = myBoxes.indexOf(box);
                  if (i % myBoxesLengthSqrt== 0){
                    box.rightBuddy = myBoxes[i + 1];
                  }
                  else if (i % myBoxesLengthSqrt == myBoxesLengthSqrt - 1){
                    box.leftBuddy = myBoxes[i - 1];
                  }
                  else {
                    box.leftBuddy = myBoxes[i - 1];
                    box.rightBuddy = myBoxes[i + 1];
                  }
                  if (i/myBoxesLengthSqrt<1){
                    box.lowerBuddy= myBoxes[i+myBoxesLengthSqrt];
                  }
                  else if (i/myBoxesLengthSqrt>=myBoxesLengthSqrt-1){
                    box.upperBuddy= myBoxes[i-myBoxesLengthSqrt];
                  }
                  else{
                    box.lowerBuddy= myBoxes[i+myBoxesLengthSqrt];
                    box.upperBuddy= myBoxes[i-myBoxesLengthSqrt];
                  }
        }
      }
    }

    //if new box, create new object and add to touchables
    if(found == false){
      Box temp = new Box(id, x, y, color);
      boxGame.touchables.add(temp);
      myBoxes.add(temp);
    }
    lastLength=myBoxesLength;

  }



}

