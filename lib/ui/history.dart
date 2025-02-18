import 'dart:convert'; // استيراد مكتبة base64Decode
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'DiagnosisDetailsPage.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> history = [];
  bool isAscending = true; // متغير لتحديد ترتيب البيانات

  // دالة لاسترجاع بيانات السجل من Firestore
  Future<void> getHistory() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("❌ لا يوجد مستخدم مسجل دخول.");
      return;
    }

    final String userId = user.uid;

    try {
      // استرجاع البيانات من Firestore بناءً على المستخدم بدون ترتيب
      final snapshot = await FirebaseFirestore.instance
          .collection('Skin_Diagnosis')
          .where('user_id', isEqualTo: userId)
          .get();

      final List<Map<String, dynamic>> fetchedHistory = [];
      for (var doc in snapshot.docs) {
        fetchedHistory.add({
          'id': doc.id, // إضافة معرّف السجل
          'time': doc['diagnosis_date'], // استرجاع التاريخ
          'image': doc['image_base64'], // استرجاع البيانات Base64 للصورة
        });
      }

      setState(() {
        history = fetchedHistory; // تحديث البيانات في الواجهة
      });
    } catch (e) {
      print("❌ حدث خطأ أثناء استرجاع السجل: $e");
    }
  }

  // دالة لحذف عنصر معين من Firestore
  Future<void> deleteItemFromFirestore(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Skin_Diagnosis')
          .doc(documentId) // استخدام معرّف السجل
          .delete(); // حذف السجل من Firestore
    } catch (e) {
      print("❌ حدث خطأ أثناء حذف السجل: $e");
    }
  }

  // دالة لحذف عنصر معين من قاعدة البيانات ومن الواجهة باستخدام موقعه (index)
  void deleteItem(int index) async {
    final item = history[index];

    // حذف السجل من Firestore
    await deleteItemFromFirestore(item['id']);

    // إزالة العنصر من الواجهة المحلية بعد الحذف من قاعدة البيانات
    setState(() {
      history.removeAt(index); // إزالة العنصر من الواجهة
    });
  }

  // دالة لفلترة البيانات حسب التاريخ
  void toggleSortOrder() {
    setState(() {
      isAscending = !isAscending; // التبديل بين الترتيب التصاعدي والتنازلي
    });

    // إعادة ترتيب البيانات في الذاكرة بناءً على التاريخ والوقت
    setState(() {
      history.sort((a, b) {
        final dateA = DateTime.parse(a['time']);
        final dateB = DateTime.parse(b['time']);
        return isAscending
            ? dateA.compareTo(dateB) // ترتيب تصاعدي
            : dateB.compareTo(dateA); // ترتيب تنازلي
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getHistory(); // استرجاع البيانات عند تحميل الواجهة
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          title: const Text(
            "السجل",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        body: Container(
          color: Colors.white, // خلفية بيضاء
          child: Column(
            children: [
              // إضافة اللوجو هنا
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset('assests/LOGO-TEAL.png', height: 130),
              ),
              // إضافة أيقونات تحت اللوجو في بوكس صغير
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  color: Colors.transparent, // خلفية شفافة
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // أيقونة الحذف
                      Container(
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: const Color(0xFFC8D9E6), // لون خلفية الأيقونة
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.black54),
                          onPressed: deleteAll, // حذف جميع العناصر
                        ),
                      ),
                      const SizedBox(width: 5), // إضافة مسافة بين الأيقونات
                      // أيقونة الفلتر
                      Container(
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: const Color(0xFFC8D9E6), // لون خلفية الأيقونة
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.filter_list,
                              color: Colors.black54),
                          onPressed: toggleSortOrder, // تغيير ترتيب الفلتر
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // إذا كانت القائمة فارغة
              history.isEmpty
                  ? const Expanded(
                      child: Center(
                        // استخدام Center هنا لتوسيط النص
                        child: Text(
                          'لا يوجد عناصر في السجل',
                          style: TextStyle(color: Colors.grey, fontSize: 18),
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: history.length,
                        itemBuilder: (context, index) {
                          final item = history[index];
                          // تحويل Base64 إلى صورة
                          final imageBytes = base64Decode(item['image']);

                          return Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 16),
                            color: const Color(0xFF556C8D),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 16),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: MemoryImage(imageBytes),
                                  radius: 30, // تكبير الصورة
                                ),
                                subtitle: Text(
                                  item['time'], // عرض التاريخ فقط
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 18,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.close,
                                      color: Colors.grey),
                                  onPressed: () => deleteItem(index),
                                ),
                                onTap: () {
                                  // الانتقال إلى صفحة DiagnosisDetailsPage عند الضغط على السجل
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DiagnosisDetailsPage(
                                        diagnosisId: item['id'], // تمرير المعرف
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
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

  // دالة لحذف جميع العناصر من القائمة
  void deleteAll() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("❌ لا يوجد مستخدم مسجل دخول.");
      return;
    }
    final String userId = user.uid;

    try {
      // حذف كل السجلات من Firestore للمستخدم
      final snapshot = await FirebaseFirestore.instance
          .collection('Skin_Diagnosis')
          .where('user_id', isEqualTo: userId)
          .get();

      for (var doc in snapshot.docs) {
        await FirebaseFirestore.instance
            .collection('Skin_Diagnosis')
            .doc(doc.id)
            .delete();
      }

      setState(() {
        history.clear(); // مسح البيانات من الواجهة بعد الحذف
      });
    } catch (e) {
      print("❌ حدث خطأ أثناء حذف السجلات: $e");
    }
  }
}
