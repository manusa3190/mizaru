import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tv/model/channel.dart';
import 'package:tv/model/program.dart';
import 'package:http/http.dart' as http;
import 'package:tv/model/useUser.dart';
import 'package:tv/view/button.dart';
import 'package:tv/view/report_dialog.dart';

class Remocon extends StatefulWidget {
  const Remocon({super.key});

  @override
  State<Remocon> createState() => _RemoconState();
}

class S {
  String title;
  bool isActive;

  S({this.title = '', this.isActive = false});
}

class _RemoconState extends State<Remocon> {
  List<S> switches = [S(title: 'sex'), S(title: 'violence'), S(title: 'illegal')];

  List<Channel?> channels = [
    null,
    Channel(network_id: '0x7D70', name: 'ＮＨＫ総合（関西）'),
    null,
    Channel(network_id: '0x7FD2', name: '毎日放送'),
    null,
    Channel(network_id: '0x7FD3', name: '朝日放送'),
    null,
    Channel(network_id: '0x7FD4', name: '関西テレビ放送'),
    null,
    Channel(network_id: '0x7FD5', name: '読売テレビ'),
    Channel(network_id: '0x7D76', name: 'テレビ大阪'),
    Channel(network_id: '0x7FD1', name: 'ＮＨＫＥテレ（関西）'),
  ];

  static String url =
      'https://script.google.com/macros/s/AKfycbyhb7BXrrG1-BvuPgsQ_EhaHYmk8feTOddRdE3W70luZOKu2W6sqda_bBQz5UYLNbnNxg/exec';

  DateTime currentTime = DateTime(2018, 1, 20, 21, 10, 0);

  Map<String, String> queryParams = {'test': 'hogehoge'};

  Future<void> setProgramsToChannels() async {
    Uri fullUrl = Uri.parse(url).replace(queryParameters: queryParams);
    final response = await http.get(fullUrl);

    if (response.statusCode == 200) {
      var value = json.decode(response.body);
      setState(() {
        ['currentPrograms', 'nextPrograms'].forEach((timeLine) {
          channels.forEach((channel) {
            if (channel == null) {
              return;
            } else {
              Map? data = value[timeLine][channel.network_id];
              if (data == null) return;
              Program program = Program(
                  id: data['id'],
                  broadcast_start_date: DateTime.parse(data['broadcast_start_date']),
                  broadcast_end_date: DateTime.parse(data['broadcast_end_date']),
                  network_id: data['network_id'],
                  media: data['media'],
                  title: data['title'],
                  program_title: data['program_title'],
                  synopsis: data['synopsis'],
                  sex_rate: data['sex_rate'],
                  violence_rate: data['violence_rate'],
                  illegal_rate: data['illegal_rate']);

              if (data['network_id'] == '0x7FD5') {
                print("${timeLine}: ${program.toString()}");
              }

              channel.setProgram(program: program, timeline: timeLine);
            }
          });
        });
      });
    } else {
      throw Exception('Failed to load data from the server');
    }
  }

