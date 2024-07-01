class ChatModal {
  String msg, type, status, react, star;
  DateTime time;

  ChatModal({
    required this.msg,
    required this.time,
    required this.type,
    required this.react,
    required this.star,
    required this.status,
  });

  factory ChatModal.fromMap({required Map data}) => ChatModal(
        msg: data['msg'],
        time: DateTime.fromMillisecondsSinceEpoch(int.parse(data['time'])),
        type: data['type'],
        status: data['status'],
        react: data['react'],
        star: data['star'],
      );

  Map<String, dynamic> get toMap => {
        'msg': msg,
        'time': time.millisecondsSinceEpoch.toString(),
        'type': type,
        'status': status,
        'star': star,
        'react': react,
      };
}
