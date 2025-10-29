import 'package:flutter/material.dart';
import 'success_screen.dart'; // Import for navigation
String avatar = '';
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  //String avatar = '';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  // Avatar Selector Function
  selectAvatar(String imageLink) {
    setState((){
      avatar == imageLink;
    });

    
  }
  // Date Picker Function
  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return; // Check if the widget is still in the tree
        setState(() {
          _isLoading = false;
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SuccessScreen(userName: _nameController.text),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Your Account 🎉'),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Animated Form Header
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.tips_and_updates,
                          color: Colors.deepPurple[800]),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Complete your adventure profile!',
                          style: TextStyle(
                            color: Colors.deepPurple[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Name Field
                _buildTextField(
                  controller: _nameController,
                  label: 'Adventure Name',
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'What should we call you on this adventure?';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Email Field
                _buildTextField(
                  controller: _emailController,
                  label: 'Email Address',
                  icon: Icons.email,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'We need your email for adventure updates!';
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Oops! That doesn\'t look like a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // DOB w/Calendar
                TextFormField(
                  controller: _dobController,
                  readOnly: true,
                  onTap: _selectDate,
                  decoration: InputDecoration(
                    labelText: 'Date of Birth',
                    prefixIcon:
                        const Icon(Icons.calendar_today, color: Colors.deepPurple),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.date_range),
                      onPressed: _selectDate,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'When did your adventure begin?';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Pswd Field w/ Toggle
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Secret Password',
                    prefixIcon:
                        const Icon(Icons.lock, color: Colors.deepPurple),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.deepPurple,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Every adventurer needs a secret password!';
                    }
                    if (value.length < 6) {
                      return 'Make it stronger! At least 6 characters';
                    }
                    return null;
                  },
                ),
                
                Text('Choose your avatar!'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    GestureDetector(
                      onTap: () {
                        selectAvatar('https://tse1.mm.bing.net/th/id/OIP.gvg2MUErtAOi4RGwFzMqDQHaFj?rs=1&pid=ImgDetMain&o=7&rm=3');
                        },
                      child: Padding(padding: const EdgeInsets.all(8.0),
                        child: Image.network('https://tse1.mm.bing.net/th/id/OIP.gvg2MUErtAOi4RGwFzMqDQHaFj?rs=1&pid=ImgDetMain&o=7&rm=3',
                        width: 100,
                        height: 100)
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        selectAvatar('https://tse1.mm.bing.net/th/id/OIP.3-CyEwZ0GAgNkdBooxq2ZAHaE8?rs=1&pid=ImgDetMain&o=7&rm=3');
                        },
                      child: Padding(padding: const EdgeInsets.all(8.0),
                        child: Image.network('https://tse1.mm.bing.net/th/id/OIP.3-CyEwZ0GAgNkdBooxq2ZAHaE8?rs=1&pid=ImgDetMain&o=7&rm=3',
                        width: 100,
                        height: 100)
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        selectAvatar('https://th.bing.com/th/id/R.40f3b8a2eeb44ac9e74602622050fd55?rik=xE6MOemlfB7aZQ&riu=http%3a%2f%2f4.bp.blogspot.com%2f-zlrl70iAke0%2fUiEUN960JdI%2fAAAAAAAAAb4%2f_4mdLtwmDUU%2fs1600%2fIguana-wallpapers.jpg&ehk=efa3CfuGNDTSab8X4AlihvHSYyqMf79CgeHmIP57TB4%3d&risl=&pid=ImgRaw&r=0');
                        },
                      child: Padding(padding: const EdgeInsets.all(8.0),
                        child: Image.network('https://th.bing.com/th/id/R.40f3b8a2eeb44ac9e74602622050fd55?rik=xE6MOemlfB7aZQ&riu=http%3a%2f%2f4.bp.blogspot.com%2f-zlrl70iAke0%2fUiEUN960JdI%2fAAAAAAAAAb4%2f_4mdLtwmDUU%2fs1600%2fIguana-wallpapers.jpg&ehk=efa3CfuGNDTSab8X4AlihvHSYyqMf79CgeHmIP57TB4%3d&risl=&pid=ImgRaw&r=0',
                        width: 100,
                        height: 100,
                        )
                      ),
                    ),               
                  ]
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        selectAvatar('https://cdn.pixabay.com/photo/2024/02/28/07/42/european-shorthair-8601492_1280.jpg');
                        },
                      child: Padding(padding: const EdgeInsets.all(8.0),
                        child: Image.network('https://cdn.pixabay.com/photo/2024/02/28/07/42/european-shorthair-8601492_1280.jpg',                        
                        width: 100,
                        height: 100)
                      ),
                    ), 
                    GestureDetector(
                      onTap: () {
                        selectAvatar('https://th.bing.com/th/id/R.cd68cba8680e3406758fdbf33cf67a15?rik=gHIJ3UMneL3lOw&riu=http%3a%2f%2fwallup.net%2fwp-content%2fuploads%2f2016%2f01%2f201579-animals-fish-sea-shark.jpg&ehk=xm4MS4jP%2fD5IVHtnf1JjiZWggkbHRn2pjtzwBMbjAwA%3d&risl=&pid=ImgRaw&r=0');
                        },
                      child: Padding(padding: const EdgeInsets.all(8.0),
                        child: Image.network('https://th.bing.com/th/id/R.cd68cba8680e3406758fdbf33cf67a15?rik=gHIJ3UMneL3lOw&riu=http%3a%2f%2fwallup.net%2fwp-content%2fuploads%2f2016%2f01%2f201579-animals-fish-sea-shark.jpg&ehk=xm4MS4jP%2fD5IVHtnf1JjiZWggkbHRn2pjtzwBMbjAwA%3d&risl=&pid=ImgRaw&r=0',
                        width: 100,
                        height: 100)
                      ),
                    ),               
                  ],
                ),
                const SizedBox(height: 30),

                // Submit Button w/ Loading Animation
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: _isLoading ? 60 : double.infinity,
                  height: 60,
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.deepPurple),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 5,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Start My Adventure',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                              SizedBox(width: 10),
                              Icon(Icons.rocket_launch, color: Colors.white),
                            ],
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: validator,
    );
  }
}
