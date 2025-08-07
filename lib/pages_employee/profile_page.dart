// User > Profile Page
import 'package:flutter/material.dart';


class ProfilePage extends StatefulWidget {
  final String? username;

  const ProfilePage({super.key, this.username});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String userName;
  int position = 10;

  @override
  void initState() {
    super.initState();
    userName = widget.username ?? "John Paul";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 255, 181, 96),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(),
              const SizedBox(height: 20),
              const InfoTile(
                title: 'Personal Background',
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InfoText(label: 'Last Name', value: 'Polendey'),
                    InfoText(label: 'First Name', value: 'John Paul'),
                    InfoText(label: 'Middle Name', value: 'Delos Reyes'),
                    InfoText(label: 'Suffix', value: 'N/A'),
                    InfoText(label: 'Nickname', value: 'JP'),
                    InfoText(label: 'Birthday', value: 'Nov 26'),
                    InfoText(label: 'Age', value: 'Secret'),
                    InfoText(
                      label: 'Place of birth',
                      value: 'Badoc, Ilocos Norte',
                    ),
                    InfoText(label: 'Civil Status', value: 'Single'),
                    InfoText(
                      label: 'Company E-mail addr',
                      value: 'creatives03@kelinph.com',
                    ),
                    InfoText(
                      label: 'Personal E-mail addr',
                      value: 'johnpaulpolendey22@gmail.com',
                    ),
                    InfoText(label: 'Mobile Number', value: ''),
                    InfoText(
                      label: 'Permanent Address',
                      value: 'Caloocan City',
                    ),
                    InfoText(label: 'Temporary Address', value: 'N/A'),
                  ],
                ),
              ),
              const InfoTile(
                title: 'Family',
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InfoText(
                      label: 'Mother',
                      value: 'Maribel Delos Reyes\nContact: 0917-123-4567',
                    ),
                    InfoText(
                      label: 'Father',
                      value: 'Mark Zuckerberg\nContact: 0918-987-6543',
                    ),
                    InfoText(
                      label: 'Brother',
                      value: 'Christian Polendey\nContact: 0922-456-7890',
                    ),
                  ],
                ),
              ),
              const InfoTile(
                title: 'Education',
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InfoText(label: 'Doctorate Degree', value: 'N/A'),
                    InfoText(label: 'Master Degree', value: 'N/A'),
                    InfoText(label: 'College', value: 'UCC'),
                    InfoText(label: 'SHS', value: 'OLFU'),
                    InfoText(label: 'High School', value: 'BHS'),
                    InfoText(label: 'Elementary', value: 'Pilar'),
                  ],
                ),
              ),
              const InfoTile(
                title: 'ID/Bank Information',
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InfoText(
                      label: 'Bank Account Name',
                      value: 'John Paul D. Polendey',
                    ),
                    InfoText(
                      label: 'Bank Account No.',
                      value: '**** **** **** ****',
                    ),
                    InfoText(label: 'TIN', value: '123-456-789'),
                    InfoText(label: 'SSS', value: '01-2345678-9'),
                    InfoText(label: 'PhilHealth', value: '12-345678901-2'),
                    InfoText(label: 'Pag-IBIG', value: '1234-5678-9012'),
                    InfoText(label: 'UMID', value: 'UMID-2023-0000123'),
                  ],
                ),
              ),
              const InfoTile(
                title: 'Employee Information',
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InfoText(label: 'EE ID', value: 'KG-0751'),
                    InfoText(label: 'Position', value: 'Front-End Dev.'),
                    InfoText(label: 'Department', value: 'MIS'),
                    InfoText(label: 'Date Hired', value: '08 - 13 - 2024'),
                    InfoText(label: 'Date Regular', value: '01 - 09 - 2025'),
                    InfoText(label: 'Employment Status', value: 'Regular'),
                    InfoText(
                      label: 'Immediate Supervisor',
                      value: 'Joyce S. Cambel',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 253, 231, 227),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color.fromARGB(255, 251, 216, 187)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage('assets/profile.jpg'),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Position: $position',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class InfoTile extends StatefulWidget {
  final String title;
  final Widget content;

  const InfoTile({super.key, required this.title, required this.content});

  @override
  State<InfoTile> createState() => _InfoTileState();
}

class _InfoTileState extends State<InfoTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color.fromARGB(255, 251, 216, 187)),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            widget.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 243, 110, 33),
            ),
          ),
          onExpansionChanged: (expanded) {
            setState(() {
              _isExpanded = expanded;
            });
          },
          trailing: Icon(
            _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: const Color.fromARGB(255, 243, 110, 33),
          ),
          childrenPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          children: [widget.content],
        ),
      ),
    );
  }
}

class InfoText extends StatelessWidget {
  final String label;
  final String value;

  const InfoText({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    if (value.trim().isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87, height: 1.2),
            ),
          ),
        ],
      ),
    );
  }
}
