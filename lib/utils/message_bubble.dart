import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_chat_application/repository/meaning_repo.dart';
import '../bloc/meaning/meaning_bloc.dart';
import '../bloc/meaning/meaning_event.dart';
import '../bloc/meaning/meaning_state.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isSender;
  final DateTime? time;
  final String? userName;

  const MessageBubble({
    super.key,
    required this.text,
    required this.isSender,
    this.time,
    this.userName
  });


  void showMeaningBottomSheet(BuildContext context, String word) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return BlocProvider(
          create: (_) => MeaningBloc( MeaningRepositoryImpl())..add(FetchMeaning(word)),
          child: BlocBuilder<MeaningBloc, MeaningState>(
            builder: (context, state) {
              return Container(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 12,
                  bottom: 24,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Text(
                      word.toLowerCase(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (state is MeaningLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: CircularProgressIndicator(),
                        ),
                      ),

                    if (state is MeaningLoaded)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          state.meaning,
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.5,
                            color: Colors.black87,
                          ),
                        ),
                      ),

                    if (state is MeaningError)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bubbleColor =
    isSender ? const Color(0xFF2F6BFF) : Colors.grey.shade200;

    final textColor = isSender ? Colors.white : Colors.black;

    final borderRadius = BorderRadius.only(
      topLeft: isSender ? const Radius.circular(16) : const Radius.circular(4),
      topRight: isSender ? const Radius.circular(4) : const Radius.circular(16),
      bottomLeft:const Radius.circular(16),
      bottomRight: const Radius.circular(16),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        mainAxisAlignment:
        isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isSender)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Colors.deepPurple,
                child: Text(
                  userName![0].toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),

          Column(
            crossAxisAlignment:
            isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                constraints: const BoxConstraints(maxWidth: 260),
                padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: bubbleColor,
                  borderRadius: borderRadius,
                ),
                child: Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: text.split(' ').map((word) {
                    return GestureDetector(
                      onLongPress: () =>
                          showMeaningBottomSheet(context, word),

                      child: Text(
                        word,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 15,
                          height: 1.35,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 4),

              Text(
                _formatTime(time ?? DateTime.now()),
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
            ],
          ),

          if (isSender)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Colors.purple,
                child: const Text(
                  "Y",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  static String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour > 12
        ? dateTime.hour - 12
        : dateTime.hour == 0
        ? 12
        : dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? "PM" : "AM";
    return "$hour:$minute $period";
  }
}
