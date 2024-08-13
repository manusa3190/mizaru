import 'package:tv/model/program.dart';

class Channel {
  String network_id;
  String name;
  Program? current_program;
  Program? next_program;

  void setProgram({required Program program, required String timeline}) {
    if (timeline == 'currentPrograms') {
      this.current_program = program;
    } else if (timeline == 'nextPrograms') {
      this.next_program = program;
    }
    print(this.current_program.toString());
  }

  Channel({this.network_id = '', this.name = '', this.current_program, this.next_program});
}
