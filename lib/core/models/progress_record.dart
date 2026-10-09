/// Star/level transaction record for the Progress ledger.
/// TODO(data): persisted via star_transactions_table.
class ProgressRecord {
  const ProgressRecord({
    required this.id,
    required this.date,
    required this.starsDelta,
    required this.levelAfter,
    required this.sessionId,
  });

  final String id;
  final DateTime date;
  final int starsDelta;
  final int levelAfter;
  final String sessionId;
}
