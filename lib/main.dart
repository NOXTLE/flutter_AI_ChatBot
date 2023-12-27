import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_gemini/google_gemini.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
}

var q;
List response = [];

var query = TextEditingController();
Future getData() async {
  final gemini = GoogleGemini(
    apiKey: "AIzaSyC_ac0zd8AYxrgAyXOlVteBX12_P2hEHg8",
  );

  var answer = await gemini.generateFromText(q);

  var output = answer.text;

  response.insert(0, output);

  return output;
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

var path = "null";
var img = null;
var qu = null;

class _MyAppState extends State<MyApp> {
  var userimage = [];
  Widget build(context) {
    return Scaffold(
        backgroundColor: Colors.brown[100],
        appBar: AppBar(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          // shape: CircleBorder(eccentricity: 0.8),
          backgroundColor: const Color.fromARGB(188, 2, 29, 52),
          elevation: 0,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                "https://uxwing.com/wp-content/themes/uxwing/download/internet-network-technology/artificial-intelligence-ai-icon.png",
                height: 40,
                width: 50,
              ),
              Text("Machine Mind",
                  style: GoogleFonts.bayon(
                      textStyle: TextStyle(color: Colors.white))),
            ],
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: getData(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  var data = snapshot.data;
                  return ListView.builder(
                      reverse: true,
                      itemCount: response.length,
                      itemBuilder: (context, index) {
                        return Container(
                          alignment: response[index][0] == "_"
                              ? Alignment.centerRight
                              : response[index][0] == "+"
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                width: MediaQuery.of(context).size.width / 1.4,
                                decoration: BoxDecoration(
                                    color: response[index][0] == "_"
                                        ? Colors.orange[300]
                                        : response[index][0] == "+"
                                            ? Colors.orange[300]
                                            : Colors.green[300],
                                    borderRadius: response[index][0] == "_"
                                        ? const BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            bottomLeft: Radius.circular(20),
                                            topRight: Radius.circular(20))
                                        : response[index][0] == "+"
                                            ? const BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                bottomLeft: Radius.circular(20),
                                                topRight: Radius.circular(20))
                                            : const BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                bottomRight:
                                                    Radius.circular(20),
                                                topRight: Radius.circular(20))),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: response[index][0] == "+"
                                      ? Image.file(File(path))
                                      : response[index][0] == "_"
                                          ? SelectableText(
                                              response[index].substring(1))
                                          : SelectableText(
                                              response[index],
                                            ),
                                )),
                          ),
                        );
                      });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: query,
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.horizontal(
                                  right: Radius.circular(10),
                                  left: Radius.circular(10))),
                          label: Text("Enter the queries here")),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              var control = TextEditingController();
                              return AlertDialog(
                                content: Container(
                                  height: 500,
                                  width: 500,
                                  child: StatefulBuilder(
                                      builder: (context, state) {
                                    return Center(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        TextButton(
                                            onPressed: () async {
                                              var image = await ImagePicker()
                                                  .pickImage(
                                                      source:
                                                          ImageSource.gallery);
                                              state(() => path = image!.path);
                                            },
                                            child: Text("Choose From Gallery")),
                                        TextButton(
                                            onPressed: () async {
                                              var image = await ImagePicker()
                                                  .pickImage(
                                                      source:
                                                          ImageSource.camera);
                                              state(() => path = image!.path);
                                            },
                                            child: Text("Choose From camera")),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        path != "null"
                                            ? Image.file(
                                                File(path),
                                                height: 100,
                                                width: 100,
                                              )
                                            : Text("^SELECT IMAGE"),
                                        TextField(
                                          controller: control,
                                          decoration: InputDecoration(
                                              hintText: "Enter Prompt",
                                              border: OutlineInputBorder()),
                                        ),
                                        ElevatedButton(
                                            onPressed: () async {
                                              var gemini = GoogleGemini(
                                                  apiKey:
                                                      "AIzaSyC_ac0zd8AYxrgAyXOlVteBX12_P2hEHg8");
                                              var re = await gemini
                                                  .generateFromTextAndImages(
                                                      query: control.text,
                                                      image: File(path));
                                              var o = re.text;

                                              setState(() {
                                                response.insert(
                                                    0,
                                                    "+" +
                                                        File(path).toString());
                                                response.insert(0, o);

                                                response.insert(
                                                    1, "_" + control.text);
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Text("Submit"))
                                      ],
                                    ));
                                  }),
                                ),
                              );
                            });
                      },
                      icon: Icon(Icons.camera_alt_outlined)),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        q = query.text;
                        query.clear();
                        response.insert(0, "_" + q);
                      });
                    },
                    icon: const Icon(
                      Icons.send,
                      color: Colors.deepPurpleAccent,
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
