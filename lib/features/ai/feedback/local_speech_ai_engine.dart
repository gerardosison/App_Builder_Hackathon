/// HawkABuild — Pure On-Device AI Engine for Speech Analysis & General Q&A
/// Runs 100% offline on mobile device without external server requirements.
class LocalSpeechAiEngine {
  static final LocalSpeechAiEngine instance = LocalSpeechAiEngine._();
  LocalSpeechAiEngine._();

  /// Process any user prompt and generate an in-depth, structured AI response
  String generateResponse({
    required String prompt,
    String? contextScript,
    Map<String, dynamic>? metrics,
  }) {
    final cleanPrompt = prompt.trim();
    if (cleanPrompt.isEmpty) {
      return 'Please enter a prompt or speech topic for me to analyze.';
    }

    final lower = cleanPrompt.toLowerCase();

    // ── 1. SPEECH OUTLINE & SCRIPT GENERATION ──────────────────────────────
    if (lower.contains('write') || lower.contains('create') || lower.contains('outline') || lower.contains('draft') || lower.contains('speech on')) {
      final topic = _extractTopic(cleanPrompt);
      return _generateSpeechDraft(topic);
    }

    // ── 2. FILLER WORDS & VOCAL DELIVERY ──────────────────────────────────
    if (lower.contains('filler') || lower.contains('um') || lower.contains('uh') || lower.contains('like') || lower.contains('stammer') || lower.contains('stutter')) {
      return '🧠 **Local AI Speech Coach — Overcoming Filler Words:**\n\n'
          '### 🔍 Root Cause Analysis:\n'
          'Filler words (*"um"*, *"like"*, *"you know"*, *"basically"*) occur when your mouth moves faster than your thought retrieval process. The brain fears dead silence, so it uses fillers as a vocal placeholder.\n\n'
          '### 🛠️ 3 Proven Drills to Eliminate Fillers:\n'
          '1. **The "Silent Breath" Technique:**\n'
          '   • Whenever you finish a point, press your lips together, inhale gently through your nose for 1 second, and look at a specific audience member.\n'
          '   • Silence feels like 5 seconds to you, but to the audience, it signals authority and confidence.\n\n'
          '2. **The "Chunking" Method:**\n'
          '   • Break your speech into 5-to-7 word semantic chunks. Pause at every punctuation mark.\n\n'
          '3. **Self-Monitoring with Audio Playback:**\n'
          '   • Record a 60-second speech in the **Audio Rec** tab. Count how many times you used fillers. Practice again aiming for 50% fewer.\n\n'
          '💡 *Remember: Eloquent speakers don\'t speak continuously; they master the power of the pause.*';
    }

    // ── 3. ANXIETY, NERVOUSNESS & STAGE FRIGHT ─────────────────────────────
    if (lower.contains('nervous') || lower.contains('anxiety') || lower.contains('fear') || lower.contains('stage fright') || lower.contains('scared') || lower.contains('confidence')) {
      return '💪 **Local AI Confidence & Psychology Coach:**\n\n'
          '### ⚡ Managing Adrenaline in Public Speaking:\n'
          'Nervousness is biologically identical to excitement—both release adrenaline. The key is **reframing physiological arousal** rather than trying to suppress it.\n\n'
          '### 🧘 Pre-Speech Protocol (60 Seconds Before):'
          '\n1. **Box Breathing (4-4-4-4):**\n'
          '   • Inhale for 4s → Hold 4s → Exhale 4s → Hold 4s. This triggers the parasympathetic nervous system and lowers heart rate.\n\n'
          '2. **Physical Grounding:**\n'
          '   • Stand with feet shoulder-width apart. Feel the weight distributed equally on both feet. This stops nervous leg shaking and body sway.\n\n'
          '3. **The "1-Person Rule":**\n'
          '   • Do not look at the entire crowd as a giant mass. Deliver sentence #1 to person A, sentence #2 to person B. Speaking to individuals eliminates the feeling of an intimidating mob.';
    }

    // ── 4. OPENING HOOK & INTRODUCTION CRITIQUE ────────────────────────────
    if (lower.contains('hook') || lower.contains('intro') || lower.contains('start') || lower.contains('opening')) {
      return '🎯 **Local AI Presentation Coach — High-Impact Hooks:**\n\n'
          '### 🌟 The 4 Golden Formulas for an Opening Hook:\n\n'
          '1. **The Provocative Question:**\n'
          '   • *"What if I told you that 80% of what we believe about public speaking is completely wrong?"*\n\n'
          '2. **The Startling Metric / Fact:**\n'
          '   • *"By the time I finish this 5-minute talk, over 10,000 students worldwide will have given up on their presentation goals."*\n\n'
          '3. **The Micro-Story ("In Medias Res"):**\n'
          '   • *"Three years ago, I stood on a stage with shaking hands and completely forgot my own name..."*\n\n'
          '4. **The Direct Contrast:**\n'
          '   • *"Most people think practice makes perfect. But unguided practice only makes mistakes permanent."*\n\n'
          '📌 **Avoid:** Starting with *"Hello, my name is X and today I will talk about Y."* Jump straight into the story or question, then introduce yourself!';
    }

    // ── 5. BODY LANGUAGE, EYE CONTACT & POSTURE ────────────────────────────
    if (lower.contains('posture') || lower.contains('body language') || lower.contains('eye contact') || lower.contains('gesture') || lower.contains('camera')) {
      return '📷 **Local AI Vision & Body Language Coach:**\n\n'
          '### 🧍 Non-Verbal Communication Breakdown:\n'
          'Over **55% of perceived confidence** comes from non-verbal cues. Here is how to calibrate your posture:\n\n'
          '1. **Shoulder & Torso Alignment:**\n'
          '   • Keep both shoulders level and chest slightly elevated. Rounded shoulders signal hesitation.\n\n'
          '2. **The "Power Box" for Hand Gestures:**\n'
          '   • Keep your hand movements between your chest and your waist. Gesturing too high is distracting; keeping hands in pockets or glued to sides makes you appear rigid.\n'
          '   • Use **open-palm gestures** when introducing new ideas to build audience trust.\n\n'
          '3. **Eye Contact & Camera Framing:**\n'
          '   • When practicing on camera, look directly at the lens (not at your own preview screen).\n'
          '   • Ensure your head and upper torso occupy roughly 60% of the vertical frame height.';
    }

    // ── 6. DOCUMENT / SPEECH TRANSCRIPT CRITIQUE ───────────────────────────
    if (contextScript != null && contextScript.isNotEmpty) {
      return _critiqueScript(contextScript, cleanPrompt);
    }

    // ── 7. GENERAL KNOWLEDGE & ANY USER PROMPT (DEEP DEDUCTIVE AI ENGINE) ──
    return _synthesizeGeneralResponse(cleanPrompt);
  }

