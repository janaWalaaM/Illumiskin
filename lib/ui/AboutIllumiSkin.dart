import 'package:flutter/material.dart';

class AboutIllumiSkin extends StatelessWidget {
  const AboutIllumiSkin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'IllumiSkin',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl, // اتجاه النص من اليمين لليسار
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment:
                    CrossAxisAlignment.end, // محاذاة كل العناصر إلى اليمين
                children: [
                  Align(
                    alignment: Alignment.center, // محاذاة الصورة إلى اليمين
                    child: SizedBox(
                      height: 110,
                      child: Image.asset(
                          'assests/illumiskin LOGO- TEAL Without FREAM.png'),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Align(
                    alignment:
                        Alignment.centerRight, // محاذاة العنوان إلى اليمين
                    child: Text(
                      'موجز للتطبيق',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff556C8D),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Align(
                    alignment: Alignment.centerRight, // محاذاة النص إلى اليمين
                    child: Text(
                      'IllumiSkin هو تطبيق مبتكر يستخدم تقنيات الرؤية الحاسوبية والتعلم العميق لتشخيص الأمراض الجلدية. يتيح للمستخدمين تحليل صور الجلد واكتشاف الأمراض المحتملة بسهولة ودقة من خلال واجهة سهلة الاستخدام.',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Align(
                    alignment:
                        Alignment.centerRight, // محاذاة العنوان إلى اليمين
                    child: Text(
                      'الغرض والهدف',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff556C8D),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Align(
                    alignment: Alignment.centerRight, // محاذاة النص إلى اليمين
                    child: Text(
                      'الغرض الأساسي من التطبيق هو تمكين الأفراد من الحصول على تشخيص أولي سريع للأمراض الجلدية، مما يسهم في تحسين الوعي الصحي وتقليل الوقت اللازم للوصول إلى العناية الطبية. الهدف هو تعزيز الاكتشاف المبكر للأمراض الجلدية ودعم القطاع الطبي بأداة فعالة وقابلة للاستخدام من الجميع.',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Align(
                    alignment:
                        Alignment.centerRight, // محاذاة العنوان إلى اليمين
                    child: Text(
                      'ميزات التطبيق',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff556C8D),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Align(
                    alignment: Alignment.centerRight, // محاذاة النص إلى اليمين
                    child: Text(
                      'تشخيص الأمراض الجلدية: باستخدام نموذج متقدم علميًا.\n'
                      'إدارة الحسابات الشخصية: تسجيل الدخول وإنشاء حساب وإدارة ملف شخصي.\n'
                      'عرض السجل الطبي: الوصول إلى تاريخ الفحوصات السابقة.\n'
                      'سهولة الاستخدام: واجهة بسيطة مناسبة لجميع الفئات العمرية.',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Align(
                    alignment:
                        Alignment.centerRight, // محاذاة العنوان إلى اليمين
                    child: Text(
                      'الرؤية والرسالة',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff556C8D),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Align(
                    alignment: Alignment.centerRight, // محاذاة النص إلى اليمين
                    child: Text(
                      'الرؤية: أن يصبح تطبيق IllumiSkin منصة رائدة سعودية تدمج بين الذكاء الاصطناعي والرعاية الصحية، لتوفير تشخيص الأمراض الجلدية للأفراد.\n'
                      'الرسالة: تقديم حل تقني مبتكر يدمج بين التكنولوجيا والرعاية الصحية لتمكين الأفراد من تحسين جودة حياتهم وصحتهم الجلدية.',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Align(
                    alignment:
                        Alignment.centerRight, // محاذاة العنوان إلى اليمين
                    child: Text(
                      'مبرمجين التطبيق',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff556C8D),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Align(
                    alignment: Alignment.centerRight, // محاذاة النص إلى اليمين
                    child: Text(
                      'جنى ولاء\nافنان دحلان\nداليا زمزمي\nسوزان إمام',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
