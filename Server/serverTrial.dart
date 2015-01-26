part of simple_http_server;

class Trial{
  var phase = 'Start';
  num trialNum = 0;
  bool phaseBreak = true;
  num trialID = 0;

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
    }

  void transition() {
     List<String> order = [
                           ['plaid1', 'plaid2', 'plaid3', 'plaid4', 'plaid5', 'plaid6', 'plaid7', 'plaid8', 'plaid9'],
                           ['rainbow1', 'rainbow2', 'rainbow3', 'rainbow4','rainbow5','rainbow6','rainbow7','rainbow8','rainbow9',],
                           ['redplaid_01', 'redplaid_02', 'redplaid_03', 'redplaid_04', 'redplaid_05', 'redplaid_06', 'redplaid_07', 'redplaid_08', 'redplaid_09'],
                           ];
     
     switch(phase){
          case 'Start':
              phase = 'BREAK';
              phaseBreak = true;
              setup([]);
              new Timer(const Duration(seconds : 10), () {
                 transition();
              });
              break;
          case 'BREAK':
              phase = 'TRIAL';
              phaseBreak = true;
              setup([]);
              new Timer(const Duration(seconds : 10), () {
                                transition();
              });
              break;
          case 'TRIAL':
              phase = 'BREAK';
              phaseBreak = false;
              setup(order[trialNum]);
              trialNum += 1;
              break;
           case 'BREAK':
              phaseBreak = true;
              break;
           }
      
     
//     switch(phase){
//          case 'TRIAL ZERO':
//              phase = 'BREAK';
//              phaseBreak = true;
//              setup([]);
//              new Timer(const Duration(seconds : 10), () {
//                 transition();
//              });
//              break;
//          case 'BREAK':
//              phase = 'TRIAL ONE';
//              phaseBreak = false;
//              trialNum += 1;
//              setup(order[0]);
//              break;
//          case 'TRIAL ONE':
//              phase = 'BREAK1';
//              phaseBreak = true;
//              setup([]);
//              new Timer(const Duration(seconds : 10), () {
//                  transition();
//              });
//              break;
//           case 'BREAK1':
//              phase = 'TRIAL TWO';
//              myState.score = 100;
//              phaseBreak = false;
//              trialNum += 1;
//              setup(order[1]);
//              break;
//           case 'TRIAL TWO':
//              phase = 'TRIAL THREE';
//              myState.score = 100;
//              phaseBreak = false;
//              trialNum += 1;
//              setup(order[2]);
//              break;
//           case 'TRIAL THREE':
//              phase = 'TRIAL FOUR';
//              myState.score = 100;
//              phaseBreak = false;
//              trialNum += 1;
//              setup(order[3]);
//              break;
//           }
      
   }
  
}