import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'success_screen.dart'; // Import for navigation

// global variables for displaying images in success_screen.dart
String avatar = '';
bool spmBadge = false;
bool tebsBadge = false;
bool pcBadge = true;

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
  double passwordStrength = 0.0;
  double _progress = 0.0;
  late ConfettiController _confettiController;
  String _message = "Let's get started!";

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  

  // Listen for text field changes
    for (final controller in {_nameController, _emailController, _passwordController, _dobController}) {
      controller.addListener(_updateProgress);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  /// Updates progress based on how many fields are non-empty
  void _updateProgress() {
    final filledCount =
        {_nameController, _emailController, _passwordController, _dobController}.where((c) => c.text.trim().isNotEmpty).length;
    final total = {_nameController, _emailController, _passwordController, _dobController}.length;
    final newProgress = filledCount / total;

    if (newProgress != _progress) {
      setState(() => _progress = newProgress);
      _checkMilestone(newProgress);
    }
  }

  void _checkMilestone(double progress) {
    if (progress == 0.25) {
      _showCelebration("Great start! 🎉 You’re 25% done!");
    } else if (progress == 0.5) {
      _showCelebration("Halfway there! 🚀");
    } else if (progress == 0.75) {
      _showCelebration("Almost done! 🌟 Keep it up!");
    } else if (progress == 1.0) {
      _showCelebration("You did it! 🏆 All done!");
      tebsBadgetoggle();
    }
  }

  void _showCelebration(String message) {
    setState(() => _message = message);
    _confettiController.play();
  }

  // Avatar Selector Function
  selectAvatar(String imageLink) {
    setState((){
      avatar = imageLink;
    });
  }

  // Password Strength Updater Function
  updatePasswordStrength() {
    setState((){
      if (_passwordController.text.length < 6){
        passwordStrength = 0;
      } else{
        switch(_passwordController.text.length){
        case 6:
        passwordStrength = 0;
        break;
        case 7:
        passwordStrength = 0.16;
        break;
        case 8:
        passwordStrength = 0.33;
        break;
        case 9:
        passwordStrength = 0.5;
        break;
        case 10:
        passwordStrength = 0.67;
        break;
        case 11:
        passwordStrength = 0.83;
        break;
        case 12:
        passwordStrength = 1;
        spmBadge = true;
        break;
        default:
        passwordStrength = 1;
        spmBadge = true;
        break;
      }
    }
      
    });             
  }

  Color passwordBarColor(passwordStrength){
    if (passwordStrength > .5){
      return Colors.green;}
    else{
      return Colors.red;}
  }

  // Function to check the badge for signing up in the morning
  tebsBadgetoggle() {
    final currenttime = DateTime.now();
    if (currenttime.hour < 12){
      tebsBadge = true;
    } 
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

                // Progress bar
                LinearProgressIndicator(
                  value: _progress,
                  minHeight: 12,
                  backgroundColor: Colors.grey.shade300,
                  color: Colors.blueAccent,
                ),
                const SizedBox(height: 12),
                Text(
                  '${(_progress * 100).toInt()}% Complete',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // Encouraging message
                Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: Text(
                      _message,
                      key: ValueKey(_message),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              maxBlastForce: 15,
              minBlastForce: 5,
              colors: const [
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.green,
                Colors.purple,
              ],
            ),
          ),

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
                  onChanged: updatePasswordStrength(),
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
                
                SizedBox(height: 20),

                Stack(
                  alignment: Alignment.center,
                  children: [
                    LinearProgressIndicator(              
                      value: passwordStrength,
                      backgroundColor: Colors.grey[300],
                      color: passwordBarColor(passwordStrength) //Colors.purple,
                    ),
                    Text(
                      "Password Strength: ${passwordStrength*100}"
                    ),
                  ]
                ),

                SizedBox(height: 20),

                Text(
                  'Choose your avatar!',
                  style: TextStyle(fontSize: 18, color: Colors.grey),),

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
                
                
                SizedBox(height: 20,),
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
                          onPressed: 
                            _submitForm,
                            
                            
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
