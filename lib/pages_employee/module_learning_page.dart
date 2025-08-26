import 'package:flutter/material.dart';

class ModuleLearningPage extends StatefulWidget {
  final Map<String, dynamic> module;

  const ModuleLearningPage({super.key, required this.module});

  @override
  State<ModuleLearningPage> createState() => _ModuleLearningPageState();
}

class _ModuleLearningPageState extends State<ModuleLearningPage> {
  PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isCompleted = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _getLearningContent() {
    // Generate content based on module type
    switch (widget.module['id']) {
      case 1: // Company Policies
        return [
          {
            'title': 'Welcome to Company Policies Training',
            'content': 'This comprehensive training will guide you through our essential company policies and procedures. Understanding these policies ensures a safe, productive, and inclusive workplace for everyone.',
            'type': 'intro',
            'icon': Icons.policy,
          },
          {
            'title': 'Company Mission & Values',
            'content': '''Our Mission: To deliver exceptional value to clients through innovative solutions and outstanding service.

Core Values:
• Integrity - We conduct business with honesty and transparency
• Excellence - We strive for the highest quality in everything we do
• Innovation - We embrace change and seek creative solutions
• Collaboration - We work together to achieve common goals
• Respect - We value diversity and treat everyone with dignity''',
            'type': 'content',
            'icon': Icons.business,
          },
          {
            'title': 'Code of Conduct',
            'content': '''Professional Behavior:
• Treat all colleagues, clients, and partners with respect
• Maintain confidentiality of sensitive information
• Avoid conflicts of interest
• Report unethical behavior promptly

Communication Guidelines:
• Use professional language in all communications
• Respect different perspectives and opinions
• Practice active listening
• Provide constructive feedback''',
            'type': 'content',
            'icon': Icons.handshake,
          },
          {
            'title': 'Workplace Policies',
            'content': '''Dress Code:
• Business professional for client meetings
• Business casual for regular office days
• Casual Fridays allowed with appropriate attire

Work Hours:
• Standard hours: 8:00 AM - 5:00 PM
• Flexible arrangements available with approval
• Break times: 15 minutes mid-morning and mid-afternoon
• Lunch: 1-hour break''',
            'type': 'content',
            'icon': Icons.work,
          },
          {
            'title': 'Information Security',
            'content': '''Confidentiality:
• Handle all company information as confidential
• Share information only on a need-to-know basis
• Secure all physical and digital documents
• Report security breaches immediately

Data Protection:
• Use strong passwords for all accounts
• Lock your computer when away from desk
• Do not share login credentials
• Follow clean desk policy''',
            'type': 'content',
            'icon': Icons.security,
          },
          {
            'title': 'Key Takeaways',
            'content': '''Remember:
✓ Our mission guides all our decisions
✓ Core values shape our behavior
✓ Professional conduct is essential
✓ Confidentiality must be maintained
✓ Questions should always be asked

You are now ready to apply these policies in your daily work. Thank you for completing this training!''',
            'type': 'summary',
            'icon': Icons.check_circle,
          },
        ];
      case 2: // Workplace Safety
        return [
          {
            'title': 'Workplace Safety Training',
            'content': 'Safety is our top priority. This training will equip you with essential knowledge to maintain a safe work environment and respond appropriately to emergencies.',
            'type': 'intro',
            'icon': Icons.security,
          },
          {
            'title': 'Fire Safety Procedures',
            'content': '''Prevention:
• Keep fire exits clear at all times
• Report faulty electrical equipment immediately
• Store flammable materials properly
• Do not overload electrical outlets

In Case of Fire:
1. Alert others immediately
2. Evacuate via nearest exit
3. Call emergency services
4. Meet at designated assembly point
5. Do not use elevators''',
            'type': 'content',
            'icon': Icons.local_fire_department,
          },
          {
            'title': 'Fire Extinguisher Use - PASS Technique',
            'content': '''Remember PASS:
P - Pull the pin
A - Aim at the base of the fire
S - Squeeze the handle
S - Sweep from side to side

Important:
• Only fight small fires
• Always have an escape route
• Call fire department even for small fires
• Never turn your back on a fire''',
            'type': 'content',
            'icon': Icons.fire_extinguisher,
          },
          {
            'title': 'Emergency Procedures',
            'content': '''Medical Emergencies:
• Call 911 immediately
• Notify first aid trained personnel
• Do not move injured person unless necessary
• Stay with victim until help arrives

Natural Disasters:
• Follow evacuation procedures
• Stay calm and help others
• Listen to emergency personnel
• Report to assembly areas''',
            'type': 'content',
            'icon': Icons.emergency,
          },
          {
            'title': 'Workplace Hazards',
            'content': '''Common Hazards:
• Wet floors - report spills immediately
• Blocked exits - keep clear at all times
• Faulty equipment - report and tag out
• Poor lighting - report to maintenance

Prevention:
• Maintain clean work areas
• Use proper lifting techniques
• Wear appropriate safety equipment
• Report unsafe conditions promptly''',
            'type': 'content',
            'icon': Icons.warning,
          },
          {
            'title': 'Safety Commitment',
            'content': '''Your Safety Responsibilities:
✓ Follow all safety procedures
✓ Report hazards immediately
✓ Use safety equipment properly
✓ Help maintain a safe environment
✓ Look out for your colleagues

Remember: Safety is everyone's responsibility. When in doubt, ask for help!''',
            'type': 'summary',
            'icon': Icons.verified_user,
          },
        ];
      case 3: // Diversity and Inclusion
        return [
          {
            'title': 'Building an Inclusive Workplace',
            'content': 'Diversity and inclusion are fundamental to our success. This training will help you understand how to create an environment where everyone feels valued and can contribute their best.',
            'type': 'intro',
            'icon': Icons.diversity_3,
          },
          {
            'title': 'Understanding Diversity',
            'content': '''Diversity includes:
• Race and ethnicity
• Gender and gender identity
• Age and generation
• Religion and beliefs
• Sexual orientation
• Physical and mental abilities
• Background and experiences
• Perspectives and ideas

Benefits:
• Enhanced creativity and innovation
• Better decision making
• Improved problem solving
• Increased employee engagement''',
            'type': 'content',
            'icon': Icons.groups,
          },
          {
            'title': 'Unconscious Bias',
            'content': '''What is Unconscious Bias?
Automatic preferences or prejudices that influence our decisions without our awareness.

Common Types:
• Confirmation bias - seeking information that confirms our beliefs
• Halo effect - letting one positive trait influence overall opinion
• Similarity bias - favoring people like ourselves
• Attribution bias - making assumptions about others' motivations

Impact:
• Affects hiring and promotion decisions
• Influences team dynamics
• Limits diverse perspectives''',
            'type': 'content',
            'icon': Icons.psychology,
          },
          {
            'title': 'Inclusive Behaviors',
            'content': '''Practice Inclusion by:
• Listening actively to different perspectives
• Speaking up against inappropriate comments
• Using inclusive language
• Sharing opportunities fairly
• Mentoring diverse colleagues
• Celebrating different backgrounds

Avoid:
• Making assumptions based on appearance
• Using stereotypes or generalizations
• Interrupting or dismissing others
• Making insensitive jokes or comments''',
            'type': 'content',
            'icon': Icons.handshake,
          },
          {
            'title': 'Creating Inclusive Teams',
            'content': '''Team Leaders Should:
• Set clear expectations for inclusive behavior
• Ensure all voices are heard in meetings
• Address bias when observed
• Provide equal development opportunities
• Celebrate diverse achievements

Team Members Should:
• Respect different working styles
• Ask questions to understand different perspectives
• Offer help and support to all colleagues
• Participate in diversity initiatives''',
            'type': 'content',
            'icon': Icons.people,
          },
          {
            'title': 'Your Inclusion Commitment',
            'content': '''Moving Forward:
✓ Recognize and address your own biases
✓ Create inclusive experiences for others
✓ Speak up against discrimination
✓ Embrace different perspectives
✓ Continue learning about diversity

Together, we can build a workplace where everyone thrives!''',
            'type': 'summary',
            'icon': Icons.favorite,
          },
        ];
      case 4: // Cybersecurity
        return [
          {
            'title': 'Cybersecurity Basics',
            'content': 'Cybersecurity is everyone\'s responsibility. This training will teach you essential practices to protect our company and your personal information from cyber threats.',
            'type': 'intro',
            'icon': Icons.security,
          },
          {
            'title': 'Password Security',
            'content': '''Strong Password Requirements:
• At least 12 characters long
• Mix of uppercase and lowercase letters
• Include numbers and special characters
• Avoid personal information
• Unique for each account

Best Practices:
• Use password managers
• Enable two-factor authentication
• Never share passwords
• Change passwords if compromised
• Use passphrases for memorable security''',
            'type': 'content',
            'icon': Icons.lock,
          },
          {
            'title': 'Recognizing Phishing',
            'content': '''Warning Signs:
• Urgent or threatening language
• Requests for sensitive information
• Suspicious sender addresses
• Generic greetings ("Dear Customer")
• Unexpected attachments or links
• Grammar and spelling errors

What to Do:
• Do not click links or download attachments
• Verify sender through separate communication
• Report suspicious emails to IT
• Delete the email after reporting''',
            'type': 'content',
            'icon': Icons.phishing,
          },
          {
            'title': 'Data Protection',
            'content': '''Protecting Company Data:
• Classify information appropriately
• Use secure file sharing methods
• Encrypt sensitive documents
• Follow clean desk policy
• Secure devices when unattended

Personal Data:
• Limit personal information sharing
• Be cautious on social media
• Protect customer information
• Report data breaches immediately''',
            'type': 'content',
            'icon': Icons.folder_shared,
          },
          {
            'title': 'Safe Computing Practices',
            'content': '''Daily Habits:
• Keep software updated
• Use approved applications only
• Scan files before opening
• Back up important data regularly
• Log out when finished

Remote Work Security:
• Use secure Wi-Fi connections
• Keep devices physically secure
• Use VPN for company access
• Avoid public computers for work''',
            'type': 'content',
            'icon': Icons.computer,
          },
          {
            'title': 'Cybersecurity Mindset',
            'content': '''Key Principles:
✓ Think before you click
✓ Verify before you trust
✓ Report suspicious activity
✓ Keep security top of mind
✓ Stay informed about new threats

Remember: You are the first line of defense against cyber threats!''',
            'type': 'summary',
            'icon': Icons.shield,
          },
        ];
      case 5: // Customer Service
        return [
          {
            'title': 'Customer Service Excellence',
            'content': 'Exceptional customer service is the foundation of our success. This training will help you deliver outstanding experiences that build lasting relationships.',
            'type': 'intro',
            'icon': Icons.support_agent,
          },
          {
            'title': 'Understanding Customer Needs',
            'content': '''Active Listening:
• Give customers your full attention
• Ask clarifying questions
• Summarize what you heard
• Show empathy and understanding
• Take notes of important details

Customer Expectations:
• Quick response times
• Knowledgeable assistance
• Professional treatment
• Problem resolution
• Follow-through on commitments''',
            'type': 'content',
            'icon': Icons.hearing,
          },
          {
            'title': 'Communication Excellence',
            'content': '''Verbal Communication:
• Use clear, professional language
• Speak at appropriate pace and volume
• Show enthusiasm and positivity
• Avoid jargon and technical terms
• Confirm understanding

Non-Verbal Communication:
• Maintain eye contact
• Use open body language
• Smile genuinely
• Show active engagement
• Respect personal space''',
            'type': 'content',
            'icon': Icons.chat,
          },
          {
            'title': 'Handling Difficult Situations',
            'content': '''De-escalation Techniques:
• Stay calm and composed
• Listen without interrupting
• Acknowledge their feelings
• Apologize for their frustration
• Focus on solutions

Problem-Solving Process:
1. Understand the issue completely
2. Explore possible solutions
3. Explain options clearly
4. Implement agreed solution
5. Follow up to ensure satisfaction''',
            'type': 'content',
            'icon': Icons.psychology,
          },
          {
            'title': 'Building Customer Relationships',
            'content': '''Trust Building:
• Be honest and transparent
• Keep promises and commitments
• Admit when you don't know something
• Take ownership of issues
• Show genuine care for their success

Exceeding Expectations:
• Anticipate customer needs
• Provide proactive updates
• Offer additional value
• Remember personal details
• Go the extra mile when possible''',
            'type': 'content',
            'icon': Icons.handshake,
          },
          {
            'title': 'Service Excellence Commitment',
            'content': '''Your Service Standards:
✓ Respond promptly to all inquiries
✓ Listen actively and show empathy
✓ Provide accurate information
✓ Follow up on commitments
✓ Continuously improve your skills

Every interaction is an opportunity to create a positive experience!''',
            'type': 'summary',
            'icon': Icons.star,
          },
        ];
      default:
        return [
          {
            'title': 'Training Module',
            'content': 'Welcome to this training module. The content will be loaded based on the specific module requirements.',
            'type': 'intro',
            'icon': Icons.school,
          },
        ];
    }
  }

