import 'dart:io'; // للتعامل مع ملفات الجهاز مثل الصور

import 'package:flutter/material.dart'; // لتصميم الواجهة والصفحات
import 'package:project1/ui/skin_condition_screen.dart';

class ImagePreviewScreen extends StatelessWidget {
  final File image;

  ImagePreviewScreen({required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('معاينة الصورة'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // العودة للصفحة السابقة
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white, // جعل لون الخلفية أبيض
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width *
                    0.8, // 80% من عرض الشاشة
                height: MediaQuery.of(context).size.height *
                    0.5, // 50% من ارتفاع الشاشة
                child: Image.file(
                  image,
                  fit: BoxFit.contain, // لجعل الصورة تناسب الحاوية
                  errorBuilder: (context, error, stackTrace) {
                    return Text('تعذر تحميل الصورة.');
                  },
                ),
              ),
              SizedBox(height: 30), // مسافة بين الصورة والزر
              ElevatedButton(
                onPressed: () {
                  // الانتقال إلى صفحة SkinConditionScreen وتمرير الصورة
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SkinConditionScreen(image: image),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFC8D9E6), // لون الخلفية
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // حواف مستديرة
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 12), // حشوة داخل الزر
                ),
                child: const Text(
                  "إرسال الصورة",
                  style: TextStyle(
                    color: Colors.black, // لون النص
                    fontWeight: FontWeight.bold, // النص عريض
                    fontSize: 15.5, // حجم النص
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
