import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../widgets/dashboard_card.dart';

class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Professional Help
            DashboardCard(
              title: '🏥 Professional Support',
              child: Column(
                children: [
                  _buildResourceItem(
                    context,
                    'University Counseling Services',
                    'Free mental health services for students',
                    '03-7967-3333',
                    Icons.local_hospital,
                    Colors.red,
                  ),
                  const SizedBox(height: 16),
                  _buildResourceItem(
                    context,
                    'Student Affairs Office',
                    'Academic coaching and student support',
                    'student_affairs@university.edu',
                    Icons.school,
                    Colors.blue,
                  ),
                  const SizedBox(height: 16),
                  _buildResourceItem(
                    context,
                    'Learning Support Unit',
                    'Academic accommodations and learning assistance',
                    '03-7967-5000',
                    Icons.accessibility,
                    Colors.green,
                  ),
                  const SizedBox(height: 16),
                  _buildCounselorDirectoryCard(context),
                ],
              ),
            ),
            
            const SizedBox(height: 18),
            
            // Crisis Resources
            DashboardCard(
              title: '🆘 Crisis Support',
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red[200]!),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'If you\'re in immediate danger, call 999',
                          style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 148,
                          child: ElevatedButton.icon(
                          icon: const Icon(Icons.phone, color: Colors.white),
                          label: const Text('Call 999'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () {
                            // You can use url_launcher to actually call, but here just show a snackbar
                            ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Dialing 999...'),
                              duration: Duration(seconds: 2),
                            ),
                            );
                          },
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Suicide helplines:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,                          
                          ),
                        ),
                        const SizedBox(height: 4),
                        _buildCrisisContactItem(context, 'Befrienders KL', '03-7627-2929'),
                        const SizedBox(height: 4),
                        _buildCrisisContactItem(context, 'Life Line Association', '15995'),
                        const SizedBox(height: 4),
                        _buildCrisisContactItem(context, 'Malaysian Mental Health Association', '03-2780-6803'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Location-based Help (Simulated)
            DashboardCard(
              title: '📍 Local Resources',
              child: Column(
                children: [
                  _buildResourceItem(
                    context,
                    'University Health Center',
                    '500m away • Open Monday-Friday 8AM-5PM',
                    '03-7967-2000',
                    Icons.local_hospital,
                    Colors.red,
                  ),
                  const SizedBox(height: 12),
                  _buildResourceItem(
                    context,
                    'Student Mental Health Unit',
                    '300m away • Walk-in hours: 9AM-4PM',
                    'student_mental_health@university.edu',
                    Icons.psychology,
                    Colors.purple,
                  ),
                  const SizedBox(height: 12),
                  _buildResourceItem(
                    context,
                    'Campus Recreation Center',
                    '200m away • Free fitness and wellness programs',
                    '03-7967-3000',
                    Icons.fitness_center,
                    Colors.orange,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Quick Actions
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: InkWell(
                      onTap: () => _showEmergencyContacts(context),
                      borderRadius: BorderRadius.circular(16),
                      child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Icon(Icons.emergency, color: Colors.red, size: 32),
                            SizedBox(height: 8),
                            Text(
                              'Emergency\nContacts',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Card(
                    child: InkWell(
                      onTap: () => _showCampusMap(context),
                      borderRadius: BorderRadius.circular(16),
                      child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Icon(Icons.map, color: Colors.blue, size: 32),
                            SizedBox(height: 8),
                            Text(
                              'Campus\nMap',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCounselorDirectoryCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showCounselorDirectory(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.people, color: Colors.purple, size: 20),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Campus Counselor Directory',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'View available counselors and their contact details',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResourceItem(BuildContext context, String title, String description, String contact, IconData icon, Color color) {
    final isPhoneNumber = contact.startsWith('03-') ||
        contact.startsWith('01-') ||
        contact.startsWith('04-') ||
        contact.startsWith('05-') ||
        contact.startsWith('06-') ||
        contact.startsWith('07-') ||
        contact.startsWith('08-') ||
        contact.startsWith('09-');
    final isEmail = contact.contains('@');

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                description,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              if (contact.isNotEmpty)
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        contact,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (isPhoneNumber || isEmail)
                      IconButton(
                        onPressed: () => _copyToClipboard(context, contact),
                        icon: Icon(Icons.copy, size: 12, color: Colors.grey[600]),
                        tooltip: isPhoneNumber
                            ? 'Copy phone number'
                            : isEmail
                                ? 'Copy email'
                                : 'Copy',
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCrisisContactItem(BuildContext context, String name, String phoneNumber) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '$name: $phoneNumber',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        IconButton(
          onPressed: () => _copyToClipboard(context, phoneNumber),
          icon: Icon(Icons.copy, size: 16, color: Colors.grey[600]),
          tooltip: 'Copy phone number',
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied $text to clipboard'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.fixed,
      ),
    );
  }

  void _showEmergencyContacts(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Emergency Contacts'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEmergencyContactItem(context, '🚨 Emergency', '999'),
            _buildEmergencyContactItem(context, '🆘 Befrienders KL', '03-7627-2929'),
            _buildEmergencyContactItem(context, '📞 Life Line Association', '15995'),
            const SizedBox(height: 8),
            _buildEmergencyContactItem(context, 'Campus Security', '03-7967-1000'),
            _buildEmergencyContactItem(context, 'Campus Health', '03-7967-2000'),
            _buildEmergencyContactItem(context, 'Student Counseling', '03-7967-3333'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyContactItem(BuildContext context, String label, String number) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: Text('$label: $number'),
          ),
          IconButton(
            onPressed: () => _copyToClipboard(context, number),
            icon: Icon(Icons.copy, size: 16, color: Colors.grey[400]),
            tooltip: 'Copy number',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  void _showCounselorDirectory(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Campus Counselor Directory'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Available counselors and their specializations:',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              _buildCounselorItem(
                context,
                'Dr. Sarah Hamza',
                'Anxiety & Depression Specialist',
                'sarahhamza@university.edu',
              ),
              const SizedBox(height: 12),
              _buildCounselorItem(
                context,
                'Dr. Michael Tan',
                'Academic Stress & Study Skills',
                'michaeltan@university.edu',
              ),
              const SizedBox(height: 12),
              _buildCounselorItem(
                context,
                'Ms. Priya Kumar',
                'Relationship & Social Issues',
                'priyakumar@university.edu',
              ),
              const SizedBox(height: 12),
              _buildCounselorItem(
                context,
                'Dr. Ahmad Rahman',
                'Career Counseling & Life Planning',
                'ahmadrahman@university.edu',
              ),
              const SizedBox(height: 12),
              _buildCounselorItem(
                context,
                'Ms. Lisa Wong',
                'Crisis Intervention & Trauma',
                'lisa.wong@university.edu',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildCounselorItem(BuildContext context, String name, String specialization, String email) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Text(
                specialization,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                email,
                style: TextStyle(
                  color: Colors.blue[600],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => _copyToClipboard(context, email),
          icon: Icon(Icons.copy, size: 16, color: Colors.grey[600]),
          tooltip: 'Copy email',
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  void _showCampusMap(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Campus Resources Map'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('📍 Interactive campus map would show:'),
            SizedBox(height: 8),
            Text('• Health Center locations'),
            Text('• Counseling services'),
            Text('• Study spaces & library'),
            Text('• Sports & recreation facilities'),
            Text('• Prayer rooms & facilities'),
            Text('• Emergency call points'),
            Text('• Student services centers'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}