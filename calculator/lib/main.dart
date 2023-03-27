import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:math_expressions/math_expressions.dart';

abstract class Routes {
  static const history = '/history';
  static const home = "/home";
}

class AppPages {
  static final routes = [
    GetPage(name: Routes.home, page: () => CalculatorScreen()),
    GetPage(name: Routes.history, page: () => HistoryScreen())
  ];
}

void main() async {
  await GetStorage.init();
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    defaultTransition: Transition.fade,
    getPages: AppPages.routes,
    initialRoute: Routes.home,
    theme: ThemeData(brightness: Brightness.dark),
  ));
  if (GetPlatform.isMobile != true) {
    doWhenWindowReady(() {
      const initialSize = Size(800, 600);
      appWindow.minSize = initialSize;
      appWindow.size = initialSize;
      appWindow.alignment = Alignment.center;
      appWindow.title = "Numeration";
      appWindow.show();
    });
  }
}

class CalculatorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CalculatorController controller = Get.put(CalculatorController());

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16.0),
              color: Colors.grey[200],
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    backgroundColor: Colors.blue,
                    onPressed: () => controller.showHistory(),
                    child: Icon(
                      Icons.history,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Obx(() => Text(
                              '${controller.equation.value}',
                              style: TextStyle(
                                  fontSize: 32.0, color: Colors.black),
                              textAlign: TextAlign.end,
                            )),
                        Obx(() => Text(
                              '${controller.result.value}',
                              style: TextStyle(
                                  fontSize: 64.0, color: Colors.black),
                              textAlign: TextAlign.end,
                            )),
                        Obx(() => Text(
                              '${controller.lastEquation.value}',
                              style:
                                  TextStyle(fontSize: 25.0, color: Colors.grey),
                              textAlign: TextAlign.end,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CalculatorButton(
                      text: 'C',
                      onPressed: () => controller.clear(),
                      color: Colors.grey,
                    ),
                    CalculatorButton(
                      text: '+/-',
                      onPressed: () => controller.negate(),
                      color: Colors.grey,
                    ),
                    CalculatorButton(
                      text: '%',
                      onPressed: () => controller.percent(),
                      color: Colors.grey,
                    ),
                    CalculatorButton(
                      text: '/',
                      onPressed: () => controller.operation(Operation.divide),
                      color: Colors.blue,
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CalculatorButton(
                        text: '7',
                        onPressed: () => controller.numberPressed(7)),
                    CalculatorButton(
                        text: '8',
                        onPressed: () => controller.numberPressed(8)),
                    CalculatorButton(
                        text: '9',
                        onPressed: () => controller.numberPressed(9)),
                    CalculatorButton(
                      text: '*',
                      onPressed: () => controller.operation(Operation.multiply),
                      color: Colors.blue,
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CalculatorButton(
                        text: '4',
                        onPressed: () => controller.numberPressed(4)),
                    CalculatorButton(
                        text: '5',
                        onPressed: () => controller.numberPressed(5)),
                    CalculatorButton(
                        text: '6',
                        onPressed: () => controller.numberPressed(6)),
                    CalculatorButton(
                      text: '-',
                      onPressed: () => controller.operation(Operation.subtract),
                      color: Colors.blue,
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CalculatorButton(
                        text: '1',
                        onPressed: () => controller.numberPressed(1)),
                    CalculatorButton(
                        text: '2',
                        onPressed: () => controller.numberPressed(2)),
                    CalculatorButton(
                        text: '3',
                        onPressed: () => controller.numberPressed(3)),
                    CalculatorButton(
                      text: '+',
                      onPressed: () => controller.operation(Operation.add),
                      color: Colors.blue,
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CalculatorButton(
                      text: '0',
                      onPressed: () => controller.numberPressed(0),
                      flex: 2,
                    ),
                    CalculatorButton(
                      text: '.',
                      onPressed: () => controller.decimal(),
                    ),
                    CalculatorButton(
                      text: '=',
                      onPressed: () => controller.equals(),
                      color: Colors.blue,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CalculatorButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final int flex;

  const CalculatorButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.color = Colors.grey,
    this.flex = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        margin: EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(fontSize: 24.0),
          ),
          style: ElevatedButton.styleFrom(
            primary: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            padding: EdgeInsets.all(16.0),
          ),
        ),
      ),
    );
  }
}

enum Operation { add, subtract, multiply, divide }

class CalculatorController extends GetxController {
  RxString equation = ''.obs;
  RxString result = ''.obs;
  RxString lastEquation = ''.obs;

  void numberPressed(int number) {
    if (equation.value.length >= 13) {
      return;
    }
    if (equation.value == '0' && number == 0) {
      return;
    }
    if (equation.value == '0') {
      equation.value = '';
    }

    equation.value += number.toString();

    //update();
  }

  void decimal() {
    if (!equation.value.contains('.')) {
      equation.value += '.';
    }
    //update();
  }

  void operation(Operation operation) {
    if (result.value.isNotEmpty && equation.value.isEmpty) {
      equation.value = result.value;
    }
    if (equation.value.isEmpty) {
      return;
    }
    var last = equation.value.characters.last;
    if (['+', '-', '*', '/'].contains(last)) {
      return;
    }
    if (last == '.') {
      return;
    }

    switch (operation) {
      case Operation.add:
        equation.value += '+';
        break;
      case Operation.subtract:
        equation.value += '-';
        break;
      case Operation.multiply:
        equation.value += '*';
        break;
      case Operation.divide:
        equation.value += '/';
        break;
    }

    //update();
  }

  void clear() {
    equation.value = '0';
    result.value = '';
    //update();
  }

  void negate() {
    if (equation.value.isEmpty) {
      return;
    }
    if (equation.value.startsWith('-')) {
      equation.value = equation.value.substring(1);
    } else {
      equation.value = '-' + equation.value;
    }

    //update();
  }

  void percent() {
    if (equation.value.isEmpty) {
      return;
    }
    final value = double.parse(equation.value) / 100.0;
    equation.value = value.toString();
    //update();
  }

  void equals() {
    if (equation.value.isEmpty) {
      return;
    }
    try {
      final res = Calculator.eval(equation.value);
      lastEquation.value = equation.value;
      result.value = res.toString();

      saveHistory(equation.value, result.value);
      equation.value = '';
    } catch (e) {
      result.value = 'Error';
    }

    //update();
  }

  void showHistory() {
    Get.toNamed(Routes.history);
  }

  void saveHistory(String equation, String result) {
    final history = GetStorage();
    final now = DateTime.now();
    final data = {
      'equation': equation,
      'timestamp': now.toString(),
      'result': result
    };

    if (history.hasData('history')) {
      final List<dynamic> historyData = history.read('history');

      if (historyData.length >= 10) {
        historyData.removeAt(0);
      }

      historyData.add(data);
      history.write('history', historyData);
    } else {
      history.write('history', [data]);
    }
  }
}

class Calculator {
  static dynamic eval(String equation) {
    Parser p = Parser();
    Expression exp = p.parse(equation);
    double result = exp.evaluate(EvaluationType.REAL, ContextModel());
    if (result % 1 == 0) {
      // 可以舍弃小数点后面部分
      return result.toInt();
    } else {
      // 小数点后面部分不为零，不能舍弃
      return result;
    }
  }
}

class HistoryController extends GetxController {
  final storage = GetStorage();

  List<dynamic> data = [];

  @override
  void onReady() {
    super.onReady();
    getHistory();
  }

  getHistory() {
    if (storage.hasData('history')) {
      final List<dynamic> historyData = storage.read('history');

      data = historyData.reversed.toList();
      print(data);
      update();
    }
  }
}

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(HistoryController());
    final controller = Get.find<CalculatorController>();
    return GetBuilder<HistoryController>(builder: (logic) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          brightness: Brightness.dark,
          backgroundColor: Colors.blue,
          title: Text("History"),
        ),
        body: ListView.builder(
          itemCount: logic.data.length,
          itemBuilder: (BuildContext context, int index) {
            final item = logic.data[index];
            final equation = item['equation'] ?? "";
            final timestamp = item['timestamp'] ?? "";
            final result = item['result'] ?? "";
            return ListTile(
              title: Text(equation + " = " + result,style: TextStyle(color: Colors.black)),
              subtitle: Text(timestamp,style: TextStyle(color: Colors.grey)),
              onTap: () {
                controller.clear();
                controller.numberPressed(int.parse(result));
                Get.back();
              },
            );
          },
        ),
      );
    });
  }
}
