import 'package:flutter/foundation.dart';
import '../models/job.dart';
import '../services/storage_service.dart';

class JobProvider with ChangeNotifier {
  List<Job> _jobs = [];
  bool _isLoading = false;

  List<Job> get jobs => _jobs;
  bool get isLoading => _isLoading;

  // Static sample jobs
  final List<Job> _sampleJobs = [
    Job(
      id: 1,
      companyName: 'TechCorp Solutions',
      jobTitle: 'Senior Flutter Developer',
      jobDescription:
          'We are looking for an experienced Flutter developer to join our team. The ideal candidate should have 3+ years of experience in mobile app development and a strong understanding of state management and clean architecture.',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Job(
      id: 2,
      companyName: 'InnovateX',
      jobTitle: 'UI/UX Designer',
      jobDescription:
          'Join our creative team as a UI/UX Designer. You will be responsible for creating beautiful and intuitive user interfaces for our mobile and web applications. Experience with Figma and Adobe XD is required.',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Job(
      id: 3,
      companyName: 'DataFlow Systems',
      jobTitle: 'Backend Developer',
      jobDescription:
          'Looking for a Backend Developer with experience in Node.js and MongoDB. You will be responsible for building and maintaining our server infrastructure and APIs. Knowledge of cloud services is a plus.',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Job(
      id: 4,
      companyName: 'GreenTech Solutions',
      jobTitle: 'Full Stack Developer',
      jobDescription:
          'We are seeking a Full Stack Developer to work on our sustainability-focused applications. Experience with React, Node.js, and PostgreSQL is required. Knowledge of AWS or GCP is a plus.',
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
    ),
    Job(
      id: 5,
      companyName: 'HealthCare Plus',
      jobTitle: 'Mobile App Developer',
      jobDescription:
          'Join our team to develop healthcare applications that make a difference. Experience with Flutter or React Native is required. Knowledge of HIPAA compliance is a plus.',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  Future<void> fetchJobs() async {
    _isLoading = true;
    notifyListeners();

    try {
      if (kIsWeb) {
        _jobs = await StorageService.getJobs();
        if (_jobs.isEmpty) {
          _jobs = _sampleJobs;
          await StorageService.saveJobs(_jobs);
        }
      } else {
        _jobs = _sampleJobs;
      }
    } catch (e) {
      debugPrint('Error fetching jobs: $e');
      _jobs = _sampleJobs;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addJob(Job job) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (kIsWeb) {
        _jobs.add(job);
        await StorageService.saveJobs(_jobs);
      } else {
        _sampleJobs.add(job);
        _jobs = _sampleJobs;
      }
      return true;
    } catch (e) {
      debugPrint('Error adding job: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
