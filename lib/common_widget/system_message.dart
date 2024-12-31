import 'package:flutter/material.dart';

class SystemMessage extends StatelessWidget {
  const SystemMessage(
      {super.key, this.title = "System Message", required this.content});
  final String title;
  final String content;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Color(0xFFF5A278),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28), topRight: Radius.circular(28)),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      titlePadding: const EdgeInsets.all(0),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(content,
              style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFFF5A278),
                  fontWeight: FontWeight.bold)),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.all(10),
      actions: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 45.0),
                    backgroundColor: const Color(0xFF478BA2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0))),
                child: const Text(
                  "OK",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),
                ))
          ],
        )
      ],
    );
  }
}

// import 'package:flutter/material.dart';

// class SystemMessage extends StatelessWidget {
//   const SystemMessage({super.key, required this.content});
  
//   final String content;

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20),
//       ),
//       elevation: 8,
//       child: Container(
//         constraints: const BoxConstraints(maxWidth: 340),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Gradient Header
//             Container(
//               padding: const EdgeInsets.symmetric(vertical: 15),
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                   colors: [Color(0xFFF5A278), Color(0xFFF7B892)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(20),
//                   topRight: Radius.circular(20),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 4,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: const Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.info_outline, color: Colors.white, size: 24),
//                   SizedBox(width: 8),
//                   Text(
//                     "System Message",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 20,
//                       letterSpacing: 0.5,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
            
//             // Content
//             Padding(
//               padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
//               child: Text(
//                 content,
//                 style: TextStyle(
//                   fontSize: 24,
//                   color: Colors.grey[800],
//                   height: 1.4,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
            
//             // Button
//             Padding(
//               padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
//               child: ElevatedButton(
//                 onPressed: () => Navigator.pop(context),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF478BA2),
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 28,
//                     vertical: 10,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   elevation: 2,
//                 ),
//                 child: const Text(
//                   "OK",
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     letterSpacing: 0.5,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }