import "package:flutter/material.dart";
import "package:lottie/lottie.dart";

class Splashpage extends StatelessWidget {
  const Splashpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Lottie.network(
              "https://lottie.host/embed/f372339b-05e7-4211-a35e-5f071087c74f/lnoPunChDp.json")),
    );
  }
}
