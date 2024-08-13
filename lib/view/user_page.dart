import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class Thresholds {
  int sexThreshold = 5;
  int violenceThreshold = 5;
  int illegalThreshold = 5;
}

class Mode {
  String title = '';
  Thresholds thresholds = Thresholds();

  Mode(this.title);
}

class _UserPageState extends State<UserPage> {
  List<Mode> modes = [Mode('一人だけ'), Mode('親だけ'), Mode('子供と一緒')];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            'ユーザーページ',
            style: TextStyle(color: Colors.white),
          )),
      body: Column(
        children: [
          Text(
            'モード設定',
            style: TextStyle(fontSize: 24),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8.0),
              children: modes.map((mode) {
                return ExpansionTile(
                  title: Text(mode.title),
                  children: [
                    _buildSlider(
                      'Sex Threshold',
                      mode.thresholds.sexThreshold,
                      (value) {
                        setState(() {
                          mode.thresholds.sexThreshold = value.round();
                        });
                      },
                    ),
                    _buildSlider(
                      'Violence Threshold',
                      mode.thresholds.violenceThreshold,
                      (value) {
                        setState(() {
                          mode.thresholds.violenceThreshold = value.round();
                        });
                      },
                    ),
                    _buildSlider(
                      'Illegal Threshold',
                      mode.thresholds.illegalThreshold,
                      (value) {
                        setState(() {
                          mode.thresholds.illegalThreshold = value.round();
                        });
                      },
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          ElevatedButton(onPressed: () {}, child: Text('更新'))
        ],
      ),
    );
  }

  Widget _buildSlider(String label, int value, Function(double) onChanged) {
    return Column(
      children: [
        Text(label),
        Slider(
          value: value.toDouble(),
          min: 0,
          max: 10,
          divisions: 10,
          onChanged: onChanged,
          label: '$value',
        ),
      ],
    );
  }
}
