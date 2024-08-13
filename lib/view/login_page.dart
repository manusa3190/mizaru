import 'package:flutter/material.dart';
import 'package:tv/screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController =
      TextEditingController(text: 'yuta.ueda.fromosaka@gmail.com');
  TextEditingController passwordController = TextEditingController(text: 'password');

  _login() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Screen()));
  }

  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        width: double.infinity,
        color: Colors.amber.shade100,
        child: Column(
          children: [
            Text(
              '見ざる ログイン',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(hintText: 'メールアドレス'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: 'パスワード',
                  suffixIcon: IconButton(
                    // 文字の表示・非表示でアイコンを変える
                    icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
                    // アイコンがタップされたら現在と反対の状態をセットする
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  ),
                ),
                obscureText: _isObscure,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _login();
              },
              child: Text('ログイン', style: TextStyle(color: Colors.white)),
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue)),
            ),
            Text(emailController.text)
          ],
        ),
      ),
    ));
  }
}
