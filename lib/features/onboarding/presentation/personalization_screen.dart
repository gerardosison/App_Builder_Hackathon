import 'package:flutter/material.dart';

import '../../../data/repositories/profile_repository.dart';

class PersonalizationScreen extends StatefulWidget {
  const PersonalizationScreen({
    super.key,
    required this.userId,
    required this.repository,
  });

  final String userId;
  final ProfileRepository repository;

  @override
  State<PersonalizationScreen> createState() =>
      _PersonalizationScreenState();
}

class _PersonalizationScreenState
    extends State<PersonalizationScreen> {
  final fullName = TextEditingController();
  final nickname = TextEditingController();
  final formKey = GlobalKey<FormState>();

  int step = 0;
  String language = 'English';
  String purpose = 'Class presentation';
  bool saving = false;
  String? error;

  final languages = const [
    'English',
    'Filipino',
  ];

  final purposes = const [
    'Class presentation',
    'Public speaking',
    'Interview',
    'Speech competition',
    'Other',
  ];

  Future<void> finish() async {
    setState(() {
      saving = true;
      error = null;
    });

    try {
      await widget.repository.save(
        userId: widget.userId,
        fullName: fullName.text,
        nickname: nickname.text,
        language: language,
        practicePurpose: purpose,
      );
      // The profile stream automatically opens the main screen.
    } catch (_) {
      if (mounted) {
        setState(() => error = 'Could not save. Please try again.');
      }
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  void dispose() {
    fullName.dispose();
    nickname.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome to HAWKABUILD')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Step ${step + 1} of 3',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 24),
                if (step == 0) ...[
                  Text(
                    'Practice with confidence',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Practice your speech, review feedback, and track '
                    'improvement with stars.\n\n'
                    'Practice results stay on your device while offline '
                    'and sync when you reconnect.\n\n'
                    'The app will ask permission before using your '
                    'camera or microphone.',
                  ),
                ],
                if (step == 1)
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: fullName,
                          decoration: const InputDecoration(
                            labelText: 'Full name',
                          ),
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                                  ? 'Enter your full name.'
                                  : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: nickname,
                          decoration: const InputDecoration(
                            labelText: 'Nickname',
                          ),
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                                  ? 'Enter your nickname.'
                                  : null,
                        ),
                      ],
                    ),
                  ),
                if (step == 2) ...[
                  DropdownButtonFormField<String>(
                    initialValue: language,
                    decoration: const InputDecoration(
                      labelText: 'Preferred language',
                    ),
                    items: languages
                        .map(
                          (value) => DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          ),
                        )
                        .toList(),
                    onChanged: saving
                        ? null
                        : (value) {
                            if (value != null) {
                              setState(() => language = value);
                            }
                          },
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    initialValue: purpose,
                    decoration: const InputDecoration(
                      labelText: 'What are you practicing for?',
                    ),
                    items: purposes
                        .map(
                          (value) => DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          ),
                        )
                        .toList(),
                    onChanged: saving
                        ? null
                        : (value) {
                            if (value != null) {
                              setState(() => purpose = value);
                            }
                          },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'These are saved preferences. AI language support '
                    'will depend on the models installed later.',
                  ),
                ],
                const SizedBox(height: 24),
                if (error != null)
                  Text(
                    error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                FilledButton(
                  onPressed: saving
                      ? null
                      : () {
                          if (step == 1 &&
                              !formKey.currentState!.validate()) {
                            return;
                          }

                          if (step < 2) {
                            setState(() => step++);
                          } else {
                            finish();
                          }
                        },
                  child: Text(
                    saving
                        ? 'Saving…'
                        : step == 2
                            ? 'Finish setup'
                            : 'Continue',
                  ),
                ),
                if (step > 0)
                  TextButton(
                    onPressed: saving
                        ? null
                        : () => setState(() => step--),
                    child: const Text('Back'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}