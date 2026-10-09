class TranscriptProcessor {
  static const List<String> defaultFillerWords = ['um', 'uh', 'like', 'you know', 'so', 'ano', 'kwan'];

  /// Count occurrences of filler words in transcript
  Map<String, int> detectFillers(String text, {List<String>? customFillers}) {
    final Map<String, int> results = {};
    final lower = text.toLowerCase();
    final targets = customFillers ?? defaultFillerWords;

    for (var word in targets) {
      final reg = RegExp('\\b${RegExp.escape(word)}\\b');
      int count = reg.allMatches(lower).length;
      if (count > 0) {
        results[word] = count;
      }
    }
    return results;
  }
}
