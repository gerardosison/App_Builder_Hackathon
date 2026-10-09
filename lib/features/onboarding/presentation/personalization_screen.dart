import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../app/app_providers.dart';
import '../../../app/theme/app_colors.dart';

class PersonalizationScreen extends StatefulWidget {
  const PersonalizationScreen({super.key});

  @override
  State<PersonalizationScreen> createState() => _PersonalizationScreenState();
}

class _PersonalizationScreenState extends State<PersonalizationScreen> {
  int _page = 0;
  bool _saving = false;

  String _selectedLanguage = '🇺🇸 English (US)';

  final List<String> _languages = const [
    '🇺🇸 English (US)',
    '🇬🇧 English (UK)',
    '🇵🇭 Filipino (Tagalog)',
    '🇪🇸 Spanish (Español)',
    '🇫🇷 French (Français)',
    '🇩🇪 German (Deutsch)',
    '🇯🇵 Japanese (日本語)',
  ];

  final Set<String> _selectedPractices = {'Public Speaking'};

  final List<String> _practiceOptions = const [
    'Public Speaking',
    'Recitation',
    'Presentation',
    'Debate',
    'Others',
  ];

  Future<void> _next() async {
    if (_saving) return;

    if (_page == 0) {
      setState(() => _page = 1);
      return;
    }

    if (_selectedPractices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select at least one practice goal.')),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please sign in again.')));
      return;
    }

    setState(() => _saving = true);

    try {
      final existing = await progressRepository.profiles.read(user.uid);

      var fullName = existing?.fullName ?? '';
      var nickname = existing?.nickname ?? '';

      if (fullName.isEmpty || nickname.isEmpty) {
        if (!mounted) return;

        final names = await _askNames();
        if (names == null) return;

        fullName = names[0];
        nickname = names[1];
      }

      await progressRepository.profiles.save(
        userId: user.uid,
        fullName: fullName,
        nickname: nickname,
        language: _selectedLanguage,
        practicePurpose: jsonEncode(_selectedPractices.toList()),
        onboardingComplete: true,
      );

      currentSync?.requestSync();

      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not save personalization. Please retry.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<List<String>?> _askNames() async {
    final fullName = TextEditingController();
    final nickname = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<List<String>>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Complete your profile'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: fullName,
                decoration: const InputDecoration(labelText: 'Full name'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Enter your full name.'
                    : null,
              ),
              TextFormField(
                controller: nickname,
                decoration: const InputDecoration(labelText: 'Nickname'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Enter your nickname.'
                    : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(dialogContext, [
                  fullName.text.trim(),
                  nickname.text.trim(),
                ]);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    await Future<void>.delayed(const Duration(milliseconds: 300));

    fullName.dispose();
    nickname.dispose();

    return result;
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
                onPressed: _saving ? null : () => setState(() => _page = 0),
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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 8, 28, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        isLanguagePage
                            ? 'What language would you like to use?'
                            : 'What are you practicing for?',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(letterSpacing: -0.5, height: 1.25),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        isLanguagePage
                            ? 'Select your preferred language.'
                            : 'Select all speaking formats relevant to your goals.',
                      ),
                      const SizedBox(height: 28),
                      if (isLanguagePage) ...[
                        DropdownButtonFormField<String>(
                          initialValue: _selectedLanguage,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Language',
                            prefixIcon: Icon(Icons.language_rounded),
                          ),
                          items: _languages
                              .map(
                                (language) => DropdownMenuItem(
                                  value: language,
                                  child: Text(
                                    language,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: _saving
                              ? null
                              : (value) {
                                  if (value != null) {
                                    setState(() => _selectedLanguage = value);
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
                          child: const Text(
                            'Your preferences are saved on this device '
                            'and synced when connected. AI language '
                            'support depends on the models installed later.',
                            style: TextStyle(
                              fontSize: 12.5,
                              color: AppColors.navy,
                            ),
                          ),
                        ),
                      ] else ...[
                        ..._practiceOptions.map((option) {
                          final selected = _selectedPractices.contains(option);

                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                              side: BorderSide(
                                color: selected
                                    ? AppColors.blue
                                    : AppColors.line,
                                width: selected ? 1.5 : 1,
                              ),
                            ),
                            color: selected
                                ? AppColors.sky
                                : Theme.of(context).colorScheme.surface,
                            child: CheckboxListTile(
                              value: selected,
                              onChanged: _saving
                                  ? null
                                  : (value) {
                                      setState(() {
                                        if (value == true) {
                                          _selectedPractices.add(option);
                                        } else {
                                          _selectedPractices.remove(option);
                                        }
                                      });
                                    },
                              title: Text(
                                option,
                                style: TextStyle(
                                  fontWeight: selected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: selected
                                      ? AppColors.navy
                                      : Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              activeColor: AppColors.blue,
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                          );
                        }),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: _saving ? null : _next,
                  child: Text(
                    _saving
                        ? 'Saving…'
                        : isLanguagePage
                        ? 'Continue'
                        : 'Build my personalized plan',
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
