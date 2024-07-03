import 'package:flutter/material.dart';
import 'package:calc_app/button_values.dart';
import 'history_screen.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String number1 = "";
  String operand = "";
  String number2 = "";
  String result = "";

  List<String> history = [];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLandscape = screenSize.width > screenSize.height;
    final buttonFontSize =
        isLandscape ? 20.0 : 26.0; // Adjust font size based on orientation
    const crossAxisCount = 4; // Consistent columns count

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 203, 201, 201),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.history,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoryScreen(history: history),
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 237, 236, 236),
      body: SafeArea(
        bottom: false,
        child: isLandscape
            ? Row(
                children: [
                  // Calculation Display Section
                  Expanded(
                    child: Container(
                      alignment: const Alignment(0.9, 0.2),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "$number1$operand$number2".isEmpty
                                ? "0"
                                : "$number1$operand$number2",
                            style: const TextStyle(
                              fontSize: 36.0,
                              color: Colors.black,
                            ),
                          ),
                          Opacity(
                            opacity: 0.6,
                            child: Text(
                              result.isEmpty ? "" : result,
                              style: const TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Buttons Section
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(10.0),
                      itemCount: Btn.buttonValues.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 55,
                      ),
                      itemBuilder: (context, index) {
                        final value = Btn.buttonValues[index];
                        return buildButton(value, buttonFontSize, isLandscape);
                      },
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Calculation Display Section
                  Expanded(
                    child: SingleChildScrollView(
                      reverse: true,
                      child: Container(
                        alignment: const Alignment(0.9, 0.2),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "$number1$operand$number2".isEmpty
                                  ? "0"
                                  : "$number1$operand$number2",
                              style: const TextStyle(
                                fontSize: 48.0,
                                color: Colors.black,
                              ),
                            ),
                            Opacity(
                              opacity: 0.6,
                              child: Text(
                                result.isEmpty ? "" : result,
                                style: const TextStyle(
                                  fontSize: 36.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // Buttons Section
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(10.0),
                      itemCount: Btn.buttonValues.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 40,
                      ),
                      itemBuilder: (context, index) {
                        final value = Btn.buttonValues[index];
                        return buildButton(value, buttonFontSize, isLandscape);
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
      ),
    );
  }

  Widget buildButton(String value, double fontSize, bool isLandscape) {
    return Padding(
      padding:
          isLandscape ? const EdgeInsets.all(6.0) : const EdgeInsets.all(4.0),
      child: Material(
        shape: isLandscape
            ? RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              )
            : const CircleBorder(),
        color: getBtnColor(value),
        clipBehavior: Clip.hardEdge,
        textStyle: TextStyle(color: textColor(value)),
        child: InkWell(
          onTap: () => onBtnTap(value),
          child: Center(
            child: Container(
              width: isLandscape ? 60.0 : 80.0,
              height: isLandscape ? 60.0 : 80.0,
              alignment: Alignment.center,
              child: Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onBtnTap(String value) {
    if (value == Btn.del) {
      delete();
      return;
    }

    if (value == Btn.allclr) {
      clearAll();
      return;
    }

    if (value == Btn.equalto) {
      eqaulto();
      return;
    }

    appendValue(value);
  }

  void eqaulto() {
    if (number1.isEmpty) return;
    if (operand.isEmpty) return;
    if (number2.isEmpty) return;

    final double num1 = double.parse(number1);
    final double num2 = double.parse(number2);

    var calcResult = 0.0;
    switch (operand) {
      case Btn.add:
        calcResult = num1 + num2;
        break;
      case Btn.subtract:
        calcResult = num1 - num2;
        break;
      case Btn.multiply:
        calcResult = num1 * num2;
        break;
      case Btn.divide:
        calcResult = num1 / num2;
        break;
      case Btn.percent:
        calcResult = (num1 / 100) * num2;
        break;
    }

    final historyEntry =
        "$number1 $operand $number2 = ${calcResult.toStringAsPrecision(5)}";

    setState(() {
      result = calcResult.toStringAsPrecision(5);

      if (result.endsWith(".0")) {
        result = result.substring(0, result.length - 2);
      }

      number1 = number1;
      operand = operand;
      number2 = number2;

      history.add(historyEntry);
    });
  }

  void clearAll() {
    setState(() {
      number1 = "";
      operand = "";
      number2 = "";
      result = "";
    });
  }

  void delete() {
    if (number2.isNotEmpty) {
      number2 = number2.substring(0, number2.length - 1);
    } else if (operand.isNotEmpty) {
      operand = "";
    } else if (number1.isNotEmpty) {
      number1 = number1.substring(0, number1.length - 1);
    }

    setState(() {});
  }

  void appendValue(String value) {
    if (value != Btn.dot && int.tryParse(value) == null) {
      if (operand.isNotEmpty && number2.isNotEmpty) {
        eqaulto();
      }
      operand = value;
    } else if (number1.isEmpty || operand.isEmpty) {
      if (value == Btn.dot && number1.contains(Btn.dot)) return;
      if (value == Btn.dot && (number1.isEmpty || number1 == Btn.n0)) {
        value = "0.";
      }
      number1 += value;
    } else if (number2.isEmpty || operand.isNotEmpty) {
      if (value == Btn.dot && number2.contains(Btn.dot)) return;
      if (value == Btn.dot && (number2.isEmpty || number2 == Btn.n0)) {
        value = "0.";
      }
      number2 += value;
    }
    setState(() {});
  }

  Color textColor(value) {
    return [
      Btn.percent,
      Btn.multiply,
      Btn.add,
      Btn.subtract,
      Btn.divide,
      Btn.del,
      Btn.allclr
    ].contains(value)
        ? Colors.black
        : [Btn.equalto].contains(value)
            ? Colors.white
            : Colors.black;
  }

  Color getBtnColor(value) {
    return [
      Btn.percent,
      Btn.multiply,
      Btn.add,
      Btn.subtract,
      Btn.divide,
      Btn.del,
      Btn.allclr
    ].contains(value)
        ? const Color.fromARGB(255, 144, 136, 136)
        : [Btn.equalto].contains(value)
            ? Colors.orange
            : Colors.white;
  }
}
