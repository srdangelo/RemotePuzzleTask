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
  var phaseBreak='false';
  var phaseCongrats='false';
  var phaseStarted='false';//Indicates that the server just started
  var phaseEnd='false';//Indicated that user finished the trial
  var clientID;
  var trialNum;
  bool flagDraw = true;

  Game() {
    canvas = querySelector("#game");
    ctx = canvas.getContext('2d');
    width = canvas.width;
    height = canvas.height;

    tmanager.registerEvents(document.documentElement);
    tmanager.addTouchLayer(this);
    
    myState = new State(this);
    drawWelcome();
    window.animationFrame.then(animate);

  }


//**
// * Animate all of the game objects makes things movie without an event
// */
  void animate(double i) {
    window.animationFrame.then(animate);
//    ws.onMessage.listen((MessageEvent e) {
//      //print (e.data);
//      handleMsg(e.data);
//    });
    draw();

  }


//**
// * Draws programming blocks
// */
  void draw() {
    if (flagDraw){
      if (phaseStarted=='false'){//If user hasn't inputted their trial choice
        flagDraw=false;
        return;
      }
      else if (phaseEnd=='true'){//If user finished all trials
        clear();
        ctx.fillStyle = 'white';
        ctx.font = '30px sans-serif';
        ctx.textAlign = 'left';
        ctx.textBaseline = 'center';
        ctx.fillText("Server/Client Attempt: Client# ${clientID} Trial# ${trialNum}", 100, 50);
        //ctx.fillText("Score: ${score}", 100, 100);
        ctx.fillText("Congratuations! You have Finish all the trials. :)", 100, 150); 
        //flagDraw=false;
      }
      else{
        clear();
        if (phaseBreak == 'false'){
                if (phaseCongrats=='true'){
                  ctx.fillStyle = 'white';
                  ctx.font = '30px sans-serif';
                  ctx.textAlign = 'left';
                  ctx.textBaseline = 'center';
                  ctx.fillText("Server/Client Attempt: Client# ${clientID} Trial# ${trialNum}", 100, 50);
                  ctx.fillText("Score: ${score}", 100, 100);
                  ctx.fillText("Congratuations! You have passed this stage. Please wait while we send you to the next stage.", 100, 150);
                  for(Box box in myState.myBoxes){
                    box.draw(ctx);
                  }
                  flagDraw = false;
                }
                else{
                  ctx.fillStyle = 'white';
                  ctx.font = '30px sans-serif';
                  ctx.textAlign = 'left';
                  ctx.textBaseline = 'center';
                  ctx.fillText("Server/Client Attempt: Client# ${clientID} Trial# ${trialNum}", 100, 50);
                  ctx.fillText("Score: ${score}", 100, 100);
                  for(Box box in myState.myBoxes){
                    box.draw(ctx);
                  }
                  flagDraw = false;          
                }
       }
       else if (phaseBreak == 'true'){
        ctx.fillStyle = 'white';
        ctx.font = '30px sans-serif';
        ctx.textAlign = 'left';
        ctx.textBaseline = 'center';
        ctx.fillText("10 second break!", 100, 50);
       }
            }
      }
      
  }
  void drawWelcome(){
    if (phaseStarted==false || phaseStarted=='false'){
      clear();
      ctx.fillStyle = 'white';
      ctx.font = '30px sans-serif';
      ctx.textAlign = 'left';
      ctx.textBaseline = 'center';
      ctx.fillText("Server/Client Attempt: Client# ${clientID} Trial# ${trialNum}", 100, 50);
      ctx.fillText("Intro", 100, 100);
      ctx.fillText("Blah, Blah, Blah.", 100, 150);
      InputElement inputStage;
      inputStage=new InputElement();
      inputStage.style
        ..position='absolute'
        ..left="100px"
        ..top="200px"
        ..font='30px sans-serif';
      inputStage.value="1";
      document.body.nodes.add(inputStage);
      ButtonElement submitButton;
      submitButton=new ButtonElement();
      submitButton.style
        ..position='absolute'
        ..left="100px"
        ..top="250px"
        ..font='30px sans-serif';
      submitButton.text="Submit";
      var click_submit=submitButton.onClick.listen((event)
          {
            ws.send("s:${(inputStage.value)}");
            submitButton.remove();
            inputStage.remove();
          });
      document.body.nodes.add(submitButton);
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
      //'u' message indicates a state update
      if(data[0] == "u"){
        //split up the message via each object
        List<String> objectsData = data.substring(2).split(";");
        for(String object in objectsData){
          //parse each object data and pass to state.
          List<String> data = object.split(",");
          if(data.length > 3){
            myState.updateBox(num.parse(data[0]), num.parse(data[1]), num.parse(data[2]), data[3]);
          }
        }
      }
      if (data[0] == "s"){
        score = data.substring(2);
      }
      if (data[0] == "p"){
        List<String> phaseData = data.substring(2).split(",");
        if (phaseData.length>=4){
           phaseStarted=phaseData[0];
           phaseBreak = phaseData[1];
           phaseCongrats=phaseData[2];
           phaseEnd=phaseData[3];
        }
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
