import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _nameController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _email = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();

      setState(() {
        _nameController.text = userDoc['name'] ?? '';
        _email = user.email ?? '';
      });
    }
  }

  Future<void> _updateUserData() async {
    String newName = _nameController.text.trim();

    try {
      User? user = _auth.currentUser;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'name': newName,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم تحديث البيانات بنجاح!')),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ: ${e.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment:
            CrossAxisAlignment.center, // Centers content horizontally
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 16.0), // Top padding for spacing
            child: Align(
              alignment: Alignment.topCenter, // Centers the text horizontally
              child: Text(
                "تعديل الصفحة الشخصية",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.blueGrey,
            child: const Icon(
              Icons.person,
              size: 50,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 70), // Space between image and text fields

          // Full Name Input Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'الاسم الكامل',
                labelStyle: TextStyle(color: Colors.grey, fontSize: 16),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff567C8D), width: 1.5),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff567C8D), width: 2),
                ),
                suffixIcon: Icon(Icons.edit, color: Color(0xff567C8D)),
              ),
              cursorColor: Color(0xff567C8D),
            ),
          ),
          SizedBox(height: 30), // Space between fields

          // Email
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.stretch, // Align email to the left
              children: [
                Text(
                  'البريد الالكتروني',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                SizedBox(height: 8),
                Align(
                  alignment:
                      Alignment.centerLeft, // Align email text to the left
                  child: Text(
                    _email,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 110), // Space between the password and other widgets

          // Button with Image
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ElevatedButton(
              onPressed: _updateUserData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffF5EFEB),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              child: Text(
                'حفظ التغييرات',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
