import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalculatorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String output = "0";
  double num1 = 0;
  double num2 = 0;
  String operand = "";

  buttonPressed(String buttonText) async {
    setState(() {
      if (buttonText == "CLEAR") {
        output = "0";
        num1 = 0;
        num2 = 0;
        operand = "";
      } else if (buttonText == "+" ||
          buttonText == "-" ||
          buttonText == "/" ||
          buttonText == "*") {
        num1 = double.parse(output);
        operand = buttonText;
        output = "0";
      } else if (buttonText == ".") {
        if (output.contains(".")) {
          print("Already contains a decimal");
          return;
        } else {
          output = output + buttonText;
        }
      } else if (buttonText == "=") {
        num2 = double.parse(output);
        performCalculation();
      } else {
        output = output + buttonText;
      }
    });
  }

  void performCalculation() async {
    var url = Uri.parse('https://shujaahost.co.ke/calculator.php');
    var response = await http.post(url, body: {
      'num1': num1.toString(),
      'num2': num2.toString(),
      'operator': operand,
    });

    if (response.statusCode == 200) {
      setState(() {
        output = response.body;
      });
    } else {
      setState(() {
        output = "Error: ${response.statusCode}";
      });
    }
  }

  Widget buildButton(String buttonText) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: () => buttonPressed(buttonText),
          child: Text(
            buttonText,
            style: TextStyle(fontSize: 20.0),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calculator')),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(
                vertical: 24.0,
                horizontal: 12.0,
              ),
              child: Text(
                output,
                style: TextStyle(
                  fontSize: 48.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(child: Divider()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                buildButton("7"),
                buildButton("8"),
                buildButton("9"),
                buildButton("/"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                buildButton("4"),
                buildButton("5"),
                buildButton("6"),
                buildButton("*"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                buildButton("1"),
                buildButton("2"),
                buildButton("3"),
                buildButton("-"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                buildButton("."),
                buildButton("0"),
                buildButton("CLEAR"),
                buildButton("+"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                buildButton("="),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
