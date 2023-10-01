import 'package:dart_flutter_common/list.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../loading/ui/loading.dart';
import '../spot_difference.dart';

class CompletedUserScreen extends ConsumerStatefulWidget {
  const CompletedUserScreen({
    super.key,
    required this.roomId,
  });
  final String roomId;

  @override
  CompletedUserScreenState createState() => CompletedUserScreenState();
}

class CompletedUserScreenState extends ConsumerState<CompletedUserScreen>
    with TickerProviderStateMixin {
  final List<AnimationController> _controllers = [];

  @override
  void initState() {
    super.initState();
    Future(
      () async {
        // 上位10位で決め打ちしている
        for (var i = 0; i < 10; i++) {
          await Future<void>.delayed(const Duration(seconds: 2));
          setState(() {
            _controllers.add(
              AnimationController(
                vsync: this,
                duration: const Duration(seconds: 2),
              )..forward(),
            );
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final completedAppUsersAsyncValue =
        ref.watch(answeredAppUsersFutureProvider(widget.roomId));
    return completedAppUsersAsyncValue.when(
      data: (appUsers) {
        return Scaffold(
          backgroundColor: const Color(0xFFFAFAFA),
          floatingActionButton: ElevatedButton(
            child: const Text('リトライする'),
            onPressed: () {},
          ),
          body: Stack(
            children: [
              DecoratedBox(
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
                child: Stack(
                  children: [
                    const Center(
                      child: Text(
                        '結果発表',
                        style: TextStyle(
                          fontSize: 250,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Center(
                      child: ListView.builder(
                        reverse: true,
                        itemCount: _controllers.length,
                        itemBuilder: (context, index) {
                          final appUser = appUsers.safeGet(index);
                          final rank = appUsers.length - (index + 1);
                          if (appUser != null) {
                            final animateController = _controllers[index];
                            return Padding(
                              padding: const EdgeInsets.all(8),
                              child: Center(
                                child: FadeTransition(
                                  opacity: animateController,
                                  child: _RankingCard(
                                    imageUrl: appUser.imageUrl,
                                    displayName: appUser.displayName,
                                    index: rank,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: Lottie.asset(
                    'assets/lottie/confetti.json',
                    repeat: true,
                    reverse: false,
                    animate: true,
                  ),
                ),
              ),
            ],
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
  late final Color _backgroundColor;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..forward();

    _animation = Tween<double>(begin: 200, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    switch (widget.index) {
      case 0:
        _backgroundColor = const Color(0xFFFFD700);
      case 1:
        _backgroundColor = const Color(0xFFC0C0C0);
      case 2:
        _backgroundColor = const Color(0xFFCD7F32);
      default:
        _backgroundColor = Colors.grey[100]!;
    }
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
          color: _backgroundColor,
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
