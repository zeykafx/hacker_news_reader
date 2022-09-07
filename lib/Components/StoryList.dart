import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hacker_news_reader/Components/StoryReader.dart';
import 'package:skeletons/skeletons.dart';

import '../Api/HackerNewsApi.dart';
import '../models/item.dart';

class StoryList extends StatefulWidget {
  const StoryList({super.key});

  @override
  State<StoryList> createState() => _StoryListState();
}

class _StoryListState extends State<StoryList> {
  HackerNewsApi hackerNewsApi = HackerNewsApi();
  List<Item> topStories = [];
  int LIST_LENGTH = 50;

  void getTopStoriesCallBack(Item item) {
    setState(() {
      topStories.add(item);
    });
  }

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  void refreshData() {
    setState(() {
      topStories = [];
    });
    hackerNewsApi.getTopStories(LIST_LENGTH, getTopStoriesCallBack);
  }

  // TODO: add a page system, and in turns add an index for the fetching

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hacker News Reader"),
      ),
      body: Center(
          child: RefreshIndicator(
        onRefresh: () async {
          refreshData();
        },
        child: ListView.builder(
            itemCount: LIST_LENGTH,
            itemBuilder: (context, index) {
              // build all the stories for which we have data
              if (index < topStories.length) {
                return ListTile(
                  leading: Text("${index + 1}"),
                  title: Text(topStories[index].title),
                  subtitle: Text("${topStories[index].by} - ${Uri.parse(topStories[index].url).host} - ${topStories[index].score} points"),
                  trailing: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [const Icon(Icons.comment), Text("${topStories[index].kids.length}")],
                  ),
                  onTap: () {
                    if (topStories[index].type == "story") {
                      Get.to(
                          () => StoryReader(
                                item: topStories[index],
                              ),
                          transition: Transition.rightToLeft);
                    }
                  },
                );
              }
              // otherwise build a skeleton that vaguely ressembles the ListTile
              else {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(8, 20, 8, 20),
                  child: SkeletonItem(
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(4, 0, 24, 0),
                          child: SkeletonLine(
                            style: SkeletonLineStyle(height: 25, width: 25, borderRadius: BorderRadius.all(Radius.circular(25))),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: const [
                              SkeletonLine(
                                style: SkeletonLineStyle(
                                  height: 10,
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 2),
                                ),
                              ),
                              SkeletonLine(
                                style: SkeletonLineStyle(
                                  height: 10,
                                  width: 200,
                                  padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }),
      )),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Refresh"),
        onPressed: () {
          refreshData();
        },
        tooltip: 'Refresh',
        icon: const Icon(Icons.refresh),
      ),
    );
  }
}
