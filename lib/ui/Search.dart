import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'disease_details_page.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _searchResults = [];

  /// دالة البحث في Firestore بحسب حقل 'name'
  void _search(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    // نجلب المستندات التي تبدأ أسماؤها بالنص المدخل (query)
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Skin_Diseases')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: query + '\uf8ff')
        .get();

    setState(() {
      _searchResults = snapshot.docs.map((doc) {
        return {
          'name': doc['name'] as String, // اسم المرض
          'image': doc['image_example'] as String, // رابط الصورة
        };
      }).toList();
    });
  }

  /// دالة للانتقال إلى صفحة تفاصيل المرض باستخدام الاسم
  void _goToDetailsPage(BuildContext context, String diseaseName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DiseaseDetailsPage(diseaseName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // واجهة عربية
      child: Scaffold(
        backgroundColor: Colors.white, // خلفية الصفحة بيضاء
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: const Text(
            "البحث",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // حقل البحث
              TextField(
                controller: _searchController,
                onChanged: (query) {
                  _search(query);
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Colors.black),
                  hintText: 'ابحث عن مرض...',
                  hintStyle: const TextStyle(color: Colors.black54),
                  filled: true,
                  fillColor: const Color(0xFFF5EFEB),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // عرض نتائج البحث
              Expanded(
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final disease = _searchResults[index];
                    final diseaseName = disease['name']!;
                    final diseaseImage = disease['image']!;

                    return GestureDetector(
                      onTap: () {
                        // الانتقال لصفحة تفاصيل المرض باستخدام الاسم
                        _goToDetailsPage(context, diseaseName);
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        color: const Color(0xFF556C8D),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 16,
                          ),
                          child: Row(
                            children: [
                              ClipOval(
                                child: Image.network(
                                  diseaseImage,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                diseaseName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
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
}
