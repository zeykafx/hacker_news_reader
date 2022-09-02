import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import '../models/item.dart';

class HackerNewsApi {
  String topStoriesLink = "https://hacker-news.firebaseio.com/v0/topstories.json";
  String newStoriesLink = "https://hacker-news.firebaseio.com/v0/newstories.json";
  String bestStoriesLink = "https://hacker-news.firebaseio.com/v0/beststories.json";

  /// items fields:
  /// id:           The item's unique id. Required I presume.
  /// deleted:      true if the item is deleted.
  /// type:         The type of item. One of "job", "story", "comment", "poll", or "pollopt".
  /// by:           The username of the item's author.
  /// time:         Creation date of the item, in Unix Time.
  /// text:         The comment, story or poll text. HTML.
  /// dead:         true if the item is dead.
  /// parent:       The comment's parent: either another comment or the relevant story.
  /// poll:         The pollopt's associated poll.
  /// kids:         The ids of the item's comments, in ranked display order.
  /// url:          The URL of the story.
  /// score:        The story's score, or the votes for a pollopt.
  /// title:        The title of the story, poll or job. HTML.
  /// parts:        A list of related pollopts, in display order.
  /// descendants:  In the case of stories or polls, the total comment count.
  String itemLink = "https://hacker-news.firebaseio.com/v0/item";

  /// user fields:
  /// id:           the user's unique username. Case sensitive. required.
  /// created:      Creation date of the user, in Unix Time
  /// karma:        The user's karma
  /// about:        The user's optional self-description. HTML.
  /// submitted:    List of the user's stories polls and comments.
  String userLink = "https://hacker-news.firebaseio.com/v0/user";

  GetStorage box = GetStorage();

  Future<void> getTopStories(int maxStoriesToFetch, Function(Item) callback) async {
    // List<Item> topStories = [];
    int storiesFetched = 0;

    try {
      Response response = await Dio().get(topStoriesLink);
      for (int id in response.data) {
        if (storiesFetched <= maxStoriesToFetch) {
          try {
            Response itemResponse = await Dio().get("$itemLink/$id.json");
            Item item = Item(
                itemResponse.data["id"] ?? 0,
                itemResponse.data["by"] ?? "No Username",
                itemResponse.data['descendants'] ?? 0,
                (itemResponse.data["kids"] != null ? itemResponse.data["kids"] as List : []).map((e) => e as int).toList(),
                itemResponse.data["score"] ?? 0,
                itemResponse.data["time"],
                itemResponse.data["title"] ?? "No title",
                itemResponse.data["type"] ?? "story",
                itemResponse.data["url"]??"",
                itemResponse.data["text"]??"");
            callback(item);
            storiesFetched++;
          } catch (e) {
            print(id);
            print(e);
          }
        }

      }
    } catch (e) {
      print(e);
    }
  }
}
