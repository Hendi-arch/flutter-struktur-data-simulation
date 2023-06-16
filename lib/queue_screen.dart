import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:struktur_data_demo/colored_item.dart';
import 'package:struktur_data_demo/helpers.dart';
import 'package:struktur_data_demo/source_code_widget.dart';

class QueueScreen extends StatefulWidget {
  const QueueScreen({Key? key}) : super(key: key);

  @override
  State<QueueScreen> createState() => _QueueScreenState();
}

class _QueueScreenState extends State<QueueScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<ColoredItem> queueItems = []; // Queue items
  final TextEditingController _maxQueueController =
      TextEditingController(); // Control maximum size limit for the queue
  final GlobalKey<FormState> _textEditingState = GlobalKey<FormState>();
  final ScrollController scrollController = ScrollController();

  bool enqueueItem() {
    if (_textEditingState.currentState!.validate()) {
      if (queueItems.length >= int.parse(_maxQueueController.text)) {
        // Show a message when the queue size exceeds the maximum limit
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Queue is full! ${_maxQueueController.text}'),
            showCloseIcon: true,
          ),
        );
        return false;
      } else {
        final randomColor = getRandomColor();
        final index = queueItems.length != (queueItems.lastOrNull?.index ?? 0)
            ? queueItems.last.index! + 1
            : queueItems.length + 1;
        final item = ColoredItem.queue(
          color: randomColor,
          index: index,
          value: 'Queue data $index',
        );
        setState(() {
          // Add a random colored item to the queue
          queueItems.add(item);
          _listKey.currentState!.insertItem(queueItems.length - 1);
        });
        scrollTo(
            scrollController, scrollController.position.maxScrollExtent + 60);
      }
    }
    return true;
  }

  void enqueueAllItem() async {
    if (_textEditingState.currentState!.validate()) {
      int count = int.parse(_maxQueueController.text) - queueItems.length;

      if (count.isNegative) {
        await scrollTo(
            scrollController, scrollController.position.minScrollExtent);

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'The data queue has reached its limit, making reductions...',
            ),
            showCloseIcon: true,
          ),
        );

        for (var i = 0; i < count.abs(); i++) {
          if (!mounted) break;
          await Future.delayed(const Duration(milliseconds: 300));
          if (!mounted) break;
          dequeueItem();
        }
      } else {
        for (var i = 0; i < count; i++) {
          if (!mounted) break;
          await Future.delayed(const Duration(milliseconds: 300));
          if (!mounted) break;
          if (!enqueueItem()) break;
        }
      }
    }
  }

  void dequeueItem() {
    if (queueItems.isNotEmpty) {
      setState(() {
        // Remove the front item from the queue
        final removedItem = queueItems.removeAt(0);
        _listKey.currentState!.removeItem(
          0,
          (context, animation) => SlideTransition(
            position: animation.drive(
              Tween<Offset>(
                begin: const Offset(-1, 0),
                end: const Offset(0, 0),
              ),
            ),
            child: Card(
              elevation: 5.0,
              color: removedItem.color,
              child: ListTile(
                title: Text(removedItem.value),
              ),
            ),
          ),
        );
      });
    }
  }

  void peekItem() {
    if (queueItems.isNotEmpty) {
      setState(() {
        queueItems.first.isFlat = false;
        queueItems.first.height = 120;
      });

      Future.delayed(const Duration(milliseconds: 350), () async {
        await scrollTo(
            scrollController, scrollController.position.minScrollExtent);
      });

      Future.delayed(const Duration(milliseconds: 3000), () {
        setState(() {
          queueItems.first.isFlat = true;
          queueItems.first.height = 45;
        });
      });

      // Returns the front element from the queue without removing it.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Front element from the queue: ${queueItems.first.value}',
          ),
          showCloseIcon: true,
        ),
      );
    }
  }

  void isQueueEmpty() {
    // Checks if the queue is empty.
    String message =
        queueItems.isEmpty ? 'Queue is empty.' : 'Queue is not empty.';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        showCloseIcon: true,
      ),
    );
  }

  void checkQueueSize() {
    // Returns the number of elements in the queue.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Number of elements in the queue: ${queueItems.length}'),
        showCloseIcon: true,
      ),
    );
  }

  void clearQueue() async {
    // Clear all of elements in the queue.
    if (queueItems.isNotEmpty) {
      await scrollTo(
          scrollController, scrollController.position.minScrollExtent);
      while (queueItems.isNotEmpty) {
        if (!mounted) break;
        await Future.delayed(const Duration(milliseconds: 300));
        if (!mounted) break;
        dequeueItem();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Array Queue Demo'),
        centerTitle: true,
        actions: const [SourceCodeWidget()],
      ),
      body: Form(
        key: _textEditingState,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              children: [
                Wrap(
                  runSpacing: 16.0,
                  spacing: 16.0,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    SizedBox(
                      width: 200,
                      child: TextFormField(
                        controller: _maxQueueController,
                        decoration: const InputDecoration(
                          hintText: 'Max queue data',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the maximum';
                          }
                          return null;
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: enqueueAllItem,
                      child: const Text('Enqueue All'),
                    ),
                    ElevatedButton(
                      onPressed: enqueueItem,
                      child: const Text('Enqueue'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await scrollTo(scrollController,
                            scrollController.position.minScrollExtent);
                        dequeueItem();
                      },
                      child: const Text('Dequeue'),
                    ),
                    ElevatedButton(
                      onPressed: peekItem,
                      child: const Text('Peek'),
                    ),
                    ElevatedButton(
                      onPressed: isQueueEmpty,
                      child: const Text('IsEmpty'),
                    ),
                    ElevatedButton(
                      onPressed: checkQueueSize,
                      child: const Text('Size'),
                    ),
                    ElevatedButton(
                      onPressed: clearQueue,
                      child: const Text('Clear Queue'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Card(
                    child: AnimatedList(
                      key: _listKey,
                      reverse: true,
                      controller: scrollController,
                      padding: const EdgeInsets.all(5),
                      itemBuilder: (context, index, animation) {
                        return SlideTransition(
                          position: animation.drive(
                            Tween<Offset>(
                              begin: const Offset(0, -1),
                              end: const Offset(0, 0),
                            ),
                          ),
                          child: AnimatedPhysicalModel(
                            curve: Curves.fastOutSlowIn,
                            shape: BoxShape.rectangle,
                            duration: const Duration(milliseconds: 300),
                            color: queueItems[index].isFlat
                                ? Colors.transparent
                                : Theme.of(context).colorScheme.surface,
                            elevation: queueItems[index].isFlat ? 0.0 : 20.0,
                            borderRadius: BorderRadius.circular(12.0),
                            shadowColor: queueItems[index].color,
                            child: Card(
                              color: queueItems[index].color,
                              child: AnimatedSize(
                                duration: const Duration(milliseconds: 300),
                                child: SizedBox(
                                  height: queueItems[index].height.h,
                                  child: Center(
                                    child: ListTile(
                                      title: Text(queueItems[index].value),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      initialItemCount: queueItems.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
