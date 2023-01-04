class VCustomMsgAtt {
  final Map<String, dynamic> data;

//<editor-fold desc="Data Methods">

  VCustomMsgAtt({
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

  factory VCustomMsgAtt.fromMap(Map<String, dynamic> map) {
    return VCustomMsgAtt(
      data: map['data'] as Map<String, dynamic>,
    );
  }

//</editor-fold>
}
