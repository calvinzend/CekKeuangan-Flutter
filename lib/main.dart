import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'detail.dart';
import 'Input.dart';

void main() {
  runApp(MaterialApp(title: 'Flutter Demo', home: InfoKeuanganPage(),debugShowCheckedModeBanner: false,));
}

class InfoKeuanganPage extends StatefulWidget {
  const InfoKeuanganPage({super.key});

  @override
  State<InfoKeuanganPage> createState() => _InfoKeuanganState();
}

class _InfoKeuanganState extends State<InfoKeuanganPage> {

  List dataJSON = [];
  Future<void> _loadData() async {
  try {
    final response = await http.get(
      Uri.parse("http://192.168.56.1:3000/transactions"),
      headers: {"Accept": "application/json"},
    );

    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      setState(() {
        dataJSON = json.decode(response.body);
      });
    } else {
      print("Error: ${response.statusCode}");
    }
  } catch (e) {
    print("Failed to connect: $e");
  }
}

  @override
  void initState() {
    super.initState();
    this._loadData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Info Keuangan'),
        backgroundColor: Colors.red[700],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text("Calvin"),
              accountEmail: Text("Calvinzend@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSR3vIo4u5_ZVQc-aDNSL8WyyJ7Q243nVuDlA&s",
                ),
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    "https://img.lazcdn.com/g/p/08daa7ba1686e4f19286af6a79d64846.jpg_720x720q80.jpg",
                  ),
                  fit: BoxFit.cover
                ),
              ),
            ),

            InkWell(
              onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InfoKeuanganPage()),
              );

                print("Info Keuangan clicked");
              },
              child: ListTile(
                title: Text("Info Keuangan"),
                trailing: Icon(Icons.money),
              ),
            ),
             InkWell(
              onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InputKeuanganPage()),
                  );

                  if (result == true) {
                    _loadData(); // Refresh data setelah input berhasil
                  }
                },
              child: ListTile(
                title: Text("Input Keuangan"),
                trailing: Icon(Icons.input),
              ),
            ),

            InkWell(
              onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DetailKeuanganPage()),
              );
                print("Detail Keuangan clicked");
              },
              child: ListTile(
                title: Text("Detail Keuangan"),
                trailing: Icon(Icons.info),
              ),
            ),
             InkWell(
              onTap: () {
                Navigator.pop(context);  // Menutup drawer
              },
              child: ListTile(
                title: Text("Close"),
                trailing: Icon(Icons.close),
              ),
            ),
          ],
        ),
      ),

      body: ListView.builder(
        itemCount: dataJSON == null ? 0 : dataJSON.length,
        itemBuilder: (context, index) {
          Color textColor = dataJSON[index]["type"] == "income" ? Colors.blue : Colors.red;
          return Container(
            padding: EdgeInsets.all(5.0),
            child: Card(
              color: textColor,
              child: Container(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "${dataJSON[index]["type"]}".toUpperCase(),
                      style: TextStyle(fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Amount      : ${dataJSON[index]["amount"]}",
                      style: TextStyle(fontSize: 10.0, color: Colors.white),
                    ),
                    Text(
                      "Date            : ${dataJSON[index]["date"]}",
                      style: TextStyle(fontSize: 10.0, color: Colors.white),
                    ),
                    Text(
                      "Category    : ${dataJSON[index]["category"]}",
                      style: TextStyle(fontSize: 10.0, color: Colors.white),
                    ),
                    Text(
                      "Description : ${dataJSON[index]["description"]}",
                      style: TextStyle(fontSize: 10.0, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


