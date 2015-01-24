part of simple_http_server;

class Trial{
  var phase = 'TRIAL ZERO';
  num trialNum = 0;
  bool phaseBreak = true;

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
                           ['red', 'blue', 'green', 'black'],
                           ['red', 'blue', 'green', 'purple'],
                           ['red', 'blue', 'green',  'black']];
     switch(phase){
          case 'TRIAL ZERO':
              phase = 'BREAK';
              phaseBreak = true;
              setup([]);
              new Timer(const Duration(seconds : 10), () {
                 transition();
              });
              break;
          case 'BREAK':
              phase = 'TRIAL ONE';
              phaseBreak = false;
              trialNum += 1;
              setup(order[0]);
              break;
          case 'TRIAL ONE':
              phase = 'BREAK1';
              phaseBreak = true;
              setup([]);
              new Timer(const Duration(seconds : 10), () {
                  transition();
              });
              break;
           case 'BREAK1':
              phase = 'TRIAL TWO';
              myState.score = 100;
              phaseBreak = false;
              trialNum += 1;
              setup(order[1]);
              break;
           case 'TRIAL TWO':
              phase = 'TRIAL THREE';
              myState.score = 100;
              phaseBreak = false;
              trialNum += 1;
              setup(order[2]);
              break;
           case 'TRIAL THREE':
              phase = 'TRIAL FOUR';
              myState.score = 100;
              phaseBreak = false;
              trialNum += 1;
              setup(order[3]);
              break;
           }
      
   }
  
}