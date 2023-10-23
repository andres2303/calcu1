import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  bool isDarkTheme = true; // Variable para controlar el tema
  String userInput = "";
  String result = "0";

  List<String> buttonlist = [
    'AC', '(', ')', '/', '7', '8', '9', '*', '4', '5', '6', '+', '1', '2', '3', '-', 'C', '0', '.', '=',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = isDarkTheme ? ThemeData.dark() : ThemeData.light();

    return MaterialApp(
      theme: theme,
      home: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    alignment: Alignment.centerRight,
                    child: Text(
                      userInput,
                      style: TextStyle(fontSize: 32, color: Colors.white),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.centerRight,
                    child: Text(
                      result,
                      style: TextStyle(fontSize: 47, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: Colors.white),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                child: GridView.builder(
                  itemCount: buttonlist.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return CustomButton(buttonlist[index], theme);
                  },
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isDarkTheme = true;
                    });
                  },
                  child: Text("Dark Theme"),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isDarkTheme = false;
                    });
                  },
                  child: Text("Light Theme"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget CustomButton(String text, ThemeData theme) {
    return InkWell(
      splashColor: Colors.black,
      onTap: () {
        setState(() {
          handleButtons(text);
        });
      },
      child: Ink(
        decoration: BoxDecoration(
          color: getBgColor(text),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.1),
              blurRadius: 4,
              spreadRadius: 0.5,
              offset: Offset(-3, -3),
            )
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: getColors(text, theme),
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  getColors(String text, ThemeData theme) {
  if (theme.brightness == Brightness.light) {
    return const Color.fromARGB(255, 223, 207, 207);
  } else {
    if (text == '/' || text == '*' || text == '+' || text == '-' || text == 'C' || text == '(' || text == ')') {
      return Color.fromARGB(255, 252, 10, 23);
    }
    return Colors.white;
  }
}


  getBgColor(String text) {
    if (text == "AC") {
      return Color.fromARGB(255, 252, 10, 23);
    }
    if (text == "=") {
      return Color.fromARGB(255, 32, 77, 3);
    }
    return Color.fromARGB(255, 24, 29, 53);
  }

  handleButtons(String text) {
    if (text == "AC") {
      userInput = "";
      result = "0";
      return;
    }
    if (text == "C") {
      if (userInput.isNotEmpty) {
        userInput = userInput.substring(0, userInput.length - 1);
        return;
      } else {
        return null;
      }
    }

    if (text == "=") {
      result = calculate();
      userInput = result;

      if (userInput.endsWith(".0")) {
        userInput = userInput.replaceAll(".0", ".0");
        return;
      }

      if (result.endsWith(".0")) {
        result = result.replaceAll(".0", ".0");
        return;
      }
    }

    userInput = userInput + text;
  }

  String calculate() {
    try {
      var parser = Parser();
      var expression = parser.parse(userInput);
      var context = ContextModel();
      var result = expression.evaluate(EvaluationType.REAL, context);

      return result.toString();
    } catch (e) {
      return "Error";
    }
  }
}
