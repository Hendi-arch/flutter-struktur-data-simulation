// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:struktur_data_demo/colored_item.dart';
import 'package:struktur_data_demo/helpers.dart';

class StackScreen extends StatefulWidget {
  const StackScreen({super.key});

  @override
  State<StackScreen> createState() => _StackScreenState();
}

class _StackScreenState extends State<StackScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<ColoredItem> stackItems = []; // Stack items
  final TextEditingController _maxStackController =
      TextEditingController(); // Control maximum size limit for the stack
  final GlobalKey<FormState> _textEditingState = GlobalKey<FormState>();
  final ScrollController scrollController = ScrollController();

  bool pushItem() {
    if (_textEditingState.currentState!.validate()) {
      if (stackItems.length >= int.parse(_maxStackController.text)) {
        // Show a message when the stack size exceeds the maximum limit
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Stack is full! ${_maxStackController.text}'),
            showCloseIcon: true,
          ),
        );
        return false;
      } else {
        final randomColor = getRandomColor();
        final item = ColoredItem.stack(
          color: randomColor,
          value: 'Stack data ${stackItems.length + 1}',
        );
        setState(() {
          // Add a random colored item to the stack
          stackItems.add(item);
          _listKey.currentState!.insertItem(stackItems.length - 1);
        });
        scrollTo(
            scrollController, scrollController.position.maxScrollExtent + 60);
      }
    }
    return true;
  }

  void pushAllItem() async {
    if (_textEditingState.currentState!.validate()) {
      int count = int.parse(_maxStackController.text) - stackItems.length;

      if (count.isNegative) {
        await scrollTo(
            scrollController, scrollController.position.maxScrollExtent);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'The data stack has reached its limit, making reductions...',
            ),
            showCloseIcon: true,
          ),
        );

        for (var i = 0; i < count.abs(); i++) {
          if (!mounted) break;
          await Future.delayed(const Duration(milliseconds: 300));
          if (!mounted) break;
          popItem();
        }
      } else {
        for (var i = 0; i < count; i++) {
          if (!mounted) break;
          await Future.delayed(const Duration(milliseconds: 300));
          if (!mounted) break;
          if (!pushItem()) break;
        }
      }
    }
  }

  void popItem() {
    if (stackItems.isNotEmpty) {
      setState(() {
        // Remove the top item from the stack
        final removedItem = stackItems.removeLast();
        _listKey.currentState!.removeItem(
          stackItems.length,
          (context, animation) => SlideTransition(
            position: animation.drive(
              Tween<Offset>(
                begin: const Offset(0, -1),
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
    if (stackItems.isNotEmpty) {
      setState(() {
        stackItems.last.isFlat = false;
        stackItems.last.height = 120;
      });

      Future.delayed(const Duration(milliseconds: 350), () async {
        await scrollTo(
            scrollController, scrollController.position.maxScrollExtent);
      });

      Future.delayed(const Duration(milliseconds: 3000), () {
        setState(() {
          stackItems.last.isFlat = true;
          stackItems.last.height = 45;
        });
      });

      // Returns the topmost element from the stack without removing it.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Topmost element from the stack: Stack data ${stackItems.length}',
          ),
          showCloseIcon: true,
        ),
      );
    }
  }

  void isStackEmpty() {
    // Checks if the stack is empty.
    String message =
        stackItems.isEmpty ? 'Stack is empty.' : 'Stack is not empty.';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        showCloseIcon: true,
      ),
    );
  }

  void checkStackSize() {
    // Returns the number of elements in the stack.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Number of elements in the stack ${stackItems.length}.'),
        showCloseIcon: true,
      ),
    );
  }

  void clearStack() async {
    // Clear all of elements in the stack.
    if (stackItems.isNotEmpty) {
      await scrollTo(
          scrollController, scrollController.position.maxScrollExtent);
      while (stackItems.isNotEmpty) {
        if (!mounted) break;
        await Future.delayed(const Duration(milliseconds: 300));
        if (!mounted) break;
        popItem();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Array Stack Demo'),
        centerTitle: true,
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
                        controller: _maxStackController,
                        decoration: const InputDecoration(
                          hintText: 'Max stack data',
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
                      onPressed: pushAllItem,
                      child: const Text('Push All'),
                    ),
                    ElevatedButton(
                      onPressed: pushItem,
                      child: const Text('Push'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await scrollTo(scrollController,
                            scrollController.position.maxScrollExtent);
                        popItem();
                      },
                      child: const Text('Pop'),
                    ),
                    ElevatedButton(
                      onPressed: peekItem,
                      child: const Text('Peek'),
                    ),
                    ElevatedButton(
                      onPressed: isStackEmpty,
                      child: const Text('IsEmpty'),
                    ),
                    ElevatedButton(
                      onPressed: checkStackSize,
                      child: const Text('Size'),
                    ),
                    ElevatedButton(
                      onPressed: clearStack,
                      child: const Text('Clear Stack'),
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
                            color: stackItems[index].isFlat
                                ? Colors.transparent
                                : Theme.of(context).colorScheme.surface,
                            elevation: stackItems[index].isFlat ? 0.0 : 20.0,
                            borderRadius: BorderRadius.circular(12.0),
                            shadowColor: stackItems[index].color,
                            child: Card(
                              color: stackItems[index].color,
                              child: AnimatedSize(
                                duration: const Duration(milliseconds: 300),
                                child: SizedBox(
                                  height: stackItems[index].height.h,
                                  child: Center(
                                    child: ListTile(
                                      title: Text(stackItems[index].value),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      initialItemCount: stackItems.length,
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
