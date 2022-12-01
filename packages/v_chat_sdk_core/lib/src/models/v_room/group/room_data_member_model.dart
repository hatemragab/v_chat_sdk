import '../../../../v_chat_sdk_core.dart';

class RoomDataMemberModel {
  final RoomType roomType;
  String? transTo;
  String title;
  String? nTitle;
  String img;
  bool isMuted;
  bool isDeleted;
  bool isArchive;
  String createdAt;

//<editor-fold desc="Data Methods">

  RoomDataMemberModel({
    required this.roomType,
    this.transTo,
    required this.title,
    required this.createdAt,
    this.nTitle,
    required this.img,
    required this.isMuted,
    required this.isDeleted,
    required this.isArchive,
  });

  @override
  String toString() {
    return 'RoomDataMemberModel{ roomType: $roomType, transTo: $transTo, title: $title, nTitle: $nTitle, img: $img, isMuted: $isMuted, isDeleted: $isDeleted, isArchive: $isArchive,}';
  }

  Map<String, dynamic> toMap() {
    return {
      'rT': roomType.name,
      'tTo': transTo,
      't': title,
      'nTitle': nTitle,
      'img': img,
      'isM': isMuted,
      'isD': isDeleted,
      'isA': isArchive,
      'createdAt': createdAt,
    };
  }

  factory RoomDataMemberModel.fromMap(Map<String, dynamic> map) {
    return RoomDataMemberModel(
      roomType: RoomType.values.byName(map['rT'] as String),
      transTo: map['tTo'] as String?,
      title: map['t'] as String,
      nTitle: map['nTitle'] as String?,
      img: map['img'] as String,
      isMuted: map['isM'] as bool,
      isDeleted: map['isD'] as bool,
      isArchive: map['isA'] as bool,
      createdAt: map['createdAt'] as String,
    );
  }

//</editor-fold>
}
