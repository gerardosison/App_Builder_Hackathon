import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../app/app_providers.dart';
import '../../../data/local/app_database.dart';

class LiveHomeTab extends StatelessWidget {
  const LiveHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<LocalProfile?>(
      stream: progressRepository.profiles.watch(userId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Could not load your profile.');
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Hello, ${snapshot.data?.nickname ?? "Speaker"}!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            const Text(
              'Your practice history stays on this device while offline '
              'and syncs when you reconnect.',
            ),
            const SizedBox(height: 20),
            const LiveProgressTab(compact: true),
            const SizedBox(height: 20),
            const Text(
              'Practice recording and AI analysis are not connected yet.',
            ),
          ],
        );
      },
    );
  }
}

class LiveProgressTab extends StatelessWidget {
  const LiveProgressTab({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<List<PracticeRecord>>(
      stream: progressRepository.watchRecords(userId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Local progress error: ${snapshot.error}');
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final sessions = snapshot.data!;
        final realSessions = sessions
            .where((session) => !session.isTest)
            .toList();

        final stars = realSessions.fold<int>(
          0,
          (total, session) => total + session.starsEarned,
        );

        var level = 1;
        var starsInLevel = stars;

        while (starsInLevel >= 10 * level) {
          starsInLevel -= 10 * level;
          level++;
        }

        final pending = sessions.where((session) => session.needsUpload).length;

        final sync = currentSync;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Level $level · $stars stars',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text('$starsInLevel / ${10 * level} stars toward the next level'),
            Text(
              '${realSessions.length} practice sessions · '
              '$pending pending uploads',
            ),
            if (sync != null)
              ListenableBuilder(
                listenable: sync,
                builder: (context, _) => Text(sync.message),
              ),
            if (!compact) ...[
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => currentSync?.requestSync(),
                child: const Text('Sync now'),
              ),
              OutlinedButton(
                onPressed: () async {
                  try {
                    await progressRepository.saveCompletedPractice(
                      userId: userId,
                      practicePurpose: 'Database test',
                      durationSeconds: 60,
                      starsEarned: 1,
                      isTest: true,
                    );

                    currentSync?.requestSync();
                  } catch (_) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Could not save test record.'),
                        ),
                      );
                    }
                  }
                },
                child: const Text(
                  'Save database test — excluded from real stars',
                ),
              ),
              const SizedBox(height: 12),
              for (final session in sessions)
                ListTile(
                  title: Text(session.practicePurpose),
                  subtitle: Text(
                    '${session.completedAt.toLocal()}\n'
                    '${session.needsUpload ? "Pending upload" : "Synced"}',
                  ),
                  trailing: Text(
                    session.isTest ? 'TEST' : '+${session.starsEarned} ★',
                  ),
                ),
            ],
          ],
        );
      },
    );
  }
}

class LiveProfileTab extends StatelessWidget {
  const LiveProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return StreamBuilder<LocalProfile?>(
      stream: progressRepository.profiles.watch(user.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Could not load your profile.');
        }

        final profile = snapshot.data;

        if (profile == null) {
          return const Center(child: CircularProgressIndicator());
        }

        var goals = profile.practicePurpose;

        try {
          final decoded = jsonDecode(goals);
          if (decoded is List) goals = decoded.join(', ');
        } catch (_) {
          // Earlier profiles store a single plain-text purpose.
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Profile', style: Theme.of(context).textTheme.displaySmall),
            ListTile(
              title: Text(profile.fullName),
              subtitle: Text(profile.nickname),
            ),
            ListTile(
              title: const Text('Email'),
              subtitle: Text(user.email ?? ''),
            ),
            ListTile(
              title: const Text('Language'),
              subtitle: Text(profile.language),
            ),
            ListTile(
              title: const Text('Practice goals'),
              subtitle: Text(goals),
            ),
            FilledButton(
              onPressed: () => _edit(context, profile),
              child: const Text('Edit name and nickname'),
            ),
            Text(
              profile.needsUpload
                  ? 'Profile changes waiting to upload'
                  : 'Profile synced',
            ),
          ],
        );
      },
    );
  }

  Future<void> _edit(BuildContext context, LocalProfile profile) async {
    final name = TextEditingController(text: profile.fullName);
    final nickname = TextEditingController(text: profile.nickname);
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<List<String>>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit profile'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: name,
                decoration: const InputDecoration(labelText: 'Full name'),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: nickname,
                decoration: const InputDecoration(labelText: 'Nickname'),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Required' : null,
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
                  name.text.trim(),
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
    name.dispose();
    nickname.dispose();

    if (result == null) return;

    try {
      await progressRepository.profiles.save(
        userId: profile.userId,
        fullName: result[0],
        nickname: result[1],
        language: profile.language,
        practicePurpose: profile.practicePurpose,
      );

      currentSync?.requestSync();
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not save profile.')),
        );
      }
    }
  }
}
