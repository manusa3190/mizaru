import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:tv/model/program.dart';

import '../model/useUser.dart';

class ReportDialog extends StatefulWidget {
  Program currentProgram;
  ReportDialog(this.currentProgram);

  @override
  _ReportDialogState createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  Map<String, dynamic> reportLabels = {
    'sex': {'label': '性的シーン', 'val': false},
    'violence': {'label': '暴力', 'val': false},
    'illegal': {'label': '犯罪', 'val': false},
  };

  dynamic sendReport() async {
    const uri =
        'https://script.google.com/macros/s/AKfycbxIBAt8EThh_XiNmTQTyoFcG9Sv6mjNkDvsWqtth0Bt5VH5Prgpji210aNBIfihe2UBHw/exec';
    Uri url = Uri.parse(uri);
    Map<String, String> headers = {'content-type': 'application/json'};
    Map data = {};
    data['user'] = Provider.of<UseUser>(context, listen: false).userEmail;
    data['program_id'] = widget.currentProgram.program_title;
    data['program_title'] = widget.currentProgram.program_title;
    ['sex', 'violence', 'illegal'].forEach((key) {
      data[key] = reportLabels[key]['val'];
    });
    print(data);
    String body = json.encode(data);
    http.Response resp = await http.post(url, headers: headers, body: body);
    return resp;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text('番組が見るに堪えない理由を選択ください'),
      content: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(widget.currentProgram.program_title),
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
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.orange)),
                child: const Text('OK'),
                onPressed: () {
                  () async {
                    dynamic res = await sendReport();
                    Navigator.pop(context);
                  }();
                }),
          ],
        ),
      ],
    );
  }
}
