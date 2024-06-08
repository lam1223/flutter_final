import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'login.dart';
import 'homepage.dart';
import 'listview.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Sử dụng bảng định tuyến thay vì chỉ định trang chính với home
      routes: {
        '/': (context) => LoginSignupPage(), // Trang đăng nhập/đăng ký là trang mặc định
        '/main': (context) => Homepage(), // Trang chính của ứng dụng
        '/list': (context) => ListViewPage(), // Trang danh sách
      },
    );
  }
}
