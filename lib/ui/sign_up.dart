import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'homepage.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user; // Returns the registered user
    } catch (e) {
      rethrow; // Re-throws the error to be handled in the UI
    }
  }
}

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupPage> {
  final _auth = AuthService();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _registerUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final user = await _auth.registerWithEmailAndPassword(
          _email.text.trim(),
          _password.text.trim(),
        );
        if (user != null) {
          // حفظ بيانات المستخدم في Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid) // حفظ الـ UID في قاعدة البيانات
              .set({
            'uid': user.uid, // حفظ الـ UID
            'name': _name.text.trim(),
            'email': _email.text.trim(),
          });
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Homepage()),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'تم إدخال بريد غير صحيح او قد هذا البريد مستخدم بالفعل')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assests/LOGO-TEAL.png",
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 40),
                _buildFormContainer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormContainer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildField("(بالعربي) الاسم الكامل", "أدخل اسمك الكامل", _name),
          const SizedBox(height: 15),
          _buildField("البريد الإلكتروني", "أدخل بريدك الإلكتروني", _email,
              keyboardType: TextInputType.emailAddress),
          const SizedBox(height: 15),
          _buildField("كلمة المرور", "أدخل كلمة المرور", _password,
              obscureText: true),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: _registerUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0XFFC8D9E6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              child: const Text(
                "إنشاء حساب",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Text.rich(
                TextSpan(
                  text: "هل لديك حساب بالفعل؟ ",
                  children: [
                    TextSpan(
                      text: "تسجيل الدخول",
                      style: TextStyle(
                        color: Color(0xFF567C8D),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(
      String label, String hint, TextEditingController controller,
      {bool obscureText = false,
      TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.right,
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textDirection: TextDirection.rtl,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFF5EFEB),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "هذا الحقل مطلوب";
            }
            if (label == "البريد الإلكتروني" &&
                !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
              return "أدخل بريد إلكتروني صحيح";
            }
            return null;
          },
        ),
      ],
    );
  }
}
