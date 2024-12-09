import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Awesome application title',
      theme: ThemeData(
        // Use colorScheme for defining colors
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Colors.blueAccent, // Primary color
          onPrimary: Colors.white, // Text color on primary
          secondary: Colors.greenAccent, // Secondary color (used for accent)
          onSecondary: Colors.black, // Text color on background
          surface: Colors.grey[100]!, // Surface color (used for cards, sheets, etc.)
          onSurface: Colors.black, // Text color on surface
          error: Colors.red, // Error color
          onError: Colors.white, // Text color on error
        ),
        // Font
        fontFamily: 'Poppins',

        // Updated TextTheme using new Flutter naming
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.black),
          titleLarge: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.blueAccent),
          bodyLarge: TextStyle(fontSize: 16.0, color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 14.0, color: Colors.black45),
          bodySmall: TextStyle(fontSize: 12.0, color: Colors.grey),
        ),

        // Input Decoration Theme
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.blueAccent),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
          border: OutlineInputBorder(),
        ),

        // ElevatedButton theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            // primary: Colors.greenAccent, // background color
            // onPrimary: Colors.white, // text color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0), // rounded corners
            ),
          ),
        ),

        // AppBar customization
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueAccent,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),

        // Switch customization
        switchTheme: SwitchThemeData(
          trackColor: WidgetStateProperty.all(Colors.blueAccent),
          thumbColor: WidgetStateProperty.all(Colors.greenAccent),
        ),

        // Checkbox customization
        checkboxTheme: CheckboxThemeData(
          checkColor: WidgetStateProperty.all(Colors.white),
          fillColor: WidgetStateProperty.all(Colors.greenAccent),
        ),

        // RadioButton customization
        radioTheme: RadioThemeData(
          fillColor: WidgetStateProperty.all(Colors.greenAccent),
        ),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isNotificationsEnabled = false;
  bool _isSubscribed = false;
  int _subscriptionPlan = 0;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late SharedPreferences _prefs;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = _prefs.getBool('isLoggedIn') ?? false;
    });
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      _savePreferences();
      setState(() {
        _isLoggedIn = _prefs.getBool('isLoggedIn') ?? false;
      });
    }
  }

  _savePreferences() async {
    await _prefs.setBool('isLoggedIn', true);
  }

  Future<String> _fetchData() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/3'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['title'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  String? _selectedCategory = 'Zaki';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Awesome app'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 2. SwitchListTile & Switch
            SwitchListTile(
              title: const Text('Enable Notifications'),
              value: _isNotificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _isNotificationsEnabled = value;
                });
              },
            ),

            // 3. RadioListTile & Radio
            RadioListTile<int>(
              title: const Text('Free Plan'),
              value: 0,
              groupValue: _subscriptionPlan,
              onChanged: (value) {
                setState(() {
                  _subscriptionPlan = value!;
                });
              },
            ),
            RadioListTile<int>(
              title: const Text('Paid Plan'),
              value: 1,
              groupValue: _subscriptionPlan,
              onChanged: (value) {
                setState(() {
                  _subscriptionPlan = value!;
                });
              },
            ),

            // 4. CheckboxListTile & Checkbox
            CheckboxListTile(
              title: const Text('Accept Terms & Conditions'),
              value: _isSubscribed,
              onChanged: (value) {
                setState(() {
                  _isSubscribed = value!;
                });
              },
            ),

            // 6-9. TextField part 1, 2, 3
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
              onSaved: (value) {
                print("Saved Name");
              },
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                } else if (!RegExp(r'^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z0-9]+').hasMatch(value)) {
                  return 'Invalid email format';
                }
                return null;
              },
            ),

            // Submit Button
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Submit'),
            ),

            // HTTP API Fetch Button
            ElevatedButton(
              onPressed: () {
                setState(() {});
              },
              child: Text('Fetch Data from API'),
            ),

            // FutureBuilder to show data fetched from API
            FutureBuilder<String>(
              future: _fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return Text(snapshot.data ?? 'No data');
                } else {
                  return const Text('No Data');
                }
              },
            ),

            // Dropdown Button for categories
            DropdownButton<String>(
              value: _selectedCategory,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
              },
              items: <String>['Zaki', 'Atallah', 'Omar']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),

            // SharedPreferences status display
            Text(_isLoggedIn ? 'User is logged in' : 'User is not logged in'),

            // Stack Example
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 150,
                  height: 300,
                  color: Colors.orange[200],
                  child: Center(child: Text('Foreground')),
                ),
                Container(
                  width: 200,
                  height: 200,
                  color: Colors.blue[100],
                  child: Center(child: Text('Background')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
