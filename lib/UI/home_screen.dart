import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_chat_application/repository/chat_repo.dart';
import '../bloc/chat/chat_bloc.dart';
import '../bloc/users/users_bloc.dart';
import '../bloc/users/users_event.dart';
import '../bloc/users/users_state.dart';
import '../utils/tabbar_design.dart';
import 'chat_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.white,
              leading: const SizedBox(),
              floating: true,
              snap: true,
              pinned: false,
              centerTitle: true,
              elevation: 0,
              title: TopSwitcher(
                selectedIndex: selectedTab,
                onChanged: (i) => setState(() => selectedTab = i),
              ),
            ),
          ];
        },

        body: IndexedStack(
          index: selectedTab,
          children: [
            usersTab(),
            chatHistoryTab(context),
          ],
        ),
      ),

      floatingActionButton: selectedTab == 0
          ? FloatingActionButton(
        onPressed: () {
          final name =
              "User ${DateTime.now().millisecondsSinceEpoch % 100}";
          context.read<UsersBloc>().add(AddUser(name));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("$name added"),
            duration: const Duration(seconds: 1),
            backgroundColor: Colors.green,),
          );
        },
        child: const Icon(Icons.add),
      )
          : null,
    );
  }

  Widget usersTab() {
    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, state) {
        if (state.chats.isEmpty) {
          return const Center(
            child: Text(
              "No users added yet",
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return CustomScrollView(
          key: const PageStorageKey('users_scroll'),
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final name = state.chats[index];

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    leading: Stack(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.deepPurple,
                          child: Text(
                            name.userName[0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    title: Text(
                      name.userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: const Text(
                      "Online",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider(
                            create: (_) => ChatBloc(
                              userName: name.userName,
                              usersBloc: context.read<UsersBloc>(),
                              repository: ChatRepositoryImpl(),
                            ),
                            child: ChatScreen(userName: name.userName),
                          ),
                        ),
                      );
                    },
                  );
                },
                childCount: state.chats.length,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget chatHistoryTab(BuildContext context) {
    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, state) {
        if (state.chats.isEmpty) {
          return const Center(child: Text("No chats yet"));
        }

        return CustomScrollView(
          key: const PageStorageKey('chat_history_scroll'),
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final chat = state.chats[index];
                  final last = chat.lastMessage;

                  return ListTile(
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.green,
                      child: Text(
                        chat.userName[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    title: Text(chat.userName),
                    subtitle: Text(
                      last?.text ?? "No messages yet",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Text(
                      last != null
                          ? TimeOfDay.fromDateTime(last.time).format(context)
                          : "",
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider(
                            create: (_) => ChatBloc(
                              userName: chat.userName,
                              usersBloc: context.read<UsersBloc>(),
                              repository: ChatRepositoryImpl()
                            ),
                            child: ChatScreen(userName: chat.userName),
                          ),
                        ),
                      );
                    },
                  );
                },
                childCount: state.chats.length,
              ),
            ),
          ],
        );
      },
    );
  }
}

