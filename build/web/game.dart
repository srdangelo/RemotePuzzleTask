part of remotepuzzletask;

//client game class, allows us to draw images and create touch layers.
class Game extends TouchLayer{


  // this is the HTML canvas element
  CanvasElement canvas;

  ImageElement img = new ImageElement();

  // this object is what you use to draw on the canvas
  CanvasRenderingContext2D ctx;


  // width and height of the canvas
  int width, height;

  State myState;
  Box box;

  TouchManager tmanager = new TouchManager();
  TouchLayer tlayer = new TouchLayer();

  var score;
  var phaseBreak;
  var clientID;
  var trialNum;
  bool flagDraw = true;

  Game() {
    canvas = querySelector("#game");
    ctx = canvas.getContext('2d');
    width = canvas.width;
    height = canvas.height;

    
    //tmanager.registerEvents(document.documentElement);
    tmanager.registerEvents(document.documentElement);
    tmanager.addTouchLayer(this);
    
    myState = new State(this);


    // redraw the canvas every 40 milliseconds runs animate function every 40 milliseconds
    //updating at 15fps for now, will test for lag at 30 fps later
    //new Timer.periodic(const Duration(milliseconds : 80), (timer) => animate());

    window.animationFrame.then(animate);

  }


//**
// * Animate all of the game objects makes things movie without an event
// */
  void animate(double i) {
    window.animationFrame.then(animate);
    //print("time spent on listen");
//    ws.onMessage.listen((MessageEvent e) {
//      //print (e.data);
//      handleMsg(e.data);
//    });
    //print("time spent on draw");
    draw();

  }


//**
// * Draws programming blocks
// */
  void draw() {
    if (flagDraw){
      //print ('drawing');
      clear();
      //ctx.clearRect(0, 0, width, height);
      if (phaseBreak == 'false'){
        ctx.fillStyle = 'white';
        ctx.font = '30px sans-serif';
        ctx.textAlign = 'left';
        ctx.textBaseline = 'center';
        ctx.fillText("Server/Client Attempt: Client# ${clientID} Trial# ${trialNum}", 100, 50);
        ctx.fillText("Score: ${score}", 100, 100);
        for(Box box in myState.myBoxes){
          box.draw(ctx);
          //ctx.fillStyle = box.color;
          //ctx.fillRect(box.x, box.y, 50, 50);
        }
      flagDraw = false;
      }
      if (phaseBreak == 'true'){
        ctx.fillStyle = 'white';
        ctx.font = '30px sans-serif';
        ctx.textAlign = 'left';
        ctx.textBaseline = 'center';
        ctx.fillText("10 second break!", 100, 50);
      }
    }
  }

  void clear(){
    ctx.save();
    ctx.setTransform(1, 0, 0, 1, 0, 0);
    ctx.clearRect(0, 0, width, height);
    ctx.restore();
  }

  //parse incoming messages
  handleMsg(data){
    flagDraw = true;
    //print (data);
    //'u' message indicates a state update
    if(data[0] == "u"){
      //split up the message via each object
      List<String> objectsData = data.substring(2).split(";");
      for(String object in objectsData){
        //parse each object data and pass to state.
        List<String> data = object.split(",");
        if(data.length > 3){
          myState.updateBox(num.parse(data[0]), num.parse(data[1]), num.parse(data[2]), data[3]);
          //pieceLocation();
        }
      }
    }
    if (data[0] == "s"){
      score = data.substring(2);
    }
    if (data[0] == "p"){
         phaseBreak = data.substring(2);
    }
    if (data[0] == "i"){
      String tempMsg = data.substring(2);
      List<String> temp = tempMsg.split(",");
      clientID = temp[0];
      if (trialNum!=temp[1])
        myState=new State(this);
      trialNum = temp[1];
      
    }
  }
}
