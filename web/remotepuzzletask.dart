library remotepuzzletask;

import 'dart:math';
import 'dart:html';
import 'dart:async';

part 'touch.dart';
part 'box.dart';
part 'state.dart';
part 'game.dart';

WebSocket ws;

outputMsg(String msg) {

  print(msg);

}

//standard websocket setup
void initWebSocket([int retrySeconds = 2]) {
  var reconnectScheduled = false;
  outputMsg("Connecting to websocket");
  //final HOST = io.InternetAddress.LOOPBACK_IP_V4;
  final PORT = 8084;
  //ws = new WebSocket('ws://'+'10.101.150.184'+':'+PORT.toString()+'/ws');
  //ws = new WebSocket('ws://127.0.0.1:4040/ws');
  ws = new WebSocket('ws://10.101.150.184:4040/ws');
  void scheduleReconnect() {
    if (!reconnectScheduled) {
      new Timer(new Duration(milliseconds: 1000 * retrySeconds), () => initWebSocket(retrySeconds * 2));
    }
    reconnectScheduled = true;
  }

  ws.onOpen.listen((e) {
    outputMsg('Connected');
    ws.send('connected');
  });

  ws.onClose.listen((e) {
    outputMsg('Websocket closed, retrying in $retrySeconds seconds');
    scheduleReconnect();
  });

  ws.onError.listen((e) {
    outputMsg("Error connecting to ws");
    scheduleReconnect();
  });

  ws.onMessage.listen((MessageEvent e) {
      game.handleMsg(e.data);
//    outputMsg('Received message: ${e.data}');
  });
}


//make the game.
var game;

void main() {

  print("started");
  initWebSocket();
  game = new Game();

}

void repaint() {
  game.draw();
}

var imageWidth;
var imageHeight;


