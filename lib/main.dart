import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'one time code',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'one time code'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  String message = "验证码:123456";
  List<String> receivers = ["13760000000"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: MediaQuery.of(context).size.width - 100,
                height: 70,
                child:Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                  child: KeyboardActions(config: _buildConfig(context),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText:"请输入验证码",
                        labelText: "验证码",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10),),
                          borderSide: BorderSide(color: Colors.blue,width: 2.0)
                        )
                      ),
                      focusNode: _focusNode,
                      controller: _controller,
                      autocorrect: true,
                      keyboardType: TextInputType.number,
                      autofillHints: [AutofillHints.oneTimeCode],
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              ElevatedButton(onPressed: () async {
                _sendSMS(message,receivers);
              }, child: Text("send SMS"))
            ],
          ),
      ),
    );
  }
  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
        keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
        keyboardBarColor: Colors.grey[200],
        nextFocus: true,
        actions: [
          KeyboardActionsItem(focusNode: _focusNode,toolbarButtons: [(node) {
            return GestureDetector(
              onTap: () {
                node.unfocus();
              },
              child: Padding(padding: EdgeInsets.all(8.0),child: Text('ok'),
              ),
            );
          }])
        ]
    );
  }
  _sendSMS(String message,List<String> receievers) async {
   String result = await sendSMS(message: message, recipients: receievers).catchError((onError) {
     if (kDebugMode) {
       print(onError);
     }
     return "";
   });
   if (kDebugMode) {
     print(result);
   }
  }
}
