class dashboardmodelvideo {
  // final int id;
  final String videolink;
  dashboardmodelvideo({
    // required this.id,
    required this.videolink,
  });
  factory dashboardmodelvideo.fromJson(Map<String, dynamic> json) {
    return dashboardmodelvideo(
      // id: json['id'],
      videolink: json['youtubelink'],
    );
  }
}

class dashboardmodeljugnu {

  final String course_id;
  final String image;
  dashboardmodeljugnu({
    
    required this.course_id,
    required this.image,
  });
  factory dashboardmodeljugnu.fromJson(Map<String, dynamic> json) {
    return dashboardmodeljugnu(
      course_id: json['course_id'],
      image: json['image'],
    );
  }
}
class dashboardmodelslider {

  // final String course_id;
  final String image;
  dashboardmodelslider({
    
    // required this.course_id,
    required this.image,
  });
  factory dashboardmodelslider.fromJson(Map<String, dynamic> json) {
    return dashboardmodelslider(
      // course_id: json['course_id'],
      image: json['image'],
    );
  }
}

class dashboardrecordmodel {

final dynamic total;
final dynamic complete;
final dynamic pending;

  dashboardrecordmodel({
    
    required this.total,
    required this.complete,
    required this.pending,

  });
  factory dashboardrecordmodel.fromJson(Map<String, dynamic> json) {
    return dashboardrecordmodel(
      total: json['total_user_assignments'],
      complete: json['total_satisfied_assignments'],
      pending: json['total_pending_assignments'],
      
    );
  }
}
