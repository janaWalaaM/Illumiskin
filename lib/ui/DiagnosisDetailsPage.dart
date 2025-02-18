import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DiagnosisDetailsPage extends StatefulWidget {
  final String diagnosisId;

  const DiagnosisDetailsPage({required this.diagnosisId, Key? key})
      : super(key: key);

  @override
  _DiagnosisDetailsPageState createState() => _DiagnosisDetailsPageState();
}

class _DiagnosisDetailsPageState extends State<DiagnosisDetailsPage> {
  bool _isLoading = true;
  Map<String, dynamic>? _diagnosisData;

  @override
  void initState() {
    super.initState();
    _fetchDiagnosisData();
  }

  Future<void> _fetchDiagnosisData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("❌ لا يوجد مستخدم مسجل دخول.");
      return;
    }

    try {
      // جلب البيانات من قاعدة البيانات بناءً على diagnosisId
      final snapshot = await FirebaseFirestore.instance
          .collection('Skin_Diagnosis')
          .doc(widget.diagnosisId)
          .get();

      if (!snapshot.exists) {
        print("❌ التشخيص غير موجود.");
        return;
      }

      setState(() {
        _diagnosisData = snapshot.data()!;
        _isLoading = false;
      });
    } catch (e) {
      print("❌ حدث خطأ أثناء جلب البيانات: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "تفاصيل التشخيص",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _diagnosisData == null
                ? Center(child: Text("❌ لا توجد بيانات للتشخيص"))
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        // عرض صورة المريض بشكل أكبر
                        ClipOval(
                          child: Image.memory(
                            base64Decode(_diagnosisData!['image_base64']),
                            height: 250, // تكبير الصورة
                            width: 250,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // عرض الأمراض كما هي في قاعدة البيانات (بدون ترتيب)
                        ..._buildDiagnosisResults(),
                      ],
                    ),
                  ),
      ),
    );
  }

  List<Widget> _buildDiagnosisResults() {
    // استخدام النتائج كما هي في قاعدة البيانات بدون ترتيب
    List<Map<String, dynamic>> results = List.from(
      _diagnosisData!['results'] as List,
    );

    // تحويل كل نتيجة إلى Widget
    return results.map<Widget>((result) {
      final diseaseName = result['disease_name'];
      final confidence = double.parse(result['confidence'].replaceAll('%', ''));

      return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xffF5EFEB),
          borderRadius: BorderRadius.circular(17),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // محاذاة في الوسط
          children: [
            // عرض اسم المرض
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  diseaseName,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Color(0xff556C8D),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                // عرض النسبة في وسط دائرة النسبة
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: confidence / 100,
                      color: Color(0xff556C8D),
                      strokeWidth: 4,
                    ),
                    Text(
                      "${(confidence).toStringAsFixed(1)}%", // عرض النسبة بشكل صحيح
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    }).toList();
  }
}
