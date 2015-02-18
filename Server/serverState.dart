part of simple_http_server;

//State class manages all the object including motion, and most likely any interactions
//This state will be mirrored by the State class on the client
class State{

  DateTime time = new DateTime.now();

  //List of all objects in the scene that need to be communicated
  List<Box> myBoxes;

  var score = 100;
  var lastCount=0;
  var potential=2;//Potential is how many dragging one could do before getting their points deducted.
  var lastPotential=2;
  State(){
    myBoxes = new List<Box>();
  }


  //add object
  addBox(Box newBox){
    myBoxes.add(newBox);
    lastCount++;
  }


  //Update State will be run in timed intervals setup in the Main();
  updateState(){
    for(Box box in myBoxes){

      //dont move if being dragged
      if(!box.dragged){

        //random movement
        //box.x = box.x + random.nextInt(15) * (1 - 2*random.nextDouble()).round();
        //box.y = box.y + random.nextInt(15) * (1 - 2*random.nextDouble()).round();
        
        if (box.parentGroup==null)//only move the leading box in the group
        {
          for (Box boxtemp in myBoxes)
            boxtemp.moved=false;
          box.moveAround();
          
        }
        

        //keep movement within the bounds 600x400 hardcoded for now
        if(box.x < 0){
          box.x = box.x * -1;
        }
        else if(box.x > 1920){
          box.x = box.x -15;
        }

        if(box.y < 0){
          box.y = box.y * -1;
        }
        else if(box.y > 1020){
          box.y = box.y -15;
        }
      }
    }
    sendState();

  }

  //Send state to all the clients, comes in the form of [object id, x, y, color]
  sendState(){
    String msg = "u:";
    for(Box box in myBoxes){
      msg = msg + "${box.id},${box.x},${box.y},${box.color};";
    }
    distributeMessage(msg);
    sendID();
    String phaseBreak = "p:${trial.phaseStarted},${trial.phaseBreak},${trial.phaseCongrats},${trial.phaseEnd}";
    distributeMessage(phaseBreak);
//    try{
//      time = new DateTime.now();
//      logData('${time}, ${trial.trialNum}, ${msg} \n', 'gameStateData.csv');
//      //The only problem is it records too often 
//      //and the file will be huge for a 1 hour test.
//    }
//    catch (exception,stacktrace){
//      print(exception);
//      print(stacktrace);
//    }

  }

  //simple command to toggle the dragging interaction
  noDrag(num id){
    Box boxNolongerDragged=myBoxes[id-1];
    boxNolongerDragged.dragged=false;
//    for (Box box in myBoxes){        
//      if (box.getParent()==boxNolongerDragged.getParent()){
//        box.dragged=false;
//      }
//    }
    potential-=1;
    calculateScore();
    return;
}

  //if a object is dragged, this is called when the 'd' command is recieved
  updateBox(num id, num x, num y, String color){
    bool found = false;
    for(Box box in myBoxes){
      if(id == box.id){
        //box.x = x;
        //box.y = y;
        box.move(x, y);
        box.color = color;
        found = true;
        box.dragged = true;
      }
    }
    if(found == false){
      Box temp = new Box(id, x, y, color);
      myBoxes.add(temp);
    }
    for (Box box in myBoxes){
      box.moved=false;
    }
  }

  assignNeighbor (num id, String side, num neighbor){
    for(Box box in myBoxes){
      if(id == box.id){
        if (side == 'right'){
          box.rightNeighbor = myBoxes[neighbor - 1];
          box.rightNeighbor.leftNeighbor=box;
          //box.snap();
          assignParent(box,box.rightNeighbor);
        }
        if (side == 'left'){
          box.leftNeighbor = myBoxes[neighbor - 1];
          box.leftNeighbor.rightNeighbor=box;
          //box.snap();
          assignParent(box.leftNeighbor,box);
        }
        if (side == 'upper'){
          box.upperNeighbor = myBoxes[neighbor - 1];
          box.upperNeighbor.lowerNeighbor=box;
          //box.snap();
          assignParent(box,box.upperNeighbor);
        }
        if (side == 'lower'){
          box.lowerNeighbor = myBoxes[neighbor - 1];
          box.lowerNeighbor.upperNeighbor=box;
          //box.snap();
          assignParent(box.lowerNeighbor,box);
       }
      }
    }
    potential+=2;//Add 2 to the potential for every successful neighbor assignment.
  }
  
  assignParent (Box box1, Box box2){
    //assign box2's group as box1 if box1 has no parent
    //otherwise, assign box2's group as box1's parent group
    if (box1.parentGroup==null){//box1 is a root
      if (box2.parentGroup==null)//if box2 is a root
      {
        if (box1!=box2)//check to make sure these two are not the same box 
        {
          box2.parentGroup=box1;
                  print('parent:'+box1.id.toString());
        }
        //else do nothing
      }
        
      else
      {
        //if box2 belongs to some group
        assignParent(box1,box2.parentGroup);
      }
    }
    else//box1 belongs to some group
    {
      if (box2.parentGroup==null)//if box2 is a root
        assignParent(box1.parentGroup,box2);
      else
      {
        //if both box1 and box2 belongs to some group
        assignParent(box1.parentGroup,box2.parentGroup);
      }
    }
  }
  calculateScore(){
      int count=0;
      for(Box box in myBoxes){
        if (box.parentGroup==null)
        {
          count++;
        }
      }
      if (count!=lastCount){
        score+=(lastCount-count)*20;
        lastCount=count;
      }
      if (count==1){
        //new Timer(new Duration(seconds: 9),()=>print("timeout"));
        //Wait ten seconds to show the result of last puzzle.
        //new Timer(new Duration(milliseconds: 500),()=>trial.transition());
        trial.transition();
        print("timeout");
      }
      if (potential!=lastPotential){
        if (potential<0){
          score+=(potential-lastPotential)*10;//deduct points when potential becomes negative
          potential=0;
          lastPotential=0;
        }
        else{
          lastPotential=potential;
        }
      }
      var sendScore = "s: ${score} \n";
      distributeMessage(sendScore);
    }
  assignBuddies(){
    int myBoxesLength=myBoxes.length;
    int myBoxesLengthSqrt=sqrt(myBoxesLength).toInt();
    if (myBoxesLengthSqrt*myBoxesLengthSqrt!=myBoxesLength){
      print("Error, input is not a square");
      return;
    }
    for(Box box in myBoxes){
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
  checkPieceLocation(num id){
    Box boxDragged = myBoxes[id-1];
    boxDragged.pieceLocation();
//    for (Box box in myBoxes){
//      if (box.getParent()==boxDragged.getParent()){
//        box.dragged=true;
//        box.pieceLocation();
//        
//      }
//    }
  }
  
}
