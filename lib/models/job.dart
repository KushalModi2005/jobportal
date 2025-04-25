class Job {
  final int? id;
  final String companyName;
  final String jobTitle;
  final String jobDescription;
  final DateTime createdAt;

  Job({
    this.id,
    required this.companyName,
    required this.jobTitle,
    required this.jobDescription,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'companyName': companyName,
      'jobTitle': jobTitle,
      'jobDescription': jobDescription,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toJson() => toMap();

  factory Job.fromMap(Map<String, dynamic> map) {
    return Job(
      id: map['id'],
      companyName: map['companyName'],
      jobTitle: map['jobTitle'],
      jobDescription: map['jobDescription'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  factory Job.fromJson(Map<String, dynamic> json) => Job.fromMap(json);
}
