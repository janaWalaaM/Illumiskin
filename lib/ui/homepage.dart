import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project1/ui/ImagePreviewScreen.dart';
import 'package:project1/ui/aboutillumiskin.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Search.dart';
import 'history.dart';
import 'profile.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  _HomepageState createState() => _HomepageState();
}

late Future<String> _name;

class _HomepageState extends State<Homepage> {
  bool showButtons = false;
  String randomPhrase = "جارٍ تحميل العبارة..."; // عبارة افتراضية أثناء التحميل
  File? image;

  late ImagePicker imagePicker;

  Future<void> getRandomPhrase() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("IllumiSkin_Phrases")
          .get();

      List<String> phrases =
          querySnapshot.docs.map((doc) => doc['Phrases'] as String).toList();

      if (phrases.isNotEmpty) {
        randomPhrase = phrases[Random().nextInt(phrases.length)];
        print("Random phrase: $randomPhrase");
      } else {
        randomPhrase = "لم يتم العثور على عبارات.";
        print("No phrases found in the collection.");
      }
    } catch (e) {
      randomPhrase = "حدث خطأ أثناء جلب العبارة.";
      print("Error fetching documents: $e");
    }

    setState(() {});
  }

  Future<void> chooseImage() async {
    // اختيار الصورة باستخدام مكتبة image_picker
    XFile? selectedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      setState(() {
        image = File(selectedImage.path);
      });

      // التنقل إلى صفحة ImagePreviewScreen وتمرير الصورة
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImagePreviewScreen(image: image!),
        ),
      );
    }
  }

  Future<void> captureImage() async {
    // اختيار الصورة باستخدام مكتبة image_picker
    XFile? selectedImage =
        await imagePicker.pickImage(source: ImageSource.camera);
    if (selectedImage != null) {
      setState(() {
        image = File(selectedImage.path);
      });

      // التنقل إلى صفحة ImagePreviewScreen وتمرير الصورة
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImagePreviewScreen(image: image!),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getRandomPhrase();
    imagePicker = ImagePicker();
    // استدعاء الدالة عند بدء الحالة
  }

  Stream<String> getUserNameStream() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots()
          .map((snapshot) => snapshot.data()?['name'] ?? 'مستخدم');
    }
    return Stream.value('مستخدم');
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false, // إزالة زر العودة
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline,
                color: Color(0xff2F4156), size: 30), // اختر أي أيقونة ترغب بها
            onPressed: () {
              // الانتقال إلى صفحة aboutillumiskin عند الضغط على الزر
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AboutIllumiSkin()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        // Wrap with SingleChildScrollView for scrolling
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 110,
                child: Image.asset(
                    'assests/illumiskin LOGO- TEAL Without FREAM.png'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Illumiskin',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Greeting Section
              const SizedBox(height: 20),
              Padding(
                padding:
                    const EdgeInsets.only(right: 18.0), // Padding to the left
                child: Align(
                  alignment: Alignment
                      .centerRight, // Ensures the text aligns to the left within the padded space
                  child: StreamBuilder<String>(
                    stream: getUserNameStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Text('خطأ في استرجاع الاسم');
                      } else {
                        return Text(
                          'مرحبا ${snapshot.data}       ', // عرض اسم المستخدم
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(
                  height: 20), // Space between the image and the square
              Container(
                height: 150,
                width: 325,
                decoration: BoxDecoration(
                  color: const Color(
                      0xff567C8D), // Set background color for the square
                  borderRadius: BorderRadius.circular(17), // Rounded corners
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
                  padding: const EdgeInsets.all(
                      16.0), // Add padding inside the square
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: Image.asset('assests/allergy(3).png'),
                      ),
                      const SizedBox(
                          width: 16), // Space between the image and text
                      const Expanded(
                        child: Text(
                          '"راحة بالك تبدأ هنا مع تشخيص دقيق مدعوم بالذكاء الاصطناعي."',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 200,
                width: 325,
                decoration: BoxDecoration(
                  color: const Color(
                      0xffC8D9E6), // Set background color for the square
                  borderRadius: BorderRadius.circular(17), // Rounded corners
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
                  padding: const EdgeInsets.all(
                      16.0), // Add padding inside the square
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                          width: 16), // Space between the image and text
                      Expanded(
                        child: Text(
                          randomPhrase, // عرض العبارة العشوائية
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xff567C8D),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                  height: 20), // Space between the square and the text
              const Padding(
                padding: EdgeInsets.only(right: 18.0), // Padding to the left
                child: Align(
                  alignment: Alignment
                      .centerRight, // Ensures the text aligns to the left within the padded space
                  child: Text(
                    'تواصل معنا',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SocialIcon(
                    icon: Icons.facebook,
                    url: 'https://www.facebook.com',
                  ),
                  SocialIcon(
                    icon: FontAwesomeIcons.instagram,
                    url: 'https://www.instagram.come',
                  ),
                  SocialIcon(
                    icon: Icons.email_outlined,
                    url: 'mailto:yourmail@example.com', // Opens email app
                  ),
                  SocialIcon(
                    icon: FontAwesomeIcons.xTwitter,
                    url: 'https://twitter.com',
                  ),
                ],
              ),

              const SizedBox(
                  height: 20), // Space between the square and the text
              const Padding(
                padding: EdgeInsets.only(right: 18.0), // Padding to the left
                child: Align(
                  alignment: Alignment
                      .centerRight, // Ensures the text aligns to the left within the padded space
                  child: Text(
                    'اعضاء الفريق',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 2,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    TeamMemberCard(name: 'جنى ولاء'),
                    TeamMemberCard(name: 'افنان دحلان'),
                    TeamMemberCard(name: 'داليا زمزمي'),
                    TeamMemberCard(name: 'سوزان إمام'),
                  ],
                ),
              ),
              const SizedBox(
                  height: 20), // Space after the second set of squares
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 66,
        width: 270,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.account_circle_outlined,
                    color: Color(0xff2F4156), size: 30),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfilePage()),
                  );
                },
              ),
              const SizedBox(width: 40),
              IconButton(
                icon: const Icon(Icons.search,
                    color: Color(0xff2F4156), size: 30),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SearchScreen()),
                  );
                },
              ),
              const SizedBox(width: 40),
              IconButton(
                icon: const Icon(Icons.camera_alt_outlined,
                    color: Color(0xff2F4156), size: 30),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (BuildContext context) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // زر التقاط صورة بالكاميرا
                            ListTile(
                              leading: const Icon(Icons.camera_alt,
                                  color: Color(0xff2F4156)),
                              title: const Text('التقاط صورة بالكاميرا'),
                              onTap: () async {
                                Navigator.pop(context);
                                captureImage(); // استدعاء طريقة التقاط الصورة
                              },
                            ),
                            // زر اختيار صورة من معرض الصور
                            ListTile(
                              leading: const Icon(Icons.photo_library,
                                  color: Color(0xff2F4156)),
                              title: const Text('اختيار صورة من المعرض'),
                              onTap: () async {
                                chooseImage(); // استدعاء طريقة اختيار الصورة
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(width: 40),
              IconButton(
                icon: const Icon(Icons.access_time_filled_outlined,
                    color: Color(0xff2F4156), size: 30),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HistoryScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SocialIcon extends StatelessWidget {
  final IconData icon;
  final String url;

  const SocialIcon({
    super.key,
    required this.icon,
    required this.url,
  });

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _launchURL(url), // Redirects to the provided URL
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Icon(
          icon,
          color: const Color(0xff556C8D), // Icon color
          size: 40.0, // Icon size
        ),
      ),
    );
  }
}

class TeamMemberCard extends StatelessWidget {
  final String name;

  const TeamMemberCard({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 70,
      decoration: BoxDecoration(
        color: const Color(0xff567C8D),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          name,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
