class NewsTile {
  final int id;
  final String title;
  final String summary;
  final String published;
  bool favourite;

  NewsTile(
      {required this.id,
      required this.title,
      required this.summary,
      required this.published,
      this.favourite = false});
}
