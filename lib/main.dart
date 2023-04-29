import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Country App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'My Country App',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              ),
          ),
        ),
        body: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController countryEC = TextEditingController();
  var country = '';
  var name = '', cCode = '', cName = '', region = '', capital = '';
  String desc = '';
  String countryCode = '';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text("Country",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: countryEC,
                decoration: InputDecoration(
                    hintText: "Name of Country",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0))),
              ),
            ),
            ElevatedButton(
                onPressed: _loadcountry, child: const Text('Search Country')),
            Text(
              desc,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Flag:",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            if (countryCode.isNotEmpty)
              Container(
                  child: Image.network(
                    'https://flagsapi.com/$countryCode/flat/64.png',
                    height: 225,
                    width: 300,
                    fit: BoxFit.contain,
                  ),
                  color: Colors.blue),
          ],
        ),
      ),
    );
  }

  void _loadcountry() async {
    country = countryEC.text;
    var apiKey = 'ZYw6mZ7XGi97MfE9oM0htg==D3fec4KzoLYkrXMQ';
    var apiUrl = 'https://api.api-ninjas.com/v1/country?name=$country';

    ProgressDialog progressDialog1 = ProgressDialog(context,
        message: const Text("Progress"), title: const Text("Searching..."));
    ProgressDialog progressDialog2 = ProgressDialog(context,
        message: const Text("Not found"),
        title: const Text("Please Try Again!"));

    http.get(Uri.parse(apiUrl), headers: {'X-Api-Key': apiKey}).then(
        (response) {
      if (response.statusCode == 200) {
        var jsonData = response.body;
        var parsedJson = json.decode(jsonData);

        setState(() {
          name = parsedJson[0]['name'];
          region = parsedJson[0]['region'];
          capital = parsedJson[0]['capital'];
          cCode = parsedJson[0]['currency']['code'];
          cName = parsedJson[0]['currency']['name'];
          countryCode = parsedJson[0]['iso2'];
          desc =
              ' Country: \n Name: $name \n Region: $region \n Capital: $capital \n Currency Code: $cCode \n Currency Name: $cName';
          progressDialog1.show();
        });
        
      }
    }).catchError((error) {
      progressDialog2.show();
      countryEC.clear();
    });
    await Future.delayed(const Duration(seconds: 2));
    progressDialog1.dismiss();
    await Future.delayed(const Duration(seconds: 2));
    progressDialog2.dismiss();
  }
}
