import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback onSignIn;

  RegisterScreen({required this.onSignIn});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String? _email;
  String? _password;
  String? _confirmPassword;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) =>
                value == null || !value.contains('@') ? 'Please enter a valid email' : null,
                onSaved: (value) => _email = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) => value == null || value.length < 6 ? 'Password must be at least 6 characters' : null,
                onSaved: (value) => _password = value,
              ),
              TextFormField(decoration: InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                validator: (value) =>
                value == null || value != _password ? 'Passwords do not match' : null,
                onSaved: (value) => _confirmPassword = value,
              ),
              SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      setState(() {
                        _isLoading = true;
                      });
                      try {
                        await _auth.signUpWithEmailAndPassword(_email!, _password!);
                        widget.onSignIn();
                      } catch (e) {
                        print(e.toString());
                      }
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  },
                  child: Text('Register'),
                ),
              ),
              SizedBox(height: 16.0),
              Center(
                child: TextButton(
                  onPressed: widget.onSignIn,
                  child: Text('Already have an account? Sign in'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}