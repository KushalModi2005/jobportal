import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/job.dart';
import '../providers/job_provider.dart';
import 'job_detail_screen.dart';

class JobSeekerScreen extends StatefulWidget {
  const JobSeekerScreen({super.key});

  @override
  State<JobSeekerScreen> createState() => _JobSeekerScreenState();
}

class _JobSeekerScreenState extends State<JobSeekerScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Schedule job loading after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadJobs();
    });
  }

  Future<void> _loadJobs() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<JobProvider>(context, listen: false).fetchJobs();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading jobs: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Available Jobs'), elevation: 0),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Consumer<JobProvider>(
                builder: (context, jobProvider, child) {
                  if (jobProvider.jobs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.work_off_rounded,
                            size: 80,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No jobs available',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Check back later for new opportunities',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: _loadJobs,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Refresh'),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: _loadJobs,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: jobProvider.jobs.length,
                      itemBuilder: (context, index) {
                        final job = jobProvider.jobs[index];
                        return _buildJobCard(context, job);
                      },
                    ),
                  );
                },
              ),
    );
  }

  Widget _buildJobCard(BuildContext context, Job job) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => JobDetailScreen(job: job)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      job.companyName.isNotEmpty
                          ? job.companyName.substring(0, 1).toUpperCase()
                          : 'C',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.jobTitle,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          job.companyName,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                job.jobDescription.length > 100
                    ? '${job.jobDescription.substring(0, 100)}...'
                    : job.jobDescription,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Posted: ${_formatDate(job.createdAt)}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 20,
                    color: Colors.teal,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return 'Just now';
      }
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
