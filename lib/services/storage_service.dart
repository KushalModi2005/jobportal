import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/job.dart';

class StorageService {
  static const String _jobsKey = 'jobs';
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    if (kIsWeb) {
      _prefs = await SharedPreferences.getInstance();
    }
  }

  static Future<List<Job>> getJobs() async {
    if (kIsWeb && _prefs != null) {
      final jobsJson = _prefs!.getString(_jobsKey);
      if (jobsJson != null) {
        final List<dynamic> jobsList = json.decode(jobsJson);
        return jobsList.map((job) => Job.fromJson(job)).toList();
      }
      return [];
    }
    return [];
  }

  static Future<void> saveJobs(List<Job> jobs) async {
    if (kIsWeb && _prefs != null) {
      final jobsJson = json.encode(jobs.map((job) => job.toJson()).toList());
      await _prefs!.setString(_jobsKey, jobsJson);
    }
  }
}
