import 'package:flutter/material.dart';

class WorkerChat extends StatefulWidget {
  const WorkerChat({Key? key}) : super(key: key);

  @override
  _WorkerChatState createState() => _WorkerChatState();
}

class _WorkerChatState extends State<WorkerChat> {
  final List<String> messages = [
    'Hello',
    'Hi, how are you?',
    'I\'m good, thanks!',
    'What about you?',
    'I\'m doing great!',
    'That\'s good to hear.',
    'Bye!',
    'Goodbye!'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppBar(
                title: Row(
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/profile.png'),
                    ),
                    const SizedBox(width: 8.0),
                    const Text(
                      'Worker.Name',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.phone),
                      onPressed: () {
                        // Add logic for phone icon
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.videocam),
                      onPressed: () {
                        // Add logic for video call icon
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.info),
                      onPressed: () {
                        // Add logic for info icon
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = index % 2 == 0;

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              30.0), // Adjust the value for more/less curvature
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            decoration: BoxDecoration(
                              color: isMe ? Colors.blue : Colors.grey,
                            ),
                            child: Text(
                              message,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.attach_file),
                      onPressed: () {
                        // Handle attachment logic
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.camera_alt),
                      onPressed: () {
                        // Handle camera logic
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.photo),
                      onPressed: () {
                        // Handle photo logic
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.mic),
                      onPressed: () {
                        // Handle recording logic
                      },
                    ),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          const newMessage = 'New message';
                          messages.add(newMessage);
                        });

                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          final scrollController =
                              PrimaryScrollController.of(context);
                          scrollController.animateTo(
                            scrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        });
                      },
                      child: const Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
