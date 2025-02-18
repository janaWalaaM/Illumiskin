import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DiseaseDetailsPage extends StatelessWidget {
  final String diseaseName;

  DiseaseDetailsPage(this.diseaseName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // العودة لصفحة البحث
          },
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        // البحث باستخدام اسم المرض
        future: FirebaseFirestore.instance
            .collection('Skin_Diseases')
            .where('name', isEqualTo: diseaseName)
            .get(),
        builder: (context, snapshot) {
          // الانتظار لحين جلب البيانات
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // التحقق إذا كانت البيانات فارغة
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("لا توجد بيانات متاحة لهذا المرض"));
          }

          // أخذ أول وثيقة تطابق الاسم
          var data = snapshot.data!.docs[0];

          return SingleChildScrollView(
            child: Column(
              children: [
                // عرض الصورة
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 80),
                  child: Container(
                    width: 219,
                    height: 221,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(data['image_example'] ?? ''),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                // عنوان المرض
                SizedBox(height: 20),
                Center(
                  child: Text(
                    data['name'] ?? 'اسم المرض',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),

                // النص داخل الخلفية الزرقاء
                Container(
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  decoration: BoxDecoration(
                    color: Color(0xFF556C8D),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        offset: Offset(0, 4),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        data['description'] ?? '',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.white,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'الأسباب: ',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        data['causes'] ?? '',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.white,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'الأعراض: ',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        data['symptoms'] ?? '',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.white,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'نصائح للوقاية منها: ',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        data['tips_for_prevention'] ?? '',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.white,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'مدى الخطورة: ',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        data['severity'] ?? '',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.white,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
