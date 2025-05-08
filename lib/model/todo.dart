class Todo {
  String tittle;
  DateTime date;
  bool isComplete;
  Todo({
    required this.tittle,
    required this.date,
    this.isComplete = false,
  });
}