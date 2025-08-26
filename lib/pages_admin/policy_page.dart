import 'package:flutter/material.dart';

class PolicyPage extends StatelessWidget {
  final bool showAppBar;
  final String? userRole; // Add user role parameter
  
  const PolicyPage({super.key, this.showAppBar = true, this.userRole});

  // Helper method to check if user is admin
  bool get _isAdmin {
    return userRole?.toLowerCase().trim() == 'admin';
  }

  // Get policy content based on the title
  String _getPolicyContent(String title) {
    switch (title) {
      case 'HR Policies':
        return 'Kelin Graphics System HR Policies outline employment rules, recruitment practices, benefits administration, performance reviews, and termination procedures. These policies ensure fairness and compliance with applicable labor laws. They include guidance on working hours, leave entitlements, salary administration, and grievance procedures.\n\nEmployees are expected to familiarize themselves with these policies and direct any questions to the HR department. Policy updates are communicated via email and the company intranet.';
      case 'Decorum':
        return 'The Kelin Graphics System Decorum sets expectations for professional behavior, ethical decision making, and respect in the workplace. Employees must avoid conflicts of interest, maintain confidentiality, and behave respectfully toward colleagues, clients, and vendors. Violations may result in disciplinary action.\n\nOur core values of integrity, respect, and excellence guide all employee interactions. We have zero tolerance for harassment, discrimination, or unethical business practices.';
      case 'Security':
        return 'Security policies at Kelin Graphics System cover workplace safety protocols, emergency procedures, incident reporting, and building access control. We are committed to maintaining a safe environment by providing training, PPE when necessary, and regular safety audits.\n\nAll employees are required to complete annual safety training and report hazards or incidents immediately. Our security protocols include badge access systems, visitor management, and regular security drills.';
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
      case 'Culture':
        return 'Kelin Graphics System fosters a collaborative and inclusive work culture where creativity thrives and every team member feels valued. We promote open communication, continuous learning, and work-life balance.\n\nOur culture initiatives include:\n• Regular team building activities\n• Flexible work arrangements\n• Professional development opportunities\n• Recognition and reward programs\n• Diversity and inclusion initiatives\n\nWe believe that a positive culture drives innovation and success.';
      case 'Training':
        return 'Kelin Graphics System is committed to continuous learning and professional development. Our comprehensive training programs cover technical skills, soft skills, and career advancement opportunities.\n\nTraining programs include:\n• Onboarding for new employees\n• Technical skill development\n• Leadership training\n• Industry certifications\n• Cross-functional training\n• External conferences and workshops\n\nWe invest in our people to ensure they have the tools and knowledge needed to excel in their roles.';
      case 'Quality':
        return 'Quality is at the heart of everything we do at Kelin Graphics System. Our quality management system ensures consistent delivery of exceptional products and services that exceed client expectations.\n\nOur quality standards include:\n• Rigorous quality control processes\n• Continuous improvement initiatives\n• Client feedback integration\n• Regular quality audits\n• Industry best practices\n• ISO certification compliance\n\nWe are committed to maintaining the highest standards of quality in all our deliverables.';
      default:
        return 'This policy contains important information about company expectations and procedures. For more details, contact the HR department.';
    }
  }

