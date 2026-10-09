import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'data/local/app_database.dart';
import 'data/repositories/progress_repository.dart';
import 'data/sync/progress_sync_controller.dart';
import 'features/onboarding/presentation/profile_gate.dart';

import 'firebase_options.dart';

final appDatabase = AppDatabase();

final progressRepository = ProgressRepository(
  appDatabase,
  FirebaseFirestore.instance,
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Builder Hackathon',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          final user = snapshot.data;
          return user == null
              ? const LoginScreen()
              : ProfileGate(
                  key: ValueKey(user.uid),
                  userId: user.uid,
                  repository: progressRepository,
                  child: ProgressScreen(key: ValueKey(user.uid), user: user),
                );
        },
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool busy = false;
  String? error;

  Future<void> authenticate(bool createAccount) async {
    setState(() {
      busy = true;
      error = null;
    });

    try {
      final auth = FirebaseAuth.instance;
      if (createAccount) {
        await auth.createUserWithEmailAndPassword(
          email: email.text.trim(),
          password: password.text,
        );
      } else {
        await auth.signInWithEmailAndPassword(
          email: email.text.trim(),
          password: password.text,
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() => error = e.message ?? 'Authentication failed.');
      }
    } catch (_) {
      if (mounted) {
        setState(() => error = 'Could not connect. Please try again.');
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your account')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: SizedBox(
            width: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: password,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    helperText: 'Use at least 6 characters.',
                  ),
                ),
                const SizedBox(height: 20),
                if (error != null)
                  Text(error!, style: const TextStyle(color: Colors.red)),
                if (busy) const Center(child: CircularProgressIndicator()),
                FilledButton(
                  onPressed: busy ? null : () => authenticate(false),
                  child: const Text('Sign in'),
                ),
                OutlinedButton(
                  onPressed: busy ? null : () => authenticate(true),
                  child: const Text('Create account'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key, required this.user});

  final User user;

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  bool saving = false;

  late final Stream<List<PracticeRecord>> records;
  late final ProgressSyncController syncController;

  @override
  void initState() {
    super.initState();

    records = progressRepository.watchRecords(widget.user.uid);

    syncController = ProgressSyncController(
      repository: progressRepository,
      userId: widget.user.uid,
    );

    syncController.start();
  }

  Future<void> addTestPractice() async {
    setState(() => saving = true);

    try {
      await progressRepository.saveCompletedPractice(
        userId: widget.user.uid,
        practicePurpose: 'Database test',
        durationSeconds: 60,
        starsEarned: 1,
        isTest: true,
      );

      // Saving to SQLite finishes first. Cloud sync runs separately.
      syncController.requestSync();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not save locally: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  void dispose() {
    syncController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HAWKABUILD progress'),
        actions: [
          TextButton(
            onPressed: saving ? null : () => FirebaseAuth.instance.signOut(),
            child: const Text('Sign out'),
          ),
        ],
      ),
      body: StreamBuilder<List<PracticeRecord>>(
        stream: records,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Local database error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final sessions = snapshot.data!;

          final realSessions = sessions
              .where((session) => !session.isTest)
              .toList();

          final totalStars = realSessions.fold<int>(
            0,
            (total, session) => total + session.starsEarned,
          );

          final testSessionCount = sessions
              .where((session) => session.isTest)
              .length;

          var level = 1;
          var starsInLevel = totalStars;

          while (starsInLevel >= 10 * level) {
            starsInLevel -= 10 * level;
            level++;
          }

          final pending = sessions
              .where((session) => session.needsUpload)
              .length;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(widget.user.email ?? 'Signed in'),
                const SizedBox(height: 16),
                Text(
                  'Level $level',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text('$totalStars total stars'),
                Text('$starsInLevel / ${10 * level} toward next level'),
                Text('${realSessions.length} real practice sessions'),
                Text('$testSessionCount database-test sessions'),
                Text('$pending sessions waiting to upload'),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: saving ? null : addTestPractice,
                  child: const Text('Database test: save 1 star locally'),
                ),
                ListenableBuilder(
                  listenable: syncController,
                  builder: (context, child) {
                    final busy =
                        syncController.status == ProgressSyncStatus.syncing;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        OutlinedButton(
                          onPressed: busy
                              ? null
                              : () => syncController.requestSync(),
                          child: const Text('Sync now'),
                        ),
                        Text(syncController.message),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Test stars verify the database. '
                  'Real practice scoring is not connected yet.',
                ),
                const Divider(),
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
            ),
          );
        },
      ),
    );
  }
}
