import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isReauthenticated = false; // للتحقق من نجاح عملية التحقق

  // Method to handle password reset
  Future<void> resetPassword() async {
    try {
      String newPassword = _newPasswordController.text;
      String confirmPassword = _confirmPasswordController.text;

      if (!isReauthenticated) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('يرجى التحقق من الهوية أولاً')),
        );
        return;
      }

      // Check if the passwords match
      if (newPassword == confirmPassword) {
        User? user = _auth.currentUser;
        if (user != null) {
          await user.updatePassword(newPassword);
          await user.reload();
          user = _auth.currentUser;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('تم إعادة تعيين كلمة المرور بنجاح')),
          );
          // Reset the reauthentication state
          isReauthenticated = false;
        }
      } else {
        // Handle case where passwords do not match
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('كلمة المرور غير متطابقة')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل في إعادة تعيين كلمة المرور')),
      );
    }
  }

  // Method to reauthenticate the user
  Future<void> reauthenticateUser() async {
    try {
      User? user = _auth.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('لم يتم العثور على مستخدم حالي')),
        );
        return;
      }

      // Get the current password from the dialog
      String currentPassword = _currentPasswordController.text.trim();

      if (currentPassword.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('يجب إدخال كلمة المرور الحالية')),
        );
        return;
      }

      // Reauthenticate with the current password
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم التحقق من الهوية بنجاح')),
      );
      setState(() {
        isReauthenticated = true; // Set the reauthentication flag to true
      });
    } catch (e) {
      print('Reauthentication Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل في التحقق من الهوية: $e')),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    "تغيير كلمة المرور",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: const Icon(Icons.lock_reset,
                    size: 100, color: Colors.blueGrey),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  _showReauthenticationDialog(); // Show the reauthentication dialog
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  textStyle:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                child: Text(
                  'يجب ادخال كلمة المرور الحالية للتحقق من الهوية',
                  style: TextStyle(
                    color: Color(0xFF1A73E8), // لون الرابط (مثلاً اللون الأزرق)
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration
                        .underline, // إضافة خط تحت النص لجعل الرابط واضحًا
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'كلمة المرور الجديدة',
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xff567C8D), width: 1.5),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff567C8D), width: 2),
                  ),
                ),
                cursorColor: Color(0xff567C8D),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'تأكيد كلمة المرور',
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xff567C8D), width: 1.5),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff567C8D), width: 2),
                  ),
                ),
                cursorColor: Color(0xff567C8D),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  resetPassword(); // Trigger the reset password function
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffF5EFEB),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  textStyle:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                child: Text(
                  'إعادة تعيين',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Show dialog for reauthentication
  void _showReauthenticationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('التحقق من الهوية'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'يرجى إدخال كلمة المرور الحالية لتأكيد هويتك',
              ),
              TextField(
                controller: _currentPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'كلمة المرور الحالية'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                reauthenticateUser(); // Trigger the reauthentication
              },
              child: Text('تأكيد'),
            ),
          ],
        );
      },
    );
  }
}
