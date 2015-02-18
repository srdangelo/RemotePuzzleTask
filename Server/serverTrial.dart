part of simple_http_server;

class Trial{
  var phase = 'Start';
  num trialSetNum = 0;
  num trialNum = 0;
  bool phaseStarted = false;
  bool phaseBreak = false;
  bool phaseCongrats = false;
  bool phaseEnd = false;
  num trialID = 0;
  // record the name of all pictures that may be used
  // list all the options of orders that the puzzles will be displayed
  List<List> assignOptions = [[0, 1, 2, 3, 4, 5, 6, 7, 8], 
                               [3, 4, 5, 6, 7, 8, 0, 1, 2], 
                               [6, 7, 8, 0, 1, 2, 3, 4, 5],
                               [9,10,11,12,13,14,15,16,17],
                               [15,16,17,9,10,11,12,13,14],
                               [12,13,14,15,16,17,9,10,11]];
  List<String> picName=['world','waveRainbow','swirl',
                         'starry','spiralRainbow','cupcake',
                         'coffee','beach','balloon',
                         'plaid1','plaid2','plaid3',
                         'plaid4','plaid5','plaid6',
                         'plaid7','plaid8','plaid9',];
  List<List> order = [['world_21','world_22','world_23','world_24','world_25',
                              'world_16','world_17','world_18','world_19','world_20',
                              'world_11','world_12','world_13','world_14','world_15',
                              'world_06','world_07','world_08','world_09','world_10',
                              'world_01','world_02','world_03','world_04','world_05']
                        //This is just an example of how the order will look like after
                        //the program autogenerates it.
  ];
Trial () {
  transition();
}

  void setup(order){
    myState = new State();
    num i = 1;
    var piece;
    for (piece in order){
      //String boxNum = 'box' +  i.toString();
      //setup state and some test objects
      Box box = new Box(i, random.nextInt(800), random.nextInt(1000), piece);
      myState.addBox(box);
      
      i++;
      }

    for (Box box in myState.myBoxes){
                  //log only its initial position and the direction its heading to.
      try{
                  var time = new DateTime.now();
                  logData('${time},${trial.trialSetNum}, ${trial.trialNum}, ${box.id},'
                  +'${box.x}, ${box.y}, ${box.color},'
                  +'${box.gl_newX}, ${box.gl_newY} \n'
                  , 'gameStateData.csv');
                }
                catch (exception,stacktrace){
                  print(exception);
                  print(stacktrace);
                }
    }
    myState.assignBuddies();//Prepare the state so that each box has its buddies. 
    //(The buddies are the other boxes that a box should be connected to)
    }

  void transition() {
     
     
     switch(phase){
          case 'Start':
              phase = 'BREAK';
              phaseStarted=false;
              phaseBreak = true;
              setup([]);
              
              break;
          case 'BREAK':
              phase = 'TRIAL';
              phaseStarted=true;
              phaseCongrats=false;
              phaseBreak = true;
              setup([]);
              new Timer(const Duration(seconds : 10), () {
                                transition();
              });
              myState.score=100;
              var sendScore = "s: ${myState.score} \n";
              distributeMessage(sendScore);
              break;
          case 'TRIAL':
              phase = 'CONGRATS';
              phaseBreak = false;
              setup(order[trialNum]);
              trialNum += 1;
              if ((trialNum)==order.length){
                phase='END';
              }
              else if (trialNum>order.length){
                phase='END';
                transition();
              }
                
              break;
          case 'CONGRATS':
              phase='BREAK';
              var Score=myState.score;//Need to store the score to show that on the Congrats page.
              setup([]);
              myState.score=Score;//Restore the score.
              var sendScore = "s: ${myState.score} \n";
                            distributeMessage(sendScore);
              phaseBreak=false;
              phaseCongrats=true;
              
              new Timer(const Duration(seconds : 10), () {
                                              transition();
              });
              
              break;
           case 'END':
              phaseEnd=true;
              setup([]);
              break;
           }
   }
  void generateOrder(){
      //Random randomNum = new Random();
      
      num numoftrials = assignOptions[trialSetNum].length;
      order = [];
      List<String> this_image = [];
      for (int count = 0; count < numoftrials; count++){
        this_image = [];
        for (int i=12;i>=0;i-=4){
           for (int j=1;j<=4;j++){
               if (i+j>=10){
                  this_image.add(picName[assignOptions[trialSetNum][count]]+'_'+(i+j).toString());
               }
               else{
                 this_image.add(picName[assignOptions[trialSetNum][count]]+'_0'+(i+j).toString());
               }
           }
        }
        order.add(this_image);
      }
      
    }
}