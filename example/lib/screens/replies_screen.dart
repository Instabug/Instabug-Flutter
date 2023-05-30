import 'package:flutter/material.dart';

import 'package:instabug_flutter/instabug_flutter.dart';

import '../widgets/feature_tile.dart';
import '../widgets/section_card.dart';
import '../widgets/separated_list_view.dart';

class RepliesScreen extends StatefulWidget {
  const RepliesScreen({super.key});

  @override
  State<RepliesScreen> createState() => _RepliesScreenState();
}

class _RepliesScreenState extends State<RepliesScreen> {
  var hasChats = false;
  var count = 0;

  @override
  void initState() {
    super.initState();
    callRepliesAsyncAPIs();
  }

  Future<void> callRepliesAsyncAPIs() async {
    hasChats = await Replies.hasChats();
    count = await Replies.getUnreadRepliesCount();
    setState(() {
      hasChats = hasChats;
      count = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Replies',
        ),
      ),
      body: MediaQuery.removePadding(
        context: context,
        removeBottom: true,
        removeTop: true,
        child: SeparatedListView(
          padding: const EdgeInsets.all(8.0),
          separator: const SizedBox(
            height: 8.0,
          ),
          children: [
            SectionCard(
              children: [
                FeatureTile(
                  leading: const Icon(Icons.chat_bubble),
                  title: const Text('Show'),
                  onTap: () => Replies.show(),
                ),
                FeatureTile(
                  leading: const Icon(Icons.chat),
                  title: const Text('Has Chats'),
                  trailing: hasChats
                      ? const Icon(
                          Icons.check,
                          color: Colors.green,
                        )
                      : const Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
                ),
                FeatureTile(
                  leading: const Icon(Icons.mark_chat_unread),
                  title: const Text('Unread Replies Count'),
                  trailing: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      count.toString(),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
