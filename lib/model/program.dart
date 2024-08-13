class Program {
  int id;
  DateTime broadcast_start_date;
  DateTime broadcast_end_date;
  String network_id;
  String media;
  String title;
  String program_title;
  String synopsis;
  String description;
  int sex_rate;
  int violence_rate;
  int illegal_rate;

  Program({
    this.id = 0,
    DateTime? broadcast_start_date,
    DateTime? broadcast_end_date,
    this.network_id = '',
    this.media = '',
    this.title = '',
    this.program_title = '',
    this.synopsis = '',
    this.description = '',
    this.sex_rate = 0,
    this.violence_rate = 0,
    this.illegal_rate = 0,
  })  : this.broadcast_end_date = broadcast_end_date ?? DateTime.now(),
        this.broadcast_start_date = broadcast_start_date ?? DateTime.now();
}
