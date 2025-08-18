import 'package:flutter/material.dart';

class PolicyPage extends StatelessWidget {
  final bool showAppBar;
  
  const PolicyPage({super.key, this.showAppBar = true});

  // Get policy content based on the title
  String _getPolicyContent(String title) {
    switch (title) {
      case 'HR Policies':
        return 'Kelin Graphics System HR Policies outline employment rules, recruitment practices, benefits administration, performance reviews, and termination procedures. These policies ensure fairness and compliance with applicable labor laws. They include guidance on working hours, leave entitlements, salary administration, and grievance procedures.\n\nEmployees are expected to familiarize themselves with these policies and direct any questions to the HR department. Policy updates are communicated via email and the company intranet.';
      case 'Code of Conduct':
        return 'The Kelin Graphics System Code of Conduct sets expectations for professional behavior, ethical decision making, and respect in the workplace. Employees must avoid conflicts of interest, maintain confidentiality, and behave respectfully toward colleagues, clients, and vendors. Violations may result in disciplinary action.\n\nOur core values of integrity, respect, and excellence guide all employee interactions. We have zero tolerance for harassment, discrimination, or unethical business practices.';
      case 'Safety & Security':
        return 'Safety & Security policies at Kelin Graphics System cover workplace safety protocols, emergency procedures, incident reporting, and building access control. We are committed to maintaining a safe environment by providing training, PPE when necessary, and regular safety audits.\n\nAll employees are required to complete annual safety training and report hazards or incidents immediately. Our security protocols include badge access systems, visitor management, and regular security drills.';
      case 'IT Policies':
        return 'Kelin Graphics System IT Policies describe acceptable use of company systems, password management, data protection, and guidelines for using personal devices for work. These policies protect company data and ensure secure, reliable access to IT resources.\n\nEmployees must use strong passwords, enable two-factor authentication, and follow data classification guidelines. Regular security awareness training is mandatory for all staff to protect against cyber threats.';
      case 'Leave Policy':
        return 'The Kelin Graphics System Leave Policy explains types of leave available (annual, sick, maternity, paternity, emergency), eligibility, application process, and approval criteria. It also covers unpaid leave, documentation requirements, and how leave affects payroll and benefits.\n\nEmployees should submit leave requests at least two weeks in advance when possible. Unused annual leave policies and carryover limits are detailed in the employee handbook.';
      case 'Benefits':
        return 'Kelin Graphics System benefits include comprehensive health insurance, retirement plans, paid time off, employee assistance programs, and professional development opportunities. Details include eligibility, enrollment periods, and how benefits are administered.\n\nOur benefits package is designed to support employee wellbeing and work-life balance. Additional perks include flexible work arrangements, wellness programs, and employee recognition initiatives.';
      case 'Vision':
        return 'At Kelin Graphics System, our vision is to be the leading creative partner delivering innovative graphic solutions that empower our clients to communicate their stories effectively. We aspire to set industry standards for design excellence, technological innovation, and client satisfaction.\n\nWe envision a workplace where creativity flourishes, talents are nurtured, and every team member contributes to our collective success. Our long-term vision includes expanding our services globally while maintaining the personalized approach that has built our reputation.';
      case 'Mission':
        return 'Kelin Graphics System delivers creative excellence through skilled professionals, robust processes, and a culture of continuous improvement. Our mission is to transform clients\' ideas into impactful visual communications that drive business success.\n\nWe are committed to:\n• Providing exceptional quality and service\n• Fostering innovation and creative thinking\n• Investing in our team\'s professional growth\n• Practicing sustainable design and production methods\n• Building long-term client relationships based on trust and mutual success';
      case 'Values':
        return 'Our core values guide everything we do at Kelin Graphics System:\n\n• Innovation: We embrace creative thinking and technological advancement\n• Excellence: We strive for the highest quality in all our work\n• Integrity: We conduct business ethically and transparently\n• Collaboration: We achieve more by working together\n• Respect: We value diversity and treat everyone with dignity\n\nThese values shape our culture and inform our decision-making at every level of the organization.';
      default:
        return 'This policy contains important information about company expectations and procedures. For more details, contact the HR department.';
    }
  }

  // Show policy details in a modal bottom sheet
  void _showPolicyDetails(BuildContext context, String title, String subtitle, IconData icon, Color color) {
    final content = _getPolicyContent(title);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark 
              ? Color(0xFF1E1E28) 
              : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Drag handle
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark 
                    ? Colors.grey[600]
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: color, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Theme.of(context).brightness == Brightness.dark 
                                ? Colors.white
                                : Colors.black87,
                          ),
                        ),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.dark 
                                ? Colors.grey[300]
                                : Colors.grey[700],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            
            const Divider(),
            
            // Company name
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                children: [
                  Icon(Icons.business, color: Theme.of(context).primaryColor),
                  const SizedBox(width: 8),
                  Text(
                    'Kelin Graphics System',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Theme.of(context).brightness == Brightness.dark 
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Last updated: Aug 2025',
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark 
                          ? Colors.grey[400]
                          : Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            
            // Policy content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Text(
                  content,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: Theme.of(context).brightness == Brightness.dark 
                        ? Colors.white
                        : Colors.black87,
                  ),
                ),
              ),
            ),
            
            // Action button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).brightness == Brightness.dark 
                  ? Color(0xFF1E1E28)
                  : Colors.white,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Placeholder for downloading full policy
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Full policy document would download here')),
                  );
                },
                icon: const Icon(Icons.download),
                label: const Text('Download Full Policy Document'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  elevation: 3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    Widget bodyContent = SingleChildScrollView(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Company Overview Cards
          Row(
            children: [
              Expanded(
                child: _buildPolicyCard(
                  context,
                  'Vision',
                  'Our aspirations',
                  Icons.visibility,
                  Colors.indigo,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildPolicyCard(
                  context,
                  'Mission',
                  'Our purpose',
                  Icons.flag,
                  Colors.amber,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Values card
          _buildPolicyCard(
            context,
            'Values',
            'Our guiding principles',
            Icons.star,
            Colors.deepPurple,
          ),
          
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'Policy Categories',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),

          // Policy Categories Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.2,
            children: [
              _buildPolicyCard(
                context,
                'HR Policies',
                'Employment rules',
                Icons.people_outline,
                Colors.blue,
              ),
              _buildPolicyCard(
                context,
                'Code of Conduct',
                'Behavioral guidelines',
                Icons.rule,
                Colors.green,
              ),
              _buildPolicyCard(
                context,
                'Safety & Security',
                'Workplace safety',
                Icons.security,
                Colors.red,
              ),
              _buildPolicyCard(
                context,
                'IT Policies',
                'Technology usage',
                Icons.computer,
                Colors.purple,
              ),
              _buildPolicyCard(
                context,
                'Leave Policy',
                'Time off rules',
                Icons.event_available,
                Colors.orange,
              ),
              _buildPolicyCard(
                context,
                'Benefits',
                'Employee benefits',
                Icons.card_giftcard,
                Colors.teal,
              ),
            ],
          ),
        ],
      ),
    );

    if (!showAppBar) {
      return bodyContent;
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.policy, 
                 color: colorScheme.onPrimaryContainer, 
                 size: 24),
            const SizedBox(width: 8),
            const Text('Corporate Policy'),
          ],
        ),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: bodyContent,
    );
  }

  Widget _buildPolicyCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showPolicyDetails(context, title, subtitle, icon, color),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
