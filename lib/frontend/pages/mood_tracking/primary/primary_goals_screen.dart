
import 'package:first_task_app/frontend/navigation/index.dart';


class PrimaryGoalsScreen extends StatefulWidget {
  const PrimaryGoalsScreen({super.key});

  @override
  State<PrimaryGoalsScreen> createState() => _PrimaryGoalsScreenState();
}

class _PrimaryGoalsScreenState extends State<PrimaryGoalsScreen> {
  final Set<String> _selectedGoals = {};
  bool _isLoading = false;

  final List<Map<String, dynamic>> _goals = [
    {'title': 'Reduce Anxiety', 'icon': Icons.psychology_outlined},
    {'title': 'Better Sleep', 'icon': Icons.dark_mode_outlined},
    {'title': 'Improve Focus', 'icon': Icons.track_changes_outlined},
    {'title': 'Manage Stress', 'icon': Icons.self_improvement_outlined},
    {'title': 'Mindfulness', 'icon': Icons.filter_vintage_outlined},
    {'title': 'Self-Esteem', 'icon': Icons.person_outline},
    {'title': 'Work-Life Balance', 'icon': Icons.work_outline},
    {'title': 'Academic-Performance', 'icon': Icons.school_outlined},
  ];

  void _toggleGoal(String title) {
    if (_isLoading) return;
    setState(() {
      if (_selectedGoals.contains(title)) {
        _selectedGoals.remove(title);
      } else if (_selectedGoals.length < 3) {
        _selectedGoals.add(title);
      }
    });
  }

  // --- BACKEND INTEGRATION ---
  Future<void> _handleContinue() async {
    setState(() => _isLoading = true);
    try {
      // Create a method in AuthService named updatePrimaryGoals
      // that calls PUT /api/user/update-goals
      await AuthService().updatePrimaryGoals(_selectedGoals.toList());

      if (!mounted) return;
      
      // Move to home or the next onboarding step
      Navigator.pushNamed(context,Routes.home); 
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.redAccent),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'STEP 2 OF 3',
          style: TextStyle(color: Colors.grey, fontSize: 13, letterSpacing: 1.2, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Select your Primary Goals',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Select 3 options that apply to your day.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _goals.length,
                itemBuilder: (context, index) {
                  final goal = _goals[index];
                  final isSelected = _selectedGoals.contains(goal['title']);
                  
                  return GestureDetector(
                    onTap: () => _toggleGoal(goal['title']),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.black.withOpacity(0.02) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? Colors.black : Colors.grey.shade200,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Icon(goal['icon'], size: 22, color: isSelected ? Colors.black : Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              goal['title'],
                              style: TextStyle(
                                fontSize: 13, 
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                color: isSelected ? Colors.black : Colors.black87
                              ),
                            ),
                          ),
                          if (isSelected) const Icon(Icons.check_circle, size: 18, color: Colors.black),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            _buildContinueButton(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    bool canContinue = _selectedGoals.length == 3;
    
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: (canContinue && !_isLoading) ? _handleContinue : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          disabledBackgroundColor: Colors.grey.shade300,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 0,
        ),
        child: _isLoading 
          ? const CircularProgressIndicator(color: Colors.white)
          : Text(
              'Continue',
              style: TextStyle(
                fontSize: 18, 
                color: canContinue ? Colors.white : Colors.grey.shade500,
                fontWeight: FontWeight.bold
              ),
            ),
      ),
    );
  }
}