enum FeedbackStatus { newFeedback, inProgress, resolved }

extension FeedbackStatusExtension on FeedbackStatus {
  String get title {
    switch (this) {
      case FeedbackStatus.newFeedback:
        return "New";

      case FeedbackStatus.inProgress:
        return "In Progress";

      case FeedbackStatus.resolved:
        return "Resolved";
    }
  }
}

class FeedbackModel {
  const FeedbackModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
  });

  final int id;
  final String title;
  final String description;
  final FeedbackStatus status;

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      status: json["status"],
    );
  }
}
