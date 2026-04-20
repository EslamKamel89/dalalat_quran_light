class TicketModel {
  String? message;
  String? answer;
  String? status;
  String? error;

  TicketModel({this.message, this.answer, this.status, this.error});

  @override
  String toString() {
    return 'TicketModel(message: $message, answer: $answer, status: $status, error: $error)';
  }

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      message: json['message'] as String?,
      answer: json['answer'] as String?,
      status: json['status'] as String?,
      error: json['error'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'message': message,
    'answer': answer,
    'status': status,
    'error': error,
  };
}
