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
  print(output);
  response.insert(0, output);

  return output;
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

var path = "null";

class _MyAppState extends State<MyApp> {
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
              Text("Machine Mind", style: GoogleFonts.bayon()),
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
                              : Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                width: MediaQuery.of(context).size.width / 1.4,
                                decoration: BoxDecoration(
                                    color: response[index][0] == "_"
                                        ? Colors.orange[300]
                                        : Colors.green[300],
                                    borderRadius: response[index][0] == "_"
                                        ? const BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            bottomLeft: Radius.circular(20),
                                            topRight: Radius.circular(20))
                                        : const BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20),
                                            topRight: Radius.circular(20))),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SelectableText(
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
                        setState(() {
                          q = query.text;
                          query.clear();
                          response.insert(0, "_" + q);
                        });
                      },
                      icon: const Icon(
                        Icons.send,
                        color: Colors.deepPurpleAccent,
                      ))
                ],
              ),
            )
          ],
        ));
  }
}
