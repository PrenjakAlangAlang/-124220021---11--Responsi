import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:responsi/login_screen.dart';

class HomeScreen extends StatelessWidget {
  final String username;

  HomeScreen({required this.username});
  Future<List<dynamic>> fetchCrates() async {
    final response = await http.get(
        Uri.parse('https://bymykel.github.io/CSGO-API/api/en/crates.json'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load crates');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 193, 166, 240),
        title: Text('Welcome, $username'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              // Handle the selected value (e.g., log out)
              if (value == 'Log Out') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'Log Out',
                child: Text('Log Out'),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchCrates(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final crates = snapshot.data!;
            return Column(
              children: [
                Text(
                  'Daftar Crates',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: crates.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(crates[index]['name']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 15),
                              Text('${crates[index]['id']}'),
                              Text('${crates[index]['first_sale_date']}'),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CrateDetailPage(crate: crates[index]),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class CrateDetailPage extends StatelessWidget {
  final dynamic crate;

  CrateDetailPage({required this.crate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 193, 166, 240),
          title: Text(crate['name'])),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Add this line
          children: [
            Image.network(crate['image']),
            SizedBox(height: 16),
            Text(
              '${crate['market_hash_name']}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            Text(
              '${crate['first_sale_date']}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '${crate['description']}',
              style: TextStyle(fontSize: 20),
            ),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}
