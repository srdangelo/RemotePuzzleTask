part of simple_http_server;

class Trial{
  var phase = 'Start';
  num trialSetNum=0;
  num trialNum = 0;
  bool phaseStarted=false;
  bool phaseBreak = false;
  bool phaseCongrats=false;
  bool phaseEnd=false;
  num trialID = 0;
  List<String> picName=[['world','waveRainbow','tree','swirl','sunset',
                         'starry','spiralRainbow','fade','door','cupcake',
                         'colors','coffee','beach','balloon']
                       ];
  List<List> order = [
                        [
                             ['Octopus_07', 'Octopus_08', 'Octopus_09', 'Octopus_04', 'Octopus_05', 'Octopus_06', 'Octopus_01', 'Octopus_02', 'Octopus_03'],
                             ['Unicorn_07', 'Unicorn_08', 'Unicorn_09', 'Unicorn_04', 'Unicorn_05', 'Unicorn_06', 'Unicorn_01', 'Unicorn_02', 'Unicorn_03'],
                             ['tangram_14_07', 'tangram_14_08', 'tangram_14_09', 'tangram_14_04', 'tangram_14_05', 'tangram_14_06', 'tangram_14_01', 'tangram_14_02', 'tangram_14_03'],
                             ['spiral_07', 'spiral_08', 'spiral_09', 'spiral_04', 'spiral_05', 'spiral_06', 'spiral_01', 'spiral_02', 'spiral_03'],
                             ['original_07', 'original_08', 'original_09', 'original_04', 'original_05', 'original_06', 'original_01', 'original_02', 'original_03'],
                             ['rainbow1', 'rainbow2', 'rainbow3', 'rainbow4','rainbow5','rainbow6','rainbow7','rainbow8','rainbow9',],
                             ['plaid1', 'plaid2', 'plaid3', 'plaid4', 'plaid5', 'plaid6', 'plaid7', 'plaid8', 'plaid9'],
                             ['green_07', 'green_08', 'green_09', 'green_04', 'green_05', 'green_06', 'green_01', 'green_02', 'green_03'],
                             ['redplaid_01', 'redplaid_02', 'redplaid_03', 'redplaid_04', 'redplaid_05', 'redplaid_06', 'redplaid_07', 'redplaid_08', 'redplaid_09'],
                             ['world_21','world_22','world_23','world_24','world_25',
                              'world_16','world_17','world_18','world_19','world_20',
                              'world_11','world_12','world_13','world_14','world_15',
                              'world_06','world_07','world_08','world_09','world_10',
                              'world_01','world_02','world_03','world_04','world_05']
                             ]
                        
  ];
Trial () {
  generateOrder();
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
              setup(order[trialSetNum][trialNum]);
              trialNum += 1;
              if ((trialNum)==order[trialSetNum].length){
                phase='END';
              }
              else if (trialNum>order[trialSetNum].length){
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
      Random randomNum=new Random();
      order=[];
      for (int setNum=0;setNum<picName.length;setNum++){
        order.add([]);
        for (int imageNum=0;imageNum<picName[setNum].length;imageNum++){
          order[setNum].add([]);
          for (int i=20;i>=0;i-=5){
            for (int j=1;j<=5;j++){
              if (i+j>=10){
                order[setNum][imageNum].add(picName[setNum][imageNum]+'_'+(i+j).toString());
              }
              else{
                order[setNum][imageNum].add(picName[setNum][imageNum]+'_0'+(i+j).toString());
              }            
            }          
          }
        }
        order[setNum].shuffle(randomNum);
      }
      //Shuffle
    }
}