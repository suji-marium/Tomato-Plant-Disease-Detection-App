
import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';
import 'Messages.dart';


class Bot extends StatefulWidget {
  const Bot({Key? key}) : super(key: key);

  @override
  State<Bot> createState() => _BotState();
}

class _BotState extends State<Bot> {

  late DialogFlowtter dialogFlowtter;
  final TextEditingController _controller=TextEditingController();
  List<Map<String, dynamic>> messages =[];
  @override
  void initState() {
    super.initState();
    dialogFlowtter = DialogFlowtter(); 
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('FarmBot',style: TextStyle(color: Colors.green),)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(child: MessagesScreen(messages: messages)),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8
              ),
              color: Color(0),
              child: Row(
                children: [
                  Expanded(child: 
                  Container(
                    height: 40,
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),hintText: 'Type a message'),
                      style: TextStyle(color: Colors.black),),
                  )),
                    IconButton(
                      onPressed: (){
                        sendMessage(_controller.text);
                        _controller.clear();
                      },icon: Icon(Icons.send),color: Colors.green,)
                ]),
            )
          ]),
      ),
    );
  
  }

sendMessage(String text) async {
  if (text.isNotEmpty) {
    setState(() {
      addMessage(Message(text: DialogText(text: [text])), true);
    });

    try {
      DetectIntentResponse response = await dialogFlowtter.detectIntent(
        queryInput: QueryInput(text: TextInput(text: text)),
      );

      if (response != null && response.message != null) {
        setState(() {
          addMessage(response.message!);
        });
      } else {
        // Handle case where response is null or response.message is null
        print('No response received from DialogFlowtter');
      }
    } catch (e) {
      // Handle errors during API call
      print('Error during detectIntent: $e');
    }
  }
}

  addMessage(Message message,[bool isUserMessage = false]){
    messages.add(
      {'message':message,
      'isUserMessage':isUserMessage}
    );
    //print(messages);
  }
}


