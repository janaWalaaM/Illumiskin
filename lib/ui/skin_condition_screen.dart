import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart'; // <-- تأكد من إضافة حزمة cloud_firestore في pubspec.yaml
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // لتنسيق التاريخ
import 'package:shimmer/shimmer.dart';

import 'disease_details_page.dart';

class SkinConditionScreen extends StatefulWidget {
  final File image; // صورة المرض

  const SkinConditionScreen({required this.image, Key? key}) : super(key: key);

  @override
  _SkinConditionScreenState createState() => _SkinConditionScreenState();
}

class _SkinConditionScreenState extends State<SkinConditionScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>>? _predictions;

  @override
  void initState() {
    super.initState();
    _analyzeImage();
  }

  Future<void> _analyzeImage() async {
    final url = Uri.parse('http://10.0.2.2:5001/predict'); // رابط خادم Python
    try {
      final request = http.MultipartRequest('POST', url);
      request.files.add(
        await http.MultipartFile.fromPath('image', widget.image.path),
      );
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final jsonResponse = jsonDecode(responseData);

        setState(() {
          _predictions =
              List<Map<String, dynamic>>.from(jsonResponse['predictions']);
          _isLoading = false;
        });

        // حفظ البيانات في Firestore بعد التحليل
        await _saveDiagnosisToFirestore();
      } else {
        setState(() {
          _predictions = null;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _predictions = null;
        _isLoading = false;
      });
    }
  }

  Future<void> _saveDiagnosisToFirestore() async {
    if (_predictions == null || _predictions!.isEmpty) return;

    // 🔹 الحصول على المستخدم المسجّل دخول
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("❌ لا يوجد مستخدم مسجل دخول.");
      return;
    }

    final String userId = user.uid;

    try {
      // تحويل الصورة إلى Base64
      final byteData = await widget.image.readAsBytes();
      final base64Image = base64Encode(byteData); // تحويل الصورة إلى Base64

      // التحقق مما إذا كان `userId` موجودًا في قاعدة البيانات
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (!userSnapshot.exists) {
        print("❌ المستخدم غير موجود في قاعدة البيانات.");
        return;
      }

      // تجهيز البيانات لحفظها
      final diagnosisData = {
        "user_id": userId,
        "diagnosis_date": DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
        "image_base64": base64Image, // حفظ الصورة بتنسيق Base64
        "results": _predictions!.map((prediction) {
          return {
            "disease_name": _translateLabel(prediction['label']),
            "confidence":
                "${(prediction['confidence'] * 100).toStringAsFixed(1)}%", // نسبة الثقة كنص
          };
        }).toList(),
      };

      // حفظ البيانات في Firestore
      await FirebaseFirestore.instance
          .collection('Skin_Diagnosis')
          .add(diagnosisData);

      print("✅ تم حفظ التشخيص بنجاح في Firestore");
    } catch (e) {
      print("❌ حدث خطأ أثناء حفظ الصورة: $e");
    }
  }

  /// مؤشر دائري للنسبة
  Widget _buildCircularProgress(double confidence) {
    return SizedBox(
      height: 80,
      width: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: confidence,
            strokeWidth: 8,
            color: const Color(0xff556C8D),
            backgroundColor: Colors.grey.shade300,
          ),
          Text(
            "${(confidence * 100).toStringAsFixed(1)}%",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// تأثير التحميل (Shimmer)
  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: List.generate(5, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              height: 80,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }),
      ),
    );
  }

  /// ترجمة أسماء الأمراض إلى العربية
  String _translateLabel(String label) {
    const translations = {
      "Acne": "حب الشباب",
      "Benign Tumors": "الأورام الحميدة",
      "Eczema": "الأكزيما",
      "Fungal Infections": "العدوى الفطرية",
      "Malignant Lesions": "الآفات الخبيثة",
      "Nail Fungus": "فطريات الأظافر",
      "Psoriasis": "الصدفية",
      "Viral Infections": "العدوى الفيروسية",
    };
    return translations[label] ?? label;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "تشخيص الأمراض الجلدية",
          style: TextStyle(color: Color(0xff556C8D)),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xff556C8D)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // شعار في الأعلى
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assests/illumiskin LOGO- TEAL Without FREAM.png',
                  height: 100,
                ),
              ),
              if (_isLoading)
                _buildShimmerEffect()
              else
                _predictions == null
                    ? const Center(
                        child: Text(
                          "حدث خطأ أثناء التحليل.",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          const SizedBox(height: 20),
                          ..._predictions!.map((prediction) {
                            // استخرج اسم المرض بالعربية
                            final diseaseName =
                                _translateLabel(prediction['label']);
                            final confidence =
                                prediction['confidence'] as double;

                            return Center(
                              child: InkWell(
                                onTap: () {
                                  // الذهاب لصفحة التفاصيل
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DiseaseDetailsPage(diseaseName),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 340,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
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
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // صورة المرض من Firestore بناءً على الاسم
                                        FutureBuilder<QuerySnapshot>(
                                          future: FirebaseFirestore.instance
                                              .collection('Skin_Diseases')
                                              .where('name',
                                                  isEqualTo: diseaseName)
                                              .get(),
                                          builder: (context, snapshot) {
                                            // في حالة التحميل
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return ClipOval(
                                                child: SizedBox(
                                                  height: 80,
                                                  width: 80,
                                                  child: Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                ),
                                              );
                                            }

                                            // إذا لم نجد أي بيانات في الفايربيس
                                            if (!snapshot.hasData ||
                                                snapshot.data!.docs.isEmpty) {
                                              // صورة افتراضية
                                              return ClipOval(
                                                child: Image.asset(
                                                  'assests/Screenshot 2024-12-18 101704.png',
                                                  height: 80,
                                                  width: 80,
                                                  fit: BoxFit.cover,
                                                ),
                                              );
                                            }

                                            // إذا وجدنا وثيقة تحتوي imageUrl
                                            final doc =
                                                snapshot.data!.docs.first;
                                            final String imageUrl =
                                                doc['image_example'] ?? '';

                                            return ClipOval(
                                              child: Image.network(
                                                imageUrl,
                                                height: 80,
                                                width: 80,
                                                fit: BoxFit.cover,
                                              ),
                                            );
                                          },
                                        ),

                                        // النص + الدائرة
                                        Row(
                                          children: [
                                            const SizedBox(width: 8),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
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
                                                _buildCircularProgress(
                                                    confidence),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
            ],
          ),
        ),
      ),
    );
  }
}
