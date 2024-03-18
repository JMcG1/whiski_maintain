import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MaintenanceScreen extends StatefulWidget {
  final VoidCallback onSignOut;

  MaintenanceScreen({required this.onSignOut});

  @override
  _MaintenanceScreenState createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  final CollectionReference _maintenanceCollection = FirebaseFirestore.instance.collection('maintenance');

  final _formKey = GlobalKey<FormState>();

  String? _description;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maintenance Issues'),
        actions: [
          TextButton(
            onPressed: widget.onSignOut,
            child: Text('Sign Out'),
          ),
        ],
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
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter a description' : null,
                onSaved: (value) => _description = value,
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
                        await _maintenanceCollection.add({
                          'description': _description,
                          'created_at': Timestamp.now(),
                        });
                        _formKey.currentState!.reset();
                      } catch (e) {
                        print(e.toString());
                      }
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  },
                  child: Text('Add Maintenance Issue'),
                ),
              ),
              SizedBox(height: 16.0),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _maintenanceCollection.orderBy('created_at').snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) return const CircularProgressIndicator();
                    return ListView(
                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                        return ListTile(
                          title: Text(document['description']),
                          subtitle: Text(document['created_at'].toDate().toString()),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}