class Item {
  /// The item's unique id
  final int id;

  /// The username of the item's author
  final String by;

  /// In the case of stories or polls, the total comment count
  final int descendants;

  /// the ids of the story's comments
  final List<int> kids;

  /// The story's score, or the votes for a pollopt.
  final int score;

  /// Creation date of the item, in Unix Time.
  final int time;

  /// The title of the story, poll or job. HTML.
  final String title;

  /// The type of item. One of "job", "story", "comment", "poll", or "pollopt".
  final String type;

  /// The URL of the story
  final String url;

  final String text;

  Item(this.id, this.by, this.descendants, this.kids, this.score, this.time, this.title, this.type, this.url, this.text);
}