import 'package:flutter/material.dart';

class PersonalInfoWidget extends StatelessWidget {
  final String name = 'HE HUALIANG';
  final String email = '230263367@stu.vtc.edu.hk';
  final String student_id = '230263367';

  // hard code do not need this one
  // const PersonalInfoWidget({
  //   Key? key,
  //   required this.name,
  //   required this.email,
  //   required this.student_id,
  // }) : super(key: key);

  const PersonalInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          // color: Colors.blue[50],
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          decoration: BoxDecoration(
            // color: Colors.blue[50],
            border: Border.all(color: Colors.greenAccent),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Wrap(
            spacing: 12,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Name: $name', style: TextStyle(fontSize: 16)),
              Text('Email: $email', style: TextStyle(fontSize: 14)),
              Text('Student ID: $student_id', style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ],
    );

    // return Card(
    //   margin: const EdgeInsets.all(16),
    //   elevation: 12, // shadow effect
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    //
    //   child: Padding(
    //     padding: const EdgeInsets.all(16),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Text(
    //           'Name: $name',
    //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    //         ),
    //         SizedBox(height: 8),
    //         Text('Student ID: $student_id'),
    //         SizedBox(height: 8),
    //         Text('Email: $email'),
    //       ],
    //     ),
    //   ),
    // );

    // return Container(
    //   margin: const EdgeInsets.all(16),
    //   decoration: BoxDecoration(
    //     color: Color.fromARGB(255, 255, 255, 255),
    //
    //     borderRadius: BorderRadius.circular(20),
    //     boxShadow: [
    //       BoxShadow(
    //         color: Colors.grey[500]!,
    //         offset: Offset(6, 6),
    //         blurRadius: 15,
    //       ),
    //       BoxShadow(
    //         color: Colors.white,
    //         offset: Offset(-6, -6),
    //         blurRadius: 15,
    //       ),
    //     ],
    //   ),
    //   child: Padding(
    //     padding: const EdgeInsets.all(20),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Text(
    //           'Name: $name',
    //           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    //         ),
    //         SizedBox(height: 12),
    //         Text('Email: $email'),
    //         SizedBox(height: 12),
    //         Text('Student ID: $student_id'),
    //       ],
    //     ),
    //   ),
    // );
  }
}
