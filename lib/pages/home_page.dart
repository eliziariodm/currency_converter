import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; //Don't forget to install the http package.
import 'dart:async';
import 'dart:convert';

const request = /*Before debugging, use the website https://api.hgbrasil.com
and put your API key here.*/

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double dolar;
  double euro;

  void _clearAll() {
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  void _realChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[400],
      appBar: AppBar(
        title: Text("Conversor de Moedas"),
        backgroundColor: Colors.blue[400],
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                  child: Text(
                "Carregando Dados...",
                style: TextStyle(color: Colors.white, fontSize: 25.0),
                textAlign: TextAlign.center,
              ));
            default:
              if (snapshot.hasError) {
                return Center(
                    child: Text(
                  "Erro ao Carregar Dados...",
                  style: TextStyle(color: Colors.white, fontSize: 25.0),
                  textAlign: TextAlign.center,
                ));
              } else {
                dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];

                return SingleChildScrollView(
                  padding: EdgeInsets.only(top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height / 4.5,
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Image.asset("assets/pay.png"),
                        ),
                      ),
                      buildTextField("assets/brazil.png", "Reais", "R\$ ",
                          realController, _realChanged),
                      buildTextField("assets/eua.png", "Dólares", "US\$ ",
                          dolarController, _dolarChanged),
                      buildTextField("assets/eu.png", "Euros", "€\$ ",
                          euroController, _euroChanged)
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }

  Widget buildTextField(String image, String label, String prefix,
      TextEditingController controller, Function functionChanged) {
    return Row(
      children: <Widget>[
        Flexible(
          flex: 1,
          child: Container(
            child: Padding(
              padding: EdgeInsets.only(top: 30, left: 5, right: 5, bottom: 10),
              child: Image.asset(image),
            ),
          ),
        ),
        Flexible(
          flex: 4,
          child: Padding(
            padding: EdgeInsets.only(top: 20, right: 10),
            child: TextField(
              controller: controller,
              cursorColor: Colors.white,
              decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(color: Colors.white),
                prefixText: prefix,
                prefixStyle: TextStyle(color: Colors.white, fontSize: 25),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: TextStyle(color: Colors.white, fontSize: 25),
              onChanged: functionChanged,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
          ),
        ),
      ],
    );
  }
}
