import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../home/presentation/home_screen.dart';

class PersonalizationScreen extends StatefulWidget {
  const PersonalizationScreen({super.key});

  @override
  State<PersonalizationScreen> createState() => _PersonalizationScreenState();
}

class _PersonalizationScreenState extends State<PersonalizationScreen> {
  int _page = 0;

  // Page 1: Language selection (with Flag Icon & Flag Name)
  String _selectedLanguage = '🇺🇸 English (US)';

  final List<_LanguageOption> _languages = const [
    _LanguageOption(flag: '🇺🇸', name: 'English (US)', code: 'en-US'),
    _LanguageOption(flag: '🇬🇧', name: 'English (UK)', code: 'en-GB'),
    _LanguageOption(flag: '🇵🇭', name: 'Filipino (Tagalog)', code: 'fil-PH'),
    _LanguageOption(flag: '🇪🇸', name: 'Spanish (Español)', code: 'es-ES'),
    _LanguageOption(flag: '🇫🇷', name: 'French (Français)', code: 'fr-FR'),
    _LanguageOption(flag: '🇩🇪', name: 'German (Deutsch)', code: 'de-DE'),
    _LanguageOption(flag: '🇯🇵', name: 'Japanese (日本語)', code: 'ja-JP'),
  ];

  // Page 2: What are you practicing for (select all that apply)
  final Set<String> _selectedPractices = {'Public Speaking'};

  final List<String> _practiceOptions = const [
    'Public Speaking',
    'Recitation',
    'Presentation',
    'Debate',
    'Others',
  ];

  void _next() {
    if (_page == 0) {
      setState(() => _page = 1);
    } else {
      if (_selectedPractices.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select at least one practice goal to continue.'),
            backgroundColor: AppColors.coral,
          ),
        );
        return;
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  void _previous() {
    if (_page > 0) {
      setState(() => _page = 0);
    }
  }

  void _showMultiSelectDropdown() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Select Practice Goals',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const Text(
                    'Select all that apply to your speaking journey',
                    style: TextStyle(fontSize: 13, color: AppColors.navySoft),
                  ),
                  const SizedBox(height: 14),
                  ..._practiceOptions.map((option) {
                    final selected = _selectedPractices.contains(option);
                    return CheckboxListTile(
                      value: selected,
                      title: Text(
                        option,
                        style: TextStyle(
                          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      activeColor: AppColors.blue,
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) {
                        setModalState(() {
                          if (val == true) {
                            _selectedPractices.add(option);
                          } else {
                            _selectedPractices.remove(option);
                          }
                        });
                        setState(() {});
                      },
                    );
                  }),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Confirm Selection'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLanguagePage = _page == 0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _page > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: _previous,
                tooltip: 'Back',
              )
            : null,
        title: Text(
          'Preference ${_page + 1} of 2',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.blue,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 8, 28, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Progress Bar
              Row(
                children: List.generate(
                  2,
                  (index) => Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      height: 6,
                      margin: EdgeInsets.only(right: index == 1 ? 0 : 8),
                      decoration: BoxDecoration(
                        color: index <= _page ? AppColors.blue : AppColors.line,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Page Title & Subtitle
              Text(
                isLanguagePage
                    ? 'What language would you like to use?'
                    : 'What are you practicing for? (Select all that apply)',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      letterSpacing: -0.5,
                      height: 1.25,
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                isLanguagePage
                    ? 'Select your preferred language with flag icon & flag name.'
                    : 'Choose all speaking formats relevant to your goals from the dropdown.',
                style: const TextStyle(fontSize: 14, color: AppColors.navySoft),
              ),
              const SizedBox(height: 28),

              // PAGE 1: Select Language (with Flag Icon & Flag Name) - Dropdown
              if (isLanguagePage) ...[
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _selectedLanguage,
                  decoration: const InputDecoration(
                    labelText: 'Language',
                    prefixIcon: Icon(Icons.language_rounded),
                  ),
                  items: _languages.map((lang) {
                    final display = '${lang.flag} ${lang.name}';
                    return DropdownMenuItem<String>(
                      value: display,
                      child: Row(
                        children: [
                          Text(lang.flag, style: const TextStyle(fontSize: 20)),
                          const SizedBox(width: 12),
                          Text(
                            lang.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _selectedLanguage = val);
                    }
                  },
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.sky,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.line),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline_rounded, color: AppColors.navy),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'You can modify this anytime in Settings.',
                          style: const TextStyle(fontSize: 12.5, color: AppColors.navy),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 36),
              ]
              // PAGE 2: What are you practicing for (select all that apply) - Dropdown
              else ...[
                const SizedBox(height: 8),
                ..._practiceOptions.map((option) {
                  final isSelected = _selectedPractices.contains(option);
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(
                        color: isSelected ? AppColors.blue : AppColors.line,
                        width: isSelected ? 1.5 : 1.0,
                      ),
                    ),
                    color: isSelected ? AppColors.sky : Colors.white,
                    child: CheckboxListTile(
                      value: isSelected,
                      onChanged: (selected) {
                        setState(() {
                          if (selected == true) {
                            _selectedPractices.add(option);
                          } else {
                            _selectedPractices.remove(option);
                          }
                        });
                      },
                      title: Text(
                        option,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? AppColors.navy : AppColors.ink,
                        ),
                      ),
                      activeColor: AppColors.blue,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  );
                }),
                const SizedBox(height: 20),
              ],

              // Action Button
              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: _next,
                  child: Text(
                    isLanguagePage ? 'Continue' : 'Build my personalized plan',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageOption {
  const _LanguageOption({
    required this.flag,
    required this.name,
    required this.code,
  });

  final String flag;
  final String name;
  final String code;
}
