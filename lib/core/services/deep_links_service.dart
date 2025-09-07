
// class DeepLinkService {
//   static Future<void> initialize() async {
//     try {
//       String? initialLink = await getInitialLink();
//       if (initialLink != null) {
//         _handleLink(initialLink);
//       }
//     } catch (e) {
//       print('Deep link error: $e');
//     }
    
//     linkStream.listen((String link) {
//       _handleLink(link);
//     });
//   }

//   static void _handleLink(String link) {
//     Uri uri = Uri.parse(link);
//     if (uri.path == '/verify-email') {
//       String? token = uri.queryParameters['token'];
//       if (token != null) {
//         Get.toNamed('/email-verification', arguments: token);
//       }
//     }
//   }
// }