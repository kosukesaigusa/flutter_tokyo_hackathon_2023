import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../loading/ui/loading.dart';
import '../../root/ui/root.dart';
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
  bool canPop = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future(
      () async {
        // 上位10位で決め打ちしている
        for (var i = 0; i < 10; i++) {
          await Future<void>.delayed(const Duration(seconds: 1));
          setState(() {
            _controllers.add(
              AnimationController(
                vsync: this,
                duration: const Duration(seconds: 2),
              )..forward(),
            );
          });
        }
        setState(() {
          canPop = true;
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    for (final controller in _controllers) {
      controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(answersStreamProvider(widget.roomId)).when(
          data: (answers) {
            if (answers.isNotEmpty) {
              answers.sort((a, b) {
                if (a.updatedAt == null || b.updatedAt == null) {
                  return 0;
                }
                if (a.pointIds.length > b.pointIds.length) {
                  return -1;
                } else if (a.pointIds.length < b.pointIds.length) {
                  return 1;
                } else {
                  return a.updatedAt!.compareTo(b.updatedAt!);
                }
              });
            }
            final topAnswers = answers.take(10).toList();

            return Scaffold(
              backgroundColor: const Color(0xFFFAFAFA),
              floatingActionButton: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    canPop ? Colors.orange : Colors.grey,
                  ),
                ),
                child: const Text('もう一度あそぶ'),
                onPressed: () async {
                  if (canPop) {
                    await Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute<void>(
                        builder: (context) => const RootPage(),
                      ),
                      (route) => false,
                    );
                  }
                },
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
                            controller: _scrollController,
                            shrinkWrap: true,
                            reverse: true,
                            itemCount: _controllers.length,
                            itemBuilder: (context, index) {
                              if (index >= topAnswers.length) {
                                return const SizedBox();
                              }
                              final appUser = ref
                                  .watch(
                                    appUsersStreamProvider(
                                      topAnswers[index].answerId,
                                    ),
                                  )
                                  .valueOrNull;
                              final spotDifference = ref
                                  .watch(
                                    spotDifferenceFutureProvider(
                                      widget.roomId,
                                    ),
                                  )
                                  .valueOrNull;
                              final rank = topAnswers.length - (index + 1);

                              // 一番最後までスクロールさせる
                              if (index == _controllers.length - 1) {
                                _scrollController.animateTo(
                                  _scrollController.position.maxScrollExtent,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOut,
                                );
                              }
                              if (appUser != null && spotDifference != null) {
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
                                        answerPoints:
                                            answers[index].pointIds.length,
                                        totalPoints:
                                            spotDifference.pointIds.length,
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
    required this.totalPoints,
    required this.answerPoints,
  });

  final int index;
  final String? imageUrl;
  final String? displayName;
  final int totalPoints;
  final int answerPoints;

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

  TextStyle _textStyle(int ranking) {
    switch (ranking) {
      case 1:
        return const TextStyle(fontSize: 30, fontWeight: FontWeight.w900);
      case 2:
        return const TextStyle(fontSize: 25, fontWeight: FontWeight.w800);
      case 3:
        return const TextStyle(fontSize: 20, fontWeight: FontWeight.w700);
      default:
        return const TextStyle(fontSize: 15, fontWeight: FontWeight.bold);
    }
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
        width: 450,
        child: ListTile(
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 30,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  (widget.index + 1).toString(),
                  style: _textStyle(widget.index + 1),
                  textAlign: TextAlign.center,
                ),
              ),
              const Gap(10),
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
            ],
          ),
          title: Text(
            widget.displayName ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text(
            '${widget.answerPoints}/${widget.totalPoints}',
          ),
        ),
      ),
    );
  }
}
