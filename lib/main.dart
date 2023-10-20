import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '3x3 Buttons',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static String url = 'https://script.google.com/macros/s/AKfycbw6ngwRrU22PlzHTq--wvyBXTCXdx986k-Ua8oObB_6S_Ezh5pZLLJ7k8bK7dEqH0j6IA/exec?currentTime=2018-01-19 1:25:00';

  var isLoaded = false;

  Map<String, dynamic> currentProgram = {};

  final List<Map<String, dynamic>?> channels = [
    null,
    {
      'network_id': '0x7D70',
      'name': 'ＮＨＫ総合（関西）',
      'currentProgram': {'title': ''}
    },
    null,
    {
      'network_id': '0x7FD2',
      'name': '毎日放送',
      'currentProgram': {'title': ''}
    },
    null,
    {
      'network_id': '0x7FD3',
      'name': '朝日放送',
      'currentProgram': {'title': ''}
    },
    null,
    {
      'network_id': '0x7FD4',
      'name': '関西テレビ放送',
      'currentProgram': {'title': ''}
    },
    null,
    {
      'network_id': '0x7FD5',
      'name': '読売テレビ',
      'currentProgram': {'title': ''}
    },
    {
      'network_id': '0x7D76',
      'name': 'テレビ大阪',
      'currentProgram': {'title': ''}
    },
    {
      'network_id': '0x7FD1',
      'name': 'ＮＨＫＥテレ（関西）',
      'currentProgram': {'title': ''}
    },
  ];

  void setProgramsToChannels(Map<String, dynamic> programs, String currentOrNext) {
    channels.forEach((element) {
      if (element == null) return;

      var network_id = element['network_id'];
      element[currentOrNext] = programs[network_id];
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData(url).then((value) {
      setState(() {
        Map<String, dynamic> currentPrograms = Map.fromIterable(value['currentPrograms'], key: (e) => e['network_id']! as String, value: (e) => e);
        Map<String, dynamic> nextPrograms = Map.fromIterable(value['nextPrograms'], key: (e) => e['network_id']! as String, value: (e) => e);

        setProgramsToChannels(currentPrograms, 'currentProgram');
        setProgramsToChannels(nextPrograms, 'nextProgram');

        isLoaded = true;
      });
    });
  }

  Future<Map<String, dynamic>> fetchData(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      return jsonResponse;
    } else {
      throw Exception('Failed to load data from the server');
    }
  }

  bool isSexActive = false;
  bool isViolenceActive = false;

  void _showReportDialog() async {
    await showDialog(context: context, builder: (_) => ReportDialog(currentProgram));
  }

  void showPressed(int index) {
    // チャンネルを変える
    var network_id = channels[index];
    print("Button ${network_id} pressed");

    currentProgram = channels[index]?['currentProgram'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('TVリモコン'),
        ),
        body: Column(
          children: [
            Center(child: !isLoaded ? CircularProgressIndicator() : Text(currentProgram.isEmpty ? '' : currentProgram['title'])),
            ElevatedButton(onPressed: () => fetchData(url).then((value) => print(value)), child: Text('データ取得')),
            Row(
              children: [
                Text('セックス'),
                Switch(
                    value: isSexActive,
                    onChanged: (bool value) {
                      setState(() {
                        isSexActive = value;
                      });
                    }),
              ],
            ),
            Row(
              children: [
                Text('暴力'),
                Switch(
                    value: isViolenceActive,
                    onChanged: (bool value) {
                      setState(() {
                        isViolenceActive = value;
                      });
                    }),
              ],
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3列
                  mainAxisSpacing: 10.0, // 縦方向の間隔
                  crossAxisSpacing: 10.0, // 横方向の間隔
                ),
                itemCount: channels.length,
                itemBuilder: (BuildContext context, int index) {
                  return ElevatedButton(
                      onPressed: channels[index] == null ? null : () => showPressed(index),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(
                              "${index + 1}ch",
                              style: TextStyle(fontSize: 18.0),
                            ),
                            Text("${channels[index]?['name']}", style: TextStyle(fontSize: 14.0)),
                            Text(channels[index] == null ? '' : channels[index]?['currentProgram']['title']! as String)
                          ],
                        ),
                      ));
                },
              ),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: () {
                  _showReportDialog();
                },
                child: Text('不適切番組報告'))
          ],
        ));
  }
}

class ReportDialog extends StatefulWidget {
  final Map currentProgram;
  ReportDialog(this.currentProgram);

  @override
  _ReportDialogState createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  Map<String, dynamic> reportLabels = {
    'sex': {'label': '性的シーン', 'val': false},
    'violence': {'label': '暴力シーン', 'val': false},
    'bad_taste': {'label': '悪趣味', 'val': false},
  };

  void sendReport(params) {}

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('番組が見るに堪えない理由を選択ください'),
      content: Column(
        children: [
          Row(
            children: [Text(widget.currentProgram['title'])],
          ),
          Column(
            children: reportLabels.entries.map((entry) {
              final key = entry.key;
              final obj = entry.value;

              return Row(
                children: [
                  Checkbox(
                      value: reportLabels[key]['val'],
                      onChanged: (bool? value) {
                        if (value == null) return;
                        setState(() {
                          reportLabels[key]['val'] = value;
                        });
                      }),
                  Text(obj['label'])
                ],
              );
            }).toList(),
          ),
          Text(reportLabels.toString())
        ],
      ),
      actions: [
        ElevatedButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.pop(context);
            }),
      ],
    );
  }
}
