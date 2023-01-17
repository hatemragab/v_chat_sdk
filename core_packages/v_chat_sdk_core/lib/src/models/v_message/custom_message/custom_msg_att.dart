class VCustomMsgData {
  final Map<String, dynamic> data;

//<editor-fold desc="Data Methods">

  VCustomMsgData({
    required this.data,
  });

  @override
  String toString() {
    return 'VCustomMsgAtt{data: $data}';
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data,
    };
  }

  factory VCustomMsgData.fromMap(Map<String, dynamic> map) {
    return VCustomMsgData(
      data: map['data'] as Map<String, dynamic>,
    );
  }

//</editor-fold>
}
