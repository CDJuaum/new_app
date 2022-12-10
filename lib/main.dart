import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:calculo_iva/sizes_helpers.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.system,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Calculadora de IVA'),
          centerTitle: true,
        ),
        body: MyAppBody(),
      ),
    );
  }
}

class MyAppBody extends StatefulWidget {
  @override
  _MyAppBodyState createState() => _MyAppBodyState();
}

class _MyAppBodyState extends State<MyAppBody> {
  bool isChecked = false;
  double _inputValue = 0.00;
  double _result = 0.00;
  double _iva = 0.00;
  double _IRS = 0.00;
  String res = "";
  String copy = "";
  double _copyres = 0.00;
  double _copyresround = 0.00;

  void _calculateResult() {
    if (isChecked) {
      _result = _inputValue * 1.115;
      _result = double.parse(_result.toStringAsFixed(2));
      _IRS = _inputValue * 0.115;
      _IRS = double.parse(_IRS.toStringAsFixed(2));
      _iva = _inputValue * 0.23;
      _iva = double.parse(_iva.toStringAsFixed(2));
      res = "Valor do IVA: $_iva\nValor do IRS: $_IRS\nValor a receber: $_result";
      _copyres = _inputValue - _IRS;
      _copyresround = double.parse(_copyres.toStringAsFixed(2));
      copy = "$_copyresround€ líquido\n$_iva€ iva\n$_IRS€ irs";
    } else {
      _result = _inputValue * 1.23;
      _result = double.parse(_result.toStringAsFixed(2));
      _iva = _inputValue * 0.23;
      _iva = double.parse(_iva.toStringAsFixed(2));
      res = "Valor do IVA: $_iva\nValor a receber: $_result";
      copy = "$_inputValue€ líquido\n$_iva€ iva";
    }
    setState(() {});
  }

  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: copy));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Valores copiados', textAlign: TextAlign.center),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('\n', textScaleFactor: 1,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage('assets/images/pronto.png'), height: displayHeight(context)*0.1),
          ],
        ),
        Text('\n', textScaleFactor: 1.5,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Checkbox(
              value: isChecked,
              onChanged: (bool? value) {
                setState(() {
                 isChecked = value!;
                });
              },
           ),
            Text('Marcar caso NIF seja empresarial.', textScaleFactor: 1),
          ],
        ),
        Text('\n', textScaleFactor: 0.5,),
        SizedBox(
          width: displayWidth(context)*0.9,
          child: TextField(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Insira o valor (decimais com ponto, não vírgula.)',
            ),
            onChanged: (value) {
              setState(() {
                _inputValue = double.parse(value);
              });
            },
          ),
        ),
        
        Text('\n', textScaleFactor: 0.5,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _calculateResult,
              child: const Text("calcular"),
            ),
            Text('    Valor introduzido: $_inputValue', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        Text('\n'),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: displayHeight(context)*0.2,
              child: Text(res, textAlign: TextAlign.center, textScaleFactor: 2, style: TextStyle(fontWeight: FontWeight.bold),),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: _copyToClipboard,
          child: const Text("copiar resultados"),
        ),
      ],
    );
  }
}