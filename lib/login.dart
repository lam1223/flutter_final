import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:flutter/material.dart';

class LoginSignupPage extends StatefulWidget {
  @override
  _LoginSignupPageState createState() => _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoginForm = true; // Biến để phân biệt giữa đăng nhập và đăng ký

  // Hàm đăng nhập
  Future<void> _signInWithEmailAndPassword() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // Đăng nhập thành công, chuyển hướng đến trang chính
      Navigator.pushNamed(context, '/main'); // Chuyển đến trang chính

    } catch (e) {
      print("Đăng nhập thất bại: $e");
      // Hiển thị SnackBar thông báo lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Đăng nhập thất bại: $e"),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  // Hàm đăng ký
  Future<void> _signUpWithEmailAndPassword() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // Đăng ký thành công, chuyển hướng đến trang chính
      Navigator.pushReplacementNamed(context, '/main');
    } catch (e) {
      print("Đăng ký thất bại: $e");
      // Hiển thị SnackBar thông báo lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Đăng ký thất bại: $e"),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLoginForm ? 'Đăng nhập' : 'Đăng ký', textAlign: TextAlign.center),
        centerTitle: true, // Căn giữa tiêu đề của AppBar
        leading: _isLoginForm
            ? null // Không có nút quay lại khi đang ở màn hình đăng nhập
            : IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _isLoginForm = true; // Quay lại màn hình đăng nhập
                  });
                },
              ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Mật khẩu'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_isLoginForm) {
                  _signInWithEmailAndPassword();
                } else {
                  _signUpWithEmailAndPassword();
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Text(_isLoginForm ? 'Đăng nhập' : 'Đăng ký'),
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                setState(() {
                  _isLoginForm = !_isLoginForm; // Chuyển đổi chế độ giữa đăng nhập và đăng ký
                });
              },
              child: Text(_isLoginForm ? 'Tạo tài khoản mới' : 'Đăng nhập'),
            ),
          ],
        ),
      ),
    );
  }
}
