import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/pip_misc.dart';
import 'transcript_review_screen.dart';
import 'widgets/pose_feedback_card.dart';
import 'widgets/speech_metric_card.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({
    super.key,
    this.speechTopic = 'Tell a story in 60 seconds',
    this.durationSeconds = 64,
  });

  final String speechTopic;
  final int durationSeconds;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: pipAppBar(context, title: 'Speech & Body Feedback'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Step 1: Session Feedback',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppColors.blue,
                      letterSpacing: 0.6,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.mint,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${durationSeconds}s Spoken',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Performance Insights',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 18),

              // Overall Score Hero Card
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: AppColors.navy,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1814213D),
                      offset: Offset(4, 5),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 76,
                      height: 76,
                      decoration: const BoxDecoration(
                        color: AppColors.yellow,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          '91',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: AppColors.navy,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CONFIDENT & ENGAGING',
                            style: TextStyle(
                              color: AppColors.yellow,
                              fontWeight: FontWeight.w800,
                              fontSize: 11,
                              letterSpacing: 0.8,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Great speech delivery!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Steady tempo with minimal filler words and natural posture.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // SECTION 1: SPEECH DELIVERY INSIGHTS (SPEED & FILLER WORDS)
              const Text(
                'SPEECH DELIVERY INSIGHTS',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.blue,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 10),

              // Pacing / Speed Card
              const SpeechMetricCard(
                title: 'Speech Pacing (Speed)',
                value: '138 WPM',
                status: 'Optimal Pace',
                badgeColor: Colors.green,
                description:
                    'Your pace of 138 words per minute is in the target range (120-150 WPM) for natural public speaking.',
                icon: Icons.speed_rounded,
              ),
              const SizedBox(height: 12),

              // Filler Words Card
              const SpeechMetricCard(
                title: 'Filler Words Detected',
                value: '2 Words',
                status: '94% Clean',
                badgeColor: AppColors.blue,
                description:
                    'Detected 1 "um" and 1 "like". Excellent control—your pauses felt deliberate rather than hesitant.',
                icon: Icons.chat_bubble_outline_rounded,
              ),
              const SizedBox(height: 22),

              // SECTION 2: BODY LANGUAGE INSIGHTS
              const Text(
                'BODY LANGUAGE & POSTURE',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.blue,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 10),

              // Body Language Card
              const PoseFeedbackCard(
                eyeContactScore: 88,
                postureEvaluation:
                    'Upright, centered framing with consistent eye contact across the audience.',
                gestureEvaluation:
                    'Natural hand placement with expressive open gestures during main points.',
              ),
              const SizedBox(height: 26),

              // Step 2: Proceed to review transcript button
              SizedBox(
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TranscriptReviewScreen(
                          speechTopic: speechTopic,
                          durationSeconds: durationSeconds,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.description_outlined),
                  label: const Text(
                    'Proceed to Review Transcript',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
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

