import 'package:flutter/material.dart';
import 'package:operatorsafe/screens/delivery_details_screen.dart';

// Model for drop-off job
class DropOffJob {
  final String jobId;
  final String dropOffAddress;

  DropOffJob({
    required this.jobId,
    required this.dropOffAddress,
  });
}

// Mock data fetch
Future<List<DropOffJob>> fetchDropOffJobs() async {
  await Future.delayed(Duration(seconds: 1));
  return [
    DropOffJob(jobId: 'JOB-001', dropOffAddress: '123 Main St, Springfield'),
    DropOffJob(jobId: 'JOB-002', dropOffAddress: '456 Oak Ave, Riverdale'),
    DropOffJob(jobId: 'JOB-003', dropOffAddress: '789 Pine Rd, Lakeside'),
    DropOffJob(jobId: 'JOB-004', dropOffAddress: '101 Maple St, Brookside'),
  ];
}

class JobListScreen extends StatelessWidget {
  const JobListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SafeLift'),
        backgroundColor: Color(0xFFF5C400), // Your custom theme color
      ),
      body: FutureBuilder<List<DropOffJob>>(
        future: fetchDropOffJobs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load drop-offs'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No drop-offs found'));
          }

          final jobs = snapshot.data!;
          return ListView.separated(
            itemCount: jobs.length,
            separatorBuilder: (context, _) => Divider(),
            itemBuilder: (context, index) {
              final job = jobs[index];
              return ListTile(
                leading: Icon(Icons.location_on, color: Colors.redAccent),
                title: Text(job.dropOffAddress),
                subtitle: Text('Job ID: ${job.jobId}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DeliveryDetailsScreen())
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
