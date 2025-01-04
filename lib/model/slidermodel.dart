class videomodel {
  final String videolink;
  videomodel({
    required this.videolink,
  });
  factory videomodel.fromJson(Map<String, dynamic> json) {
    return videomodel(videolink: json['featured_image']);
  }
}
