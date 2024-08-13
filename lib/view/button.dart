import 'package:flutter/material.dart';

class RimoconButton extends StatelessWidget {
  const RimoconButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // ボタンが押されたときの処理を記述します。
      },
      style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.zero), // パディングをゼロに設定
        backgroundColor: MaterialStateProperty.all(Colors.transparent), // 背景色を透明に設定
        shadowColor: MaterialStateProperty.all(Colors.transparent), // 影の色を透明に設定
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // 角を丸くする
          ),
        ),
      ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[Colors.red, Colors.yellow], // グラデーションの色を設定
            begin: Alignment.topLeft, // グラデーションの開始位置
            end: Alignment.bottomRight, // グラデーションの終了位置
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Text(
            'グラデーションボタン',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