  // Show policy edit dialog for admin users
  void _showEditPolicyDialog(BuildContext context, String title) {
    if (!_isAdmin) {
      return;
    }
    
    final TextEditingController controller = TextEditingController();
    controller.text = _getPolicyContent(title);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.edit, color: Theme.of(context).primaryColor),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Edit Policy: $title',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: TextField(
            controller: controller,
            maxLines: null,
            expands: true,
            textAlignVertical: TextAlignVertical.top,
            decoration: const InputDecoration(
              hintText: 'Enter policy content...',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Policy "$title" updated successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
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
                  // Admin edit button
                  if (_isAdmin)
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark 
                            ? Colors.grey[800]
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context).brightness == Brightness.dark 
                              ? Colors.grey[600]!
                              : Colors.grey[300]!,
                        ),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Theme.of(context).brightness == Brightness.dark 
                              ? Colors.white
                              : Colors.grey[700],
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _showEditPolicyDialog(context, title);
                        },
                        tooltip: 'Edit Policy',
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
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: Theme.of(context).brightness == Brightness.dark
                    ? [
                        Color(0xFF2A2A3A),
                        Color(0xFF1E1E28),
                      ]
                    : [
                        Colors.blue.shade50,
                        Colors.indigo.shade50,
                      ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[700]!
                    : Colors.grey[200]!,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.policy,
                    size: 40,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Corporate Policy',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.blue,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Company policies and guidelines',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[300]
                        : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Company Overview Section
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Center(
              child: Text(
                'Company Overview',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.blue,
                ),
              ),
            ),
          ),

          // Company Overview Cards (Vision, Mission, Values) - Grid layout for better spacing
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.9,  // Make cards much larger to occupy more space
            children: [
              _buildPolicyCard(
                context,
                'Vision',
                'Company vision',
                Icons.visibility,
                Colors.indigo,
              ),
              _buildPolicyCard(
                context,
                'Mission',
                'Company mission',
                Icons.flag,
                Colors.amber,
              ),
              _buildPolicyCard(
                context,
                'Values',
                'Core values and principles',
                Icons.star,
                Colors.deepPurple,
              ),
              _buildPolicyCard(
                context,
                'Culture',
                'Company culture',
                Icons.group,
                Colors.pink,
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Policy Categories Section
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Center(
              child: Text(
                'Policy Categories',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.orange,
                ),
              ),
            ),
          ),

          // Policy Categories Grid (2x4 layout for better spacing)
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.9,  // Make cards much larger to occupy more space
            children: [
              _buildPolicyCard(
                context,
                'HR Policies',
                'Human Resources policies and procedures',
                Icons.people_outline,
                Colors.blue,
              ),
              _buildPolicyCard(
                context,
                'Decorum',
                'Code of Conduct',
                Icons.rule,
                Colors.green,
              ),
              _buildPolicyCard(
                context,
                'Security',
                'Security policies and procedures',
                Icons.security,
                Colors.red,
              ),
              _buildPolicyCard(
                context,
                'IT Policies',
                'IT policies and guidelines',
                Icons.computer,
                Colors.purple,
              ),
              _buildPolicyCard(
                context,
                'Leave Policy',
                'Leave policies and procedures',
                Icons.event_available,
                Colors.orange,
              ),
              _buildPolicyCard(
                context,
                'Benefits',
                'Employee benefits and perks',
                Icons.card_giftcard,
                Colors.teal,
              ),
              _buildPolicyCard(
                context,
                'Training',
                'Employee training and development policies',
                Icons.school,
                Colors.brown,
              ),
              _buildPolicyCard(
                context,
                'Quality',
                'Quality assurance policies and procedures',
                Icons.verified,
                Colors.indigo,
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
    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          elevation: 2,
          shadowColor: color.withOpacity(0.3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: InkWell(
            onTap: () => _showPolicyDetails(context, title, subtitle, icon, color),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[850]
                    : Colors.grey[50],
                border: Border.all(
                  color: color.withOpacity(0.3),
                  width: 1.5,
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.withOpacity(0.05),
                    color.withOpacity(0.02),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.all(constraints.maxHeight * 0.06),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.all(constraints.maxHeight * 0.05),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(icon, size: constraints.maxHeight * 0.12, color: color),
                            ),
                            // Admin edit button in the same row as icon
                            if (_isAdmin)
                              InkWell(
                                onTap: () => _showEditPolicyDialog(context, title),
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: EdgeInsets.all(constraints.maxHeight * 0.04),
                                  decoration: BoxDecoration(
                                    color: color.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: color.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.edit,
                                    size: constraints.maxHeight * 0.08,
                                    color: color,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: constraints.maxHeight * 0.05),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: constraints.maxHeight * 0.09,
                            color: Theme.of(context).brightness == Brightness.dark 
                                ? Colors.white
                                : Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: constraints.maxHeight * 0.03),
                        Expanded(
                          child: Center(
                            child: Text(
                              subtitle,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).brightness == Brightness.dark 
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                                fontSize: constraints.maxHeight * 0.07,
                                height: 1.4,
                              ),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
