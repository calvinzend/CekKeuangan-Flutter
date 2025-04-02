import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';


class InputKeuanganPage extends StatefulWidget {
  const InputKeuanganPage({super.key});

  @override
  State<InputKeuanganPage> createState() => _InputKeuanganPageState();
}

class _InputKeuanganPageState extends State<InputKeuanganPage> {
   final _formKey = GlobalKey<FormState>();

  // Controller untuk TextField
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _transactionType = 'income'; // Default to 'income'


  Future<void> _submitData() async {
    if (_formKey.currentState?.validate() ?? false) {
      final String amount = _amountController.text;
      final String category = _categoryController.text;
      final String description = _descriptionController.text;
      final String transactionType = _transactionType;

      // Data yang akan dikirim ke API
      final Map<String, String> data = {
        'type': transactionType,
        'amount': amount,
        'category': category,
        'description': description,
      };

      try {
        // Kirim data menggunakan POST request
        final response = await http.post(
          Uri.parse("http://192.168.56.1:3000/transactions"),
          headers: {"Content-Type": "application/json"},
          body: json.encode(data),
        );

        // Tangani response dari API
        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data Keuangan Tersimpan!')),
          );

          _amountController.clear();
          _categoryController.clear();
          _descriptionController.clear();
          
          Navigator.pop(context, true); 
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menyimpan data. Coba lagi.')),
          );
        }
      } catch (e) {
        // Menangani kesalahan koneksi atau lainnya
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan. Coba lagi.')),
        );
        print("Error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Input Keuangan'),
        backgroundColor: Colors.red[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Transaction Type:'),
                  Radio<String>(
                    value: 'income',
                    groupValue: _transactionType,
                    onChanged: (String? value) {
                      setState(() {
                        _transactionType = value!;
                      });
                    },
                  ),
                  Text('Income'),
                  Radio<String>(
                    value: 'expense',
                    groupValue: _transactionType,
                    onChanged: (String? value) {
                      setState(() {
                        _transactionType = value!;
                      });
                    },
                  ),
                  Text('Expense'),
                ],
              ),
              SizedBox(height: 20),
              
              // Tombol Simpan
              ElevatedButton(
                onPressed: _submitData,
                child: Text('Save Finance', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
