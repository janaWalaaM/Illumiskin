import 'package:flutter/material.dart';

import 'constants.dart';
import 'log_in.dart';
import 'sign_up.dart';

class Onboardingsecreen extends StatefulWidget {
  const Onboardingsecreen({Key? key}) : super(key: key);

  @override
  State<Onboardingsecreen> createState() => OnboardingsecreenState();
}

class OnboardingsecreenState extends State<Onboardingsecreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView(
            onPageChanged: (int page) {
              setState(() {
                currentIndex = page;
              });
            },
            controller: _pageController,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 50, right: 50, bottom: 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 146,
                      child: Image.asset(
                          'assests/illumiskin LOGO- TEAL Without FREAM.png'), // Add your image asset path here
                    ),
                    const SizedBox(height: 60),
                    Text(
                      Constants.titleOne,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'تطبيق لتشخيص أمراض الجلد باستخدام الذكاء الاصطناعي. نحن هنا لمساعدتك',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Constants.secondaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                        height:
                            20), // Added space between description and button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignupPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffC8D9E6), // Button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10), // Rounded corners with radius 10
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 20), // Button size
                      ),
                      child: const Text(
                        'انشاء حساب جديد',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Navigate to the login page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      LoginPage()), // Replace with your login page widget
                            );
                          },
                          child: const Text(
                            "تسجيل دخول",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff567C8D),
                            ),
                          ),
                        ),
                        const Text(
                          " لديك حساب مسبقا؟",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
