class CopiedData {
  CopiedData({
    required this.data,
    required this.device,
    required this.time,
  });

  String device;
  String data;
  DateTime time;

  Map<String, dynamic> toJson() => {
        "data": data,
        "device": device,
        "time": time,
      };

  static CopiedData fromJson(Map<String, dynamic> json) => CopiedData(
        data: json['data'],
        device: json['device'],
        time: json['time'].toDate(),
      );
}