  Timer? timer;

// 毎時5分、15分、25分、35分、45分、55分に実行する
  void setTimerSetProgramsToChannels() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      var currentMinute = currentTime.minute;
      if (currentMinute % 10 == 5) {
        setState(() {
          isLoaded = false;
        });
        await setProgramsToChannels();
        setState(() {
          isLoaded = true;
        });
      }
    });
  }

  var isLoaded = false;

  void switchTimer(value) {
    if (value) {
      setTimerSetProgramsToChannels();
    } else {
      timer?.cancel();
    }
  }

  @override
  void initState() {
    super.initState();
    isLoaded = false;
    Timer.periodic(
        Duration(milliseconds: 200),
        (timer) => setState(() {
              currentTime = currentTime.add(Duration(seconds: 10));
              queryParams = {
                'calledBy': 'flutter',
                'currentTime': DateFormat('yyyy-MM-dd HH:mm:ss').format(currentTime),
                'user': 'yuta.ueda.fromosaka@gmail.com',
              };
            }));

    setTimerSetProgramsToChannels();

    setProgramsToChannels().then((value) => setState(() => isLoaded = true));
  }

  Program? currentProgram;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('リモコン'),
        backgroundColor: Colors.blue,
      ),
      body: isLoaded == false
          ? Center(
              child: CircularProgressIndicator(), // isLoadedがfalseの場合、ローディングインジケータを表示
            )
          : Column(children: [
              ExpansionTile(
                title: Text('アラート設定'),
                onExpansionChanged: (bool changed) {
                  //開いた時の処理を書ける
                },
                children: <Widget>[
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: switches.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Container(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(switches[index].title),
                              Transform.scale(
                                scale: 0.8,
                                child: Switch(
                                  value: switches[index].isActive,
                                  onChanged: (bool value) {
                                    setState(() {
                                      switches[index].isActive = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              Expanded(
                child: GridView.builder(
                  // shrinkWrap: true,
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 3列
                    mainAxisSpacing: 10.0, // 縦方向の間隔
                    crossAxisSpacing: 10.0, // 横方向の間隔
                  ),
                  itemCount: channels.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Stack(
                      clipBehavior: Clip.none, // Stackの外側にウィジェットを表示するために必要
                      children: [
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: ElevatedButton(
                              onPressed: () => setState(() {
                                    currentProgram = channels[index]!.current_program;
                                  }),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(channels[index] == null
                                        ? Colors.grey
                                        : channels[index]?.network_id == currentProgram?.network_id
                                            ? Colors.orange
                                            : Colors.blue),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                  EdgeInsets.symmetric(horizontal: 8.0),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "${index + 1}ch",
                                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                                  ),
                                  Text(
                                    "${channels[index]?.name?.substring(0, channels[index]!.name!.length < 5 ? channels[index]!.name!.length : 5)}",
                                    style: TextStyle(fontSize: 14.0, color: Colors.white), // 色を白に設定
                                  ),
                                  SizedBox(height: 3),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: Text(
                                        channels[index] == null
                                            ? ''
                                            : channels[index]?.current_program?.title ?? '',
                                        style:
                                            TextStyle(color: Colors.white, fontSize: 12), // 色を白に設定
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        Positioned(
                          right: -10, // 右上に配置し、少しはみ出すように調整
                          top: -15, // 同上
                          child: channels[index] == null
                              ? const SizedBox()
                              : Row(
                                  children: [
                                    channels[index]!.current_program!.sex_rate > 2
                                        ? Icon(
                                            Icons.favorite,
                                            color: Colors.pink.shade300,
                                            size: 30,
                                          )
                                        : channels[index]!.next_program!.sex_rate > 2
                                            ? Icon(
                                                Icons.favorite,
                                                color: (currentTime.second / 10).ceil().isEven
                                                    ? Colors.pink.shade300
                                                    : Colors.transparent,
                                                size: 30,
                                              )
                                            : const SizedBox(),
                                    channels[index]!.current_program!.violence_rate > 2
                                        ? Icon(
                                            Icons.front_hand,
                                            color: Colors.yellow.shade700,
                                            size: 30,
                                          )
                                        : channels[index]!.next_program!.violence_rate > 2
                                            ? Icon(
                                                Icons.front_hand,
                                                color: (currentTime.second / 10).ceil().isEven
                                                    ? Colors.yellow.shade700
                                                    : Colors.transparent,
                                                size: 30,
                                              )
                                            : const SizedBox(),
                                    channels[index]!.current_program!.illegal_rate > 2
                                        ? Icon(
                                            Icons.error,
                                            color: Colors.red.shade700,
                                            size: 30,
                                          )
                                        : channels[index]!.next_program!.illegal_rate > 2
                                            ? Icon(
                                                Icons.error,
                                                color: (currentTime.second / 10).ceil().isEven
                                                    ? Colors.red.shade700
                                                    : Colors.transparent,
                                                size: 30,
                                              )
                                            : const SizedBox(),
                                  ],
                                ), // 表示したいアイコン
                        ),
                      ],
                    );
                  },
                ),
              ),
              Text(currentTime.toString()),
              Switch(
                  value: timer == null ? false : timer!.isActive,
                  onChanged: (bool value) {
                    setState(() => switchTimer(value));
                  }),
              // RimoconButton(key: ValueKey('aaaaaaa')),
            ]),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.call_outlined),
          backgroundColor: Colors.orange,
          onPressed: () async {
            if (currentProgram == null) return;

            await showDialog(context: context, builder: (_) => ReportDialog(currentProgram!));
          }),
    );
  }
}
