// import 'package:flutter/material.dart';
// import 'package:operatorsafe/screens/delivery_details_screen.dart';

// // Model for drop-off job
// class DropOffJob {
//   final String jobId;
//   final String dropOffAddress;

//   DropOffJob({required this.jobId, required this.dropOffAddress});
// }

// // Mock data fetch
// Future<List<DropOffJob>> fetchDropOffJobs() async {
//   await Future.delayed(const Duration(seconds: 1));
//   return [
//     DropOffJob(jobId: 'JOB-001', dropOffAddress: '123 Main St, Springfield'),
//     DropOffJob(jobId: 'JOB-002', dropOffAddress: '456 Oak Ave, Riverdale'),
//     DropOffJob(jobId: 'JOB-003', dropOffAddress: '789 Pine Rd, Lakeside'),
//     DropOffJob(jobId: 'JOB-004', dropOffAddress: '101 Maple St, Brookside'),
//   ];
// }

// class JobListScreen extends StatefulWidget {
//   const JobListScreen({super.key});

//   @override
//   State<JobListScreen> createState() => _JobListScreenState();
// }

// class _JobListScreenState extends State<JobListScreen> {
//   List<DropOffJob> _allJobs = [];
//   List<DropOffJob> _filteredJobs = [];
//   bool _loading = true;
//   String _searchQuery = '';

//   @override
//   void initState() {
//     super.initState();
//     _loadJobs();
//   }

//   Future<void> _loadJobs() async {
//     final jobs = await fetchDropOffJobs();
//     setState(() {
//       _allJobs = jobs;
//       _filteredJobs = jobs;
//       _loading = false;
//     });
//   }

//   void _filterJobs(String query) {
//     final filtered =
//         _allJobs.where((job) {
//           final addressLower = job.dropOffAddress.toLowerCase();
//           final jobIdLower = job.jobId.toLowerCase();
//           final searchLower = query.toLowerCase();
//           return addressLower.contains(searchLower) ||
//               jobIdLower.contains(searchLower);
//         }).toList();

//     setState(() {
//       _searchQuery = query;
//       _filteredJobs = filtered;
//     });
//   }

//   Future<void> _createNewJob() async {
//     final newJob = await showDialog<DropOffJob>(
//       context: context,
//       builder: (context) => const _CreateJobDialog(),
//     );

//     if (newJob != null) {
//       setState(() {
//         _allJobs.add(newJob);
//         _filterJobs(_searchQuery); // Refresh filtered list including new job
//       });

//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => DeliveryDetailsScreen(job: newJob),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Job list'),
//         backgroundColor: const Color(0xFFF5C400),
//       ),
//       body:
//           _loading
//               ? const Center(child: CircularProgressIndicator())
//               : Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: TextField(
//                       onChanged: _filterJobs,
//                       decoration: InputDecoration(
//                         prefixIcon: const Icon(Icons.search),
//                         hintText: 'Search jobs...',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: ListView.separated(
//                       itemCount: _filteredJobs.length + 1,
//                       separatorBuilder: (context, _) => const Divider(),
//                       itemBuilder: (context, index) {
//                         if (index == _filteredJobs.length) {
//                           return ListTile(
//                             leading: const Icon(
//                               Icons.add_circle_outline,
//                               color: Colors.green,
//                             ),
//                             title: const Text('Create New Job'),
//                             onTap: _createNewJob,
//                           );
//                         }

//                         final job = _filteredJobs[index];
//                         return ListTile(
//                           leading: const Icon(
//                             Icons.location_on,
//                             color: Colors.redAccent,
//                           ),
//                           title: Text(job.dropOffAddress),
//                           subtitle: Text('Job ID: ${job.jobId}'),
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder:
//                                     (context) =>
//                                         DeliveryDetailsScreen(job: job),
//                               ),
//                             );
//                           },
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//     );
//   }
// }

// class _CreateJobDialog extends StatefulWidget {
//   const _CreateJobDialog({Key? key}) : super(key: key);

//   @override
//   State<_CreateJobDialog> createState() => _CreateJobDialogState();
// }

// class _CreateJobDialogState extends State<_CreateJobDialog> {
//   final _addressController = TextEditingController();

//   @override
//   void dispose() {
//     _addressController.dispose();
//     super.dispose();
//   }

//   void _submit() {
//     final address = _addressController.text.trim();
//     if (address.isEmpty) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text('Please enter an address')));
//       return;
//     }

//     final newJob = DropOffJob(
//       jobId: 'JOB-${DateTime.now().millisecondsSinceEpoch}',
//       dropOffAddress: address,
//     );

//     Navigator.of(context).pop(newJob);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('Create New Job'),
//       content: TextField(
//         controller: _addressController,
//         decoration: const InputDecoration(
//           labelText: 'Drop-off Address',
//           hintText: 'Enter address',
//         ),
//         autofocus: true,
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.of(context).pop(),
//           child: const Text('Cancel'),
//         ),
//         ElevatedButton(onPressed: _submit, child: const Text('Create')),
//       ],
//     );
//   }
// }
