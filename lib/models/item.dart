class Item {
  /// The item's unique id
  int id;

  /// The username of the item's author
  String by;

  /// In the case of stories or polls, the total comment count
  int descendants;

  /// the ids of the story's comments
  List<int> kids;

  /// The story's score, or the votes for a pollopt.
  int score;

  /// Creation date of the item, in Unix Time.
  int time;

  /// The title of the story, poll or job. HTML.
  String title;

  /// The type of item. One of "job", "story", "comment", "poll", or "pollopt".
  String type;

  /// The URL of the story
  String url;

  String text;

  bool read = false;

  List<Item> comments = [];

  Item(this.id, this.by, this.descendants, this.kids, this.score, this.time, this.title, this.type, this.url, this.text);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = {
      "id": id,
      "by": by,
      "descendants":descendants,
      "kids": kids,
      "score":score,
      "time":time,
      "title":title,
      "type":type,
      "url":url,
      "text":text,
    };
    return jsonMap;
  }
}