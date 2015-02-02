library simple_http_server;

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:http_server/http_server.dart' show VirtualDirectory;
//import 'package:image/image.dart' ;

part 'serverBox.dart';
part 'serverState.dart';
part 'serverTrial.dart';
part 'serverClient.dart';
part 'imgSets.dart';


//List of Clients connected to the server
List<myClient> clients = new List();


//Function to Manage Clients
void handleWebSocket(WebSocket socket){
  print('Client connected!');
  myClient client = new myClient(socket);
  addClient(client);
}

//Serve denial requests
void serveRequest(HttpRequest request){
  request.response.statusCode = HttpStatus.FORBIDDEN;
  request.response.reasonPhrase = "WebSocket connections only";
  request.response.close();
}

//Send Message to all Clients
void distributeMessage(String msg){
   for (myClient c in clients)c.write(msg);
 }

void sendID (){
  num ID = 1;
  for (myClient e in clients){
     e.write("i: ${ID}, ${trial.trialNum}");
    ID ++;
  }
}

void logData(String msg, String filename){
  //final filename = 'data.csv';
  //print("logging"+filename);
  /*
  try{
    var file = new File(filename);
      var sink = file.openWrite(mode: FileMode.APPEND);
      sink.write(msg);
  } on FileSystemException catch (ex){
    print(ex);
  }
  catch (exception,stacktrace){
        print(exception);
        print(stacktrace);
  }
  *
   */
}

 void addClient(myClient c){
     clients.add(c);
 }

 void removeClient(myClient c){
      clients.remove(c);
 }


VirtualDirectory virDir;

var random = new Random();



//initalize myState global var.
State myState;
Trial trial;



//server handling the path for files, might not be needed
//void directoryHandler(dir, request) {
//  var indexUri = new Uri.file(dir.path).resolve('test.html');
//  virDir.serveFile(new File(indexUri.toFilePath()), request);
//}



void main() {

  //server pathing
  var pathToBuild = "/Users/sarahdangelo/dart/RemotePuzzleTask/build/web";

  var staticFiles = new VirtualDirectory(pathToBuild);
  staticFiles.allowDirectoryListing = true;
  staticFiles.directoryHandler = (dir, request) {
    var indexUri = new Uri.file(dir.path).resolve('remotepuzzletask.html');
    staticFiles.serveFile(new File(indexUri.toFilePath()), request);
  };
  
  final HOST = InternetAddress.LOOPBACK_IP_V4;
  final PORT = 8084;
  
  //serve the test.html to port 8080
  HttpServer.bind(InternetAddress.ANY_IP_V4, 8084).then((server) {
  //HttpServer.bind('127.0.0.1', 8084).then((server) {
    server.listen(staticFiles.serveRequest);
  });

  //setup websocket at 4040
  runZoned(() {
    HttpServer.bind(InternetAddress.ANY_IP_V4, 4040).then((server) {
    //HttpServer.bind('127.0.0.1', 4040).then((server) {
      server.listen((HttpRequest req) {
        if (req.uri.path == '/ws') {
          // Upgrade a HttpRequest to a WebSocket connection.
          WebSocketTransformer.upgrade(req).then((handleWebSocket));
         }
        else {
          print("Regular ${req.method} request for: ${req.uri.path}");
          serveRequest(req);
          }
      });
    });
  },
  onError: (e) => print(e));

  trial = new Trial();

  //setup times to update the state and send out messages to clients out with state information
  //running at about 15fps
  new Timer.periodic(const Duration(milliseconds : 30), (timer) => myState.updateState());

}