part of simple_http_server;

/* myClient and additional functions code from:
* http://stackoverflow.com/questions/25982796/sending-mass-push-message-from-server-to-client-in-dart-lang-using-web-socket-m
*/
class myClient {
  DateTime time = new DateTime.now();
  num clientID = 1;
  WebSocket _socket;

  myClient(WebSocket ws){
        _socket = ws;
        _socket.listen(messageHandler,
                       onError: errorHandler,
                       onDone: finishedHandler);
  }

  void write(String message){ _socket.add(message); }

  void messageHandler(String msg){
//      print(msg);
    if(msg[0] == "d"){
      //print (msg);
      String tempMsg = msg.substring(2);
      List<String> data = tempMsg.split(",");
      myState.updateBox(num.parse(data[0]), num.parse(data[1]), num.parse(data[2]), data[3]);
      myState.checkPieceLocation(num.parse(data[0]));
      //myState.myBoxes[num.parse(data[0])-1].pieceLocation();
      logData('${time}, ${trial.trialNum}, ${tempMsg} \n', 'clientData.csv');
      //print (tempMsg);
    }
    if (msg[0] == "n"){
      //print(msg);
      String tempMsg = msg.substring(2);
      List<String> data = tempMsg.split(",");
      myState.assignNeighbor(num.parse(data[0]), data[1], num.parse(data[2]));
      myState.calculateScore();
    }
    if (msg[0] == "c"){
          //print(msg);
          String tempMsg = msg.substring(2);
          List<String> data = tempMsg.split(",");
          print (data);
          logData('Touch Down: ${data} \n', 'clientData.csv');
        }
    else if(msg[0] == "b"){
      String tempMsg = msg.substring(2);
      List<String> data = tempMsg.split(",");
      //print (data);
      myState.noDrag(num.parse(data[0]));
      
    }
    else if (msg[0]=="s")//the client sent the stage to which they want to begin with
      {
      String tempMsg = msg.substring(2);
      List<String> data = tempMsg.split(",");
      
      if (num.parse(data[0])-1>=trial.order.length)
      {
        print('Number entered is too large');
        trial.phaseStarted=true;
        trial.phaseEnd=true;
        trial.phase='END';
        trial.transition();
      }
      else{
        trial.setup([]);      
        trial.phase = 'BREAK';
        trial.phaseStarted=true;
        trial.phaseBreak = true;
        trial.phaseCongrats=false;
        trial.trialNum=num.parse(data[0])-1;
        trial.transition();
      }
    }
  }

  void errorHandler(error){
     print('one socket got error: $error');
     removeClient(this);
    _socket.close();
  }

  void finishedHandler() {
    print('one socket had been closed');
    distributeMessage('one socket had been closed');
    removeClient(this);
    _socket.close();
  }
}