  void _nextPage() {
    final content = _getLearningContent();
    if (_currentPage < content.length - 1) {
      setState(() {
        _currentPage++;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      setState(() {
        _isCompleted = true;
      });
      _showCompletionDialog();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.celebration, color: widget.module['color']),
            const SizedBox(width: 8),
            const Text('Training Completed!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle,
              size: 64,
              color: widget.module['color'],
            ),
            const SizedBox(height: 16),
            Text(
              'Congratulations! You have successfully completed the ${widget.module['title']} training.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            if (widget.module['hasQuiz'] == true)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.quiz, color: Colors.orange),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Take the quiz to test your knowledge and earn your certificate!',
                        style: TextStyle(color: Colors.orange[700]),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Return to training page
            },
            child: const Text('Back to Training'),
          ),
          if (widget.module['hasQuiz'] == true)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context, true); // Return to training page with completion flag
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: const Text('Take Quiz'),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = _getLearningContent();
    final currentContent = content[_currentPage];
    final progress = (_currentPage + 1) / content.length;
    final moduleColor = widget.module['color'] ?? Colors.blue;

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.module['title']} - Learning'),
        backgroundColor: moduleColor.withOpacity(0.1),
        foregroundColor: moduleColor,
      ),
      body: Column(
        children: [
          // Progress Bar
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Page ${_currentPage + 1} of ${content.length}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: moduleColor,
                      ),
                    ),
                    Text(
                      '${(progress * 100).round()}% Complete',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(moduleColor),
                  minHeight: 6,
                ),
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: content.length,
              itemBuilder: (context, index) {
                final pageContent = content[index];
                return _buildContentPage(pageContent, moduleColor);
              },
            ),
          ),
          
          // Navigation Buttons
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                if (_currentPage > 0)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _previousPage,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Previous'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                
                if (_currentPage > 0) const SizedBox(width: 16),
                
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _nextPage,
                    icon: Icon(_currentPage == content.length - 1
                        ? Icons.check_circle
                        : Icons.arrow_forward),
                    label: Text(_currentPage == content.length - 1
                        ? 'Complete'
                        : 'Next'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: moduleColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentPage(Map<String, dynamic> content, Color moduleColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  moduleColor.withOpacity(0.1),
                  moduleColor.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: moduleColor.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                Icon(
                  content['icon'] ?? Icons.school,
                  size: 48,
                  color: moduleColor,
                ),
                const SizedBox(height: 16),
                Text(
                  content['title'],
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: moduleColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Content
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              content['content'],
              style: const TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Colors.black87,
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Additional Info for Summary Type
          if (content['type'] == 'summary')
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.lightbulb, color: Colors.green[700]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'You\'re now ready to apply what you\'ve learned! Click "Complete" to finish this training module.',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          
          // Reading Time Estimate
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                'Estimated reading time: 2-3 minutes',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
