import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class DetailKeuanganPage extends StatefulWidget {
  const DetailKeuanganPage({super.key});

  @override
  State<DetailKeuanganPage> createState() => _DetailKeuanganPageState();
}

class _DetailKeuanganPageState extends State<DetailKeuanganPage> {
  Map<String, dynamic>? dataJSON;
  bool isLoading = true;

  Future<void> _loadData() async {
    try {
      final response = await http.get(
        Uri.parse("http://192.168.56.1:3000/transactions/total"),
        headers: {"Accept": "application/json"},
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        setState(() {
          dataJSON = json.decode(response.body);
          isLoading = false;
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
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Keuangan'),
        backgroundColor: Colors.red[700],
      ),

       body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Detail Keuangan",
              style: TextStyle(
                fontSize: 22,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : dataJSON == null
                    ? Text(
                        'Gagal memuat data.',
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      )
                    : Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              _buildInfoRow("Total Pendapatan", dataJSON!["income"].toString(), Colors.green),
                              Divider(),
                              _buildInfoRow("Total Pengeluaran", dataJSON!["expense"].toString(), Colors.red),
                              Divider(),
                              _buildInfoRow("Total Keuangan", dataJSON!["total"].toString(), Colors.blue),
                            ],
                          ),
                        ),
                      ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _loadData,
              icon: Icon(Icons.refresh, color: Colors.white,),
              label: Text("Refresh Data",style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                backgroundColor: Colors.red[700],
                textStyle: TextStyle(fontSize: 18),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}