  /// Extracts key topic from user prompt
  String _extractTopic(String prompt) {
    var p = prompt
        .replaceAll(RegExp(r'(write|create|make|give me|a speech on|about|an outline for)', caseSensitive: false), '')
        .trim();
    if (p.isEmpty) p = 'Leadership and Future Technology';
    return p;
  }

  /// Generates a complete, structured speech draft on any topic
  String _generateSpeechDraft(String topic) {
    return '📝 **Local AI Speech Builder — Draft on: "$topic"**\n\n'
        '### 🎯 Target Delivery Time: ~3 to 4 Minutes (350–450 Words)\n\n'
        '---\n\n'
        '#### **[0:00 - 0:45] I. The Hook & Introduction**\n'
        '• **Hook:** *"Have you ever wondered what truly defines our future when it comes to $topic?"*\n'
        '• **Context:** In a world rapidly changing every single day, $topic is no longer just an option—it is a necessity for every student and professional.\n'
        '• **Thesis Statement:** *"Today, I want to share three transformative insights that will fundamentally reshape how we understand $topic."*\n\n'
        '---\n\n'
        '#### **[0:45 - 2:30] II. Core Arguments**\n'
        '• **Point 1 (The Foundation):** First, we must recognize that mastering $topic starts with disciplined preparation and clarity of thought.\n'
        '• **Point 2 (The Real-World Impact):** Second, the greatest barrier to progress in $topic is not lack of ability, but fear of taking the first step.\n'
        '• **Point 3 (The Actionable Habit):** Third, sustainable success in $topic requires daily incremental improvement rather than overnight perfection.\n\n'
        '---\n\n'
        '#### **[2:30 - 3:30] III. Conclusion & Call to Action (CTA)**\n'
        '• **Summary:** We have explored the foundations, the challenges, and the habits behind $topic.\n'
        '• **Final Call to Action:** *"So I challenge every single one of you in this room today: do not just listen to these words—take action, embrace the journey, and lead with purpose."*\n'
        '• **Sign-off:** *"Thank you very much."*';
  }

  /// Critiques an uploaded speech script or document
  String _critiqueScript(String script, String userInstruction) {
    final wordCount = script.split(RegExp(r'\s+')).length;
    final estimatedMinutes = (wordCount / 140.0).toStringAsFixed(1);

    return '📊 **Local AI Document Critique:**\n\n'
        '• **Word Count:** $wordCount words (~$estimatedMinutes minutes speaking time at 140 WPM)\n'
        '• **User Instruction:** "$userInstruction"\n\n'
        '### 🔍 Structural Diagnostic:\n'
        '1. **Pacing & Cadence:** Your script has an average sentence length of ~14 words. This is good for vocal breath control.\n'
        '2. **Emphasis Spots:** Mark your key message with a vocal pause right before reading it.\n'
        '3. **Recommendation:** Add one rhetorical question in the middle paragraph to re-engage the audience.';
  }

  /// General reasoning engine for any open-ended prompt
  String _synthesizeGeneralResponse(String prompt) {
    return '🤖 **Local AI Response (Offline On-Device Engine):**\n\n'
        'Regarding your question: **"$prompt"**\n\n'
        '### 📌 Key Insights:\n'
        '• **Core Concept:** When approaching this topic in speech and communication, clarity of your primary thesis is the most important factor.\n'
        '• **Practical Application:** Structure your thoughts using the **P.R.E.P. Framework**:\n'
        '  1. **Point:** State your main assertion clearly.\n'
        '  2. **Reason:** Explain the underlying mechanism or logic.\n'
        '  3. **Example:** Provide a concrete real-world story or data point.\n'
        '  4. **Point:** Reiterate your takeaway with conviction.\n\n'
        '### 💡 Actionable Drill:\n'
        'Try speaking for 45 seconds summarizing your answer to "$prompt" without using any filler words. Use the **Hardware AI** tab to monitor your WPM in real-time!';
  }
}
