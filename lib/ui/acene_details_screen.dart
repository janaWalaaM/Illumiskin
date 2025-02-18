import 'package:flutter/material.dart';

class AcneDetailScreen extends StatelessWidget {
  const AcneDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image Section
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.asset(
                  'assests/Screenshot 2024-12-18 101704.png', // Replace with your asset path
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Title
            const Text(
              'Acne',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),

            // Information Section
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Color(0xff556C8D),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  // Description
                  Text(
                    'also known as acne vulgaris, is a long-term skin condition that occurs when dead skin cells and oil from the skin clog hair follicles. Typical features of the condition include blackheads or whiteheads, pimples, oily skin, and possible scarring.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Classification
                  Text(
                    'Classification',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'The severity of acne vulgaris (Gr. ἄκμή, "point" + L. vulgaris, "common") can be classified as mild, moderate, or severe to determine an appropriate treatment regimen. There is no universally accepted scale for grading acne severity. [The presence of clogged skin follicles (known as comedones) limited to the face with occasional inflammatory lesions defines mild acne.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Signs and Symptoms
                  Text(
                    'Signs and symptoms',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Typical features of acne include increased secretion of oily sebum by the skin, microcomedones, comedones, papules, nodules (large papules), pustules, and often results in scarring. The appearance of acne varies with skin color. It may result in psychological and social problems.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Causes
                  Text(
                    'Causes',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Risk factors for the development of acne, other than genetics, have not been conclusively identified. Possible secondary contributors include hormones, infections, diet, and stress. Studies investigating the impact of smoking on the incidence and severity of acne have been inconclusive.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
