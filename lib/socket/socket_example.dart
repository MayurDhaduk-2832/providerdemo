import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;


class SocketExample extends StatefulWidget {
  const SocketExample({Key key}) : super(key: key);

  @override
  _SocketExampleState createState() => _SocketExampleState();
}

class _SocketExampleState extends State<SocketExample> {

  var data = "";
  IO.Socket socket;

  connectSocketIo(){

    socket = IO.io('https://www.oneqlik.in/gps', <String, dynamic>{
      "secure": true,
      "rejectUnauthorized": false,
      "transports":["websocket", "polling"],
      "upgrade": false
    });

    socket.connect();
socket.emit("acc","868003032580727");
    socket.onConnect((data) {
      print("Socket is connected");
      print(data);
      socket.on("868003032580727acc", (data) {
        print("this is data form $data");
       // sendData();
      });
    });
  }


  @override
  void initState() {
    super.initState();
    connectSocketIo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
      ),
    );
  }
}
