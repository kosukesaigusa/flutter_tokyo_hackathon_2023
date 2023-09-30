import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../loading/ui/loading.dart';
import '../spot_difference.dart';

class CompletedUserScreen extends ConsumerWidget {
  const CompletedUserScreen({
    required this.roomId,
    super.key,
  });

  final String roomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completedAppUsersAsyncValue =
        ref.watch(completedAppUsersFutureProvider(roomId));

    return completedAppUsersAsyncValue.when(
      data: (appUsers) {
        return Scaffold(
          backgroundColor: const Color(0xFFFAFAFA),
          body: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFDEB71),
                  Color(0xFFFB7D64),
                ],
              ),
            ),
            child: Center(
              child: ListView.builder(
                itemCount: appUsers.length,
                itemBuilder: (context, index) {
                  final appUser = appUsers[index];
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: Center(
                      child: _RankingCard(
                        imageUrl: appUser?.imageUrl,
                        displayName: appUser?.displayName,
                        index: index,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
      error: (e, st) => Text(e.toString()),
      loading: () => const OverlayLoading(),
    );
  }
}

class _RankingCard extends StatefulWidget {
  const _RankingCard({
    required this.imageUrl,
    required this.displayName,
    required this.index,
  });

  final int index;
  final String? imageUrl;
  final String? displayName;

  @override
  _RankingCardState createState() => _RankingCardState();
}

class _RankingCardState extends State<_RankingCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();

    _animation = Tween<double>(begin: 200, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: Opacity(
            opacity: _controller.value,
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        width: 400,
        child: Row(
          children: [
            Text((widget.index + 1).toString()),
            const SizedBox(
              width: 10,
            ),
            if (widget.imageUrl != null)
              CircleAvatar(
                backgroundImage: NetworkImage(widget.imageUrl!),
                radius: 30,
              )
            else
              CircleAvatar(
                backgroundColor: Colors.grey[200],
                radius: 30,
                child: const Icon(
                  Icons.person,
                ),
              ),
            const SizedBox(
              width: 10,
            ),
            Text(
              widget.displayName ?? '',
            ),
          ],
        ),
      ),
    );
  }
}
