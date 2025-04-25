import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/job.dart';
import '../providers/job_provider.dart';

class JobCreatorScreen extends StatefulWidget {
  const JobCreatorScreen({super.key});

  @override
  State<JobCreatorScreen> createState() => _JobCreatorScreenState();
}

class _JobCreatorScreenState extends State<JobCreatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyNameController = TextEditingController();
  final _jobTitleController = TextEditingController();
  final _jobDescriptionController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _companyNameController.dispose();
    _jobTitleController.dispose();
    _jobDescriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      try {
        final job = Job(
          companyName: _companyNameController.text.trim(),
          jobTitle: _jobTitleController.text.trim(),
          jobDescription: _jobDescriptionController.text.trim(),
          createdAt: DateTime.now(),
        );

        final success = await Provider.of<JobProvider>(
          context,
          listen: false,
        ).addJob(job);

        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Job posted successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          _formKey.currentState!.reset();
          _companyNameController.clear();
          _jobTitleController.clear();
          _jobDescriptionController.clear();
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to post job. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post a Job'), elevation: 0),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create a new job posting',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Fill in the details below to post a new job opportunity',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 32),
                _buildInputField(
                  controller: _companyNameController,
                  label: 'Company Name',
                  hint: 'Enter your company name',
                  icon: Icons.business_rounded,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter company name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildInputField(
                  controller: _jobTitleController,
                  label: 'Job Title',
                  hint: 'Enter job title',
                  icon: Icons.work_rounded,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter job title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildTextAreaField(
                  controller: _jobDescriptionController,
                  label: 'Job Description',
                  hint: 'Enter detailed job description',
                  icon: Icons.description_rounded,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter job description';
                    }
                    if (value.length < 30) {
                      return 'Description should be at least 30 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitForm,
                    child:
                        _isSubmitting
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : const Text(
                              'Post Job',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.teal),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildTextAreaField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: Icon(icon, color: Colors.teal),
            ),
            alignLabelWithHint: true,
          ),
          maxLines: 5,
          validator: validator,
        ),
      ],
    );
  }
}
