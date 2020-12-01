library flutter_tindercard;

import 'dart:math';

import 'package:flutter/material.dart';
import './movieInfo.dart';

enum TriggerDirection { none, RIGHT, LEFT, UP, DOWN }

/// A Tinder-Like Widget.
class TinderSwapCard extends StatefulWidget {
  final CardBuilder _cardBuilder;

  final int _totalNum;

  final int _stackNum;

  final int _animDuration;

  final double _swipeEdge;

  final double _swipeEdgeVertical;

  final bool _swipeUP;

  final bool _swipeDOWN;

  final bool _allowVerticalMovement;

  final CardSwipeCompleteCallback swipeCompleteCallback;

  final CardDragUpdateCallback swipeUpdateCallback;

  final CardController cardController;

  final List<Size> _cardSizes = [];

  final List<Alignment> _cardAligns = [];

  @override
  _TinderSwapCardState createState() => _TinderSwapCardState();

  TinderSwapCard({
    @required CardBuilder cardBuilder,
    @required int totalNum,
    AmassOrientation orientation = AmassOrientation.BOTTOM,
    int stackNum = 3,
    int animDuration = 800,
    double swipeEdge = 3.0,
    double swipeEdgeVertical = 8.0,
    bool swipeUP = false,
    bool swipeDOWN = false,
    double maxWidth,
    double maxHeight,
    double minWidth,
    double minHeight,
    bool allowVerticalMovement = true,
    this.cardController,
    this.swipeCompleteCallback,
    this.swipeUpdateCallback,
  })  : assert(stackNum > 1),
        assert(swipeEdge > 0),
        assert(swipeEdgeVertical > 0),
        assert(maxWidth > minWidth && maxHeight > minHeight),
        _cardBuilder = cardBuilder,
        _totalNum = totalNum,
        _stackNum = stackNum,
        _animDuration = animDuration,
        _swipeEdge = swipeEdge,
        _swipeEdgeVertical = swipeEdgeVertical,
        _swipeUP = swipeUP,
        _swipeDOWN = swipeDOWN,
        _allowVerticalMovement = allowVerticalMovement {
    final widthGap = maxWidth - minWidth;
    final heightGap = maxHeight - minHeight;

    for (var i = 0; i < _stackNum; i++) {
      _cardSizes.add(
        Size(minWidth + (widthGap / _stackNum) * i,
            minHeight + (heightGap / _stackNum) * i),
      );

      switch (orientation) {
        case AmassOrientation.BOTTOM:
          _cardAligns.add(
            Alignment(
              0.0,
              (0.5 / (_stackNum - 1)) * (stackNum - i),
            ),
          );
          break;
        case AmassOrientation.TOP:
          _cardAligns.add(
            Alignment(
              0.0,
              (-0.5 / (_stackNum - 1)) * (stackNum - i),
            ),
          );
          break;
        case AmassOrientation.LEFT:
          _cardAligns.add(
            Alignment(
              (-0.5 / (_stackNum - 1)) * (stackNum - i),
              0.0,
            ),
          );
          break;
        case AmassOrientation.RIGHT:
          _cardAligns.add(
            Alignment(
              (0.5 / (_stackNum - 1)) * (stackNum - i),
              0.0,
            ),
          );
          break;
      }
    }
  }
}

class _TinderSwapCardState extends State<TinderSwapCard>
    with TickerProviderStateMixin {
  Alignment frontCardAlign;

  AnimationController _animationController;

  int _currentFront;

  static TriggerDirection _trigger;

  Widget _buildCard(BuildContext context, int realIndex) {
    if (realIndex < 0) {
      return Container();
    }
    // _currentFront = realIndex - 1;
    final index = realIndex - _currentFront;
    // print('tinder index $index');
    // print("realIndex $realIndex");
    // print('count $count');
    // print('_currentFront $_currentFront');

    if (index == widget._stackNum - 1) {
      return Align(
        alignment: _animationController.status == AnimationStatus.forward
            ? frontCardAlign = CardAnimation.frontCardAlign(
                _animationController,
                frontCardAlign,
                widget._cardAligns[widget._stackNum - 1],
                widget._swipeEdge,
                widget._swipeUP,
                widget._swipeDOWN,
              ).value
            : frontCardAlign,
        child: Transform.rotate(
          angle: (pi / 180.0) *
              (_animationController.status == AnimationStatus.forward
                  ? CardAnimation.frontCardRota(
                          _animationController, frontCardAlign.x)
                      .value
                  : frontCardAlign.x),
          child: SizedBox.fromSize(
            size: widget._cardSizes[index],
            child: widget._cardBuilder(
              context,
              // widget._totalNum - realIndex - 1,
              widget._totalNum - (99 - count) - 1,
            ),
          ),
        ),
      );
    }

    return Align(
      alignment: _animationController.status == AnimationStatus.forward &&
              (frontCardAlign.x > 3.0 ||
                  frontCardAlign.x < -3.0 ||
                  frontCardAlign.y > 3 ||
                  frontCardAlign.y < -3)
          ? CardAnimation.backCardAlign(
              _animationController,
              widget._cardAligns[index],
              widget._cardAligns[index + 1],
            ).value
          : widget._cardAligns[index],
      child: SizedBox.fromSize(
        size: _animationController.status == AnimationStatus.forward &&
                (frontCardAlign.x > 3.0 ||
                    frontCardAlign.x < -3.0 ||
                    frontCardAlign.y > 3 ||
                    frontCardAlign.y < -3)
            ? CardAnimation.backCardSize(
                _animationController,
                widget._cardSizes[index],
                widget._cardSizes[index + 1],
              ).value
            : widget._cardSizes[index],
        child: widget._cardBuilder(
          context,
          widget._totalNum - (99 - count),
        ),
      ),
    );
  }

  List<Widget> _buildCards(BuildContext context) {
    final cards = <Widget>[];

    for (var i = _currentFront; i < _currentFront + widget._stackNum; i++) {
      cards.add(_buildCard(context, i));
    }

    cards.add(SizedBox.expand(
      child: GestureDetector(
        onPanUpdate: (final details) {
          setState(() {
            if (widget._allowVerticalMovement == true) {
              frontCardAlign = Alignment(
                frontCardAlign.x +
                    details.delta.dx * 20 / MediaQuery.of(context).size.width,
                frontCardAlign.y +
                    details.delta.dy * 30 / MediaQuery.of(context).size.height,
              );
            } else {
              frontCardAlign = Alignment(
                frontCardAlign.x +
                    details.delta.dx * 20 / MediaQuery.of(context).size.width,
                0,
              );

              if (widget.swipeUpdateCallback != null) {
                widget.swipeUpdateCallback(details, frontCardAlign);
              }
            }

            if (widget.swipeUpdateCallback != null) {
              widget.swipeUpdateCallback(details, frontCardAlign);
            }
          });
        },
        onPanEnd: (final details) {
          animateCards(TriggerDirection.none);
        },
      ),
    ));
    return cards;
  }

  void animateCards(TriggerDirection trigger) {
    if (_animationController.isAnimating ||
        _currentFront + widget._stackNum == 0) {
      return;
    }
    _trigger = trigger;
    _animationController.stop();
    _animationController.value = 0.0;
    _animationController.forward();
  }

  void triggerSwap(TriggerDirection trigger) {
    animateCards(trigger);
  }

  // sUPport for asynchronous data events
  @override
  void didUpdateWidget(covariant TinderSwapCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget._totalNum != oldWidget._totalNum) {
      _initState();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initState();
  }

  void _initState() {
    _currentFront = widget._totalNum - widget._stackNum;

    frontCardAlign = widget._cardAligns[widget._cardAligns.length - 1];

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: widget._animDuration,
      ),
    );

    _animationController.addListener(() => setState(() {}));

    _animationController.addStatusListener(
      (final status) {
        final index = widget._totalNum - widget._stackNum - _currentFront;

        if (status == AnimationStatus.completed) {
          CardSwipeOrientation orientation;

          if (frontCardAlign.x < -widget._swipeEdge) {
            orientation = CardSwipeOrientation.LEFT;
          } else if (frontCardAlign.x > widget._swipeEdge) {
            orientation = CardSwipeOrientation.RIGHT;
          } else if (frontCardAlign.y < -widget._swipeEdgeVertical) {
            orientation = CardSwipeOrientation.UP;
          } else if (frontCardAlign.y > widget._swipeEdgeVertical) {
            orientation = CardSwipeOrientation.DOWN;
          } else {
            frontCardAlign = widget._cardAligns[widget._stackNum - 1];
            orientation = CardSwipeOrientation.recover;
          }

          if (widget.swipeCompleteCallback != null) {
            widget.swipeCompleteCallback(orientation, index);
          }

          if (orientation != CardSwipeOrientation.recover) changeCardOrder();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    widget.cardController?.addListener(triggerSwap);

    return Stack(children: _buildCards(context));
  }

  void changeCardOrder() {
    setState(() {
      _currentFront--;
      frontCardAlign = widget._cardAligns[widget._stackNum - 1];
    });
  }
}

typedef CardBuilder = Widget Function(BuildContext context, int index);

enum CardSwipeOrientation { LEFT, RIGHT, recover, UP, DOWN }

/// swipe card to [CardSwipeOrientation.LEFT] or [CardSwipeOrientation.RIGHT]
/// , [CardSwipeOrientation.recover] means back to start.
typedef CardSwipeCompleteCallback = void Function(
    CardSwipeOrientation orientation, int index);

/// [DragUPdateDetails] of swiping card.
typedef CardDragUpdateCallback = void Function(
    DragUpdateDetails details, Alignment align);

enum AmassOrientation { TOP, BOTTOM, LEFT, RIGHT }

class CardAnimation {
  static Animation<Alignment> frontCardAlign(
    AnimationController controller,
    Alignment beginAlign,
    Alignment baseAlign,
    double swipeEdge,
    bool swipeUP,
    bool swipeDOWN,
  ) {
    double endX, endY;

    if (_TinderSwapCardState._trigger == TriggerDirection.none) {
      endX = beginAlign.x > 0
          ? (beginAlign.x > swipeEdge ? beginAlign.x + 10.0 : baseAlign.x)
          : (beginAlign.x < -swipeEdge ? beginAlign.x - 10.0 : baseAlign.x);
      endY = beginAlign.x > 3.0 || beginAlign.x < -swipeEdge
          ? beginAlign.y
          : baseAlign.y;

      if (swipeUP || swipeDOWN) {
        if (beginAlign.y < 0) {
          if (swipeUP) {
            endY =
                beginAlign.y < -swipeEdge ? beginAlign.y - 10.0 : baseAlign.y;
          }
        } else if (beginAlign.y > 0) {
          if (swipeDOWN) {
            endY = beginAlign.y > swipeEdge ? beginAlign.y + 10.0 : baseAlign.y;
          }
        }
      }
    } else if (_TinderSwapCardState._trigger == TriggerDirection.LEFT) {
      endX = beginAlign.x - swipeEdge;
      endY = beginAlign.y + 0.5;
    }
    /* Trigger Swipe UP or DOWN */
    else if (_TinderSwapCardState._trigger == TriggerDirection.UP ||
        _TinderSwapCardState._trigger == TriggerDirection.DOWN) {
      var beginY =
          _TinderSwapCardState._trigger == TriggerDirection.UP ? -10 : 10;

      endY = beginY < -swipeEdge ? beginY - 10.0 : baseAlign.y;

      endX = beginAlign.x > 0
          ? (beginAlign.x > swipeEdge ? beginAlign.x + 10.0 : baseAlign.x)
          : (beginAlign.x < -swipeEdge ? beginAlign.x - 10.0 : baseAlign.x);
    } else {
      endX = beginAlign.x + swipeEdge;
      endY = beginAlign.y + 0.5;
    }
    return AlignmentTween(
      begin: beginAlign,
      end: Alignment(endX, endY),
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ),
    );
  }

  static Animation<double> frontCardRota(
      AnimationController controller, double beginRot) {
    return Tween(begin: beginRot, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ),
    );
  }

  static Animation<Size> backCardSize(
    AnimationController controller,
    Size beginSize,
    Size endSize,
  ) {
    return SizeTween(begin: beginSize, end: endSize).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ),
    );
  }

  static Animation<Alignment> backCardAlign(
    AnimationController controller,
    Alignment beginAlign,
    Alignment endAlign,
  ) {
    return AlignmentTween(begin: beginAlign, end: endAlign).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ),
    );
  }
}

typedef TriggerListener = void Function(TriggerDirection trigger);

class CardController {
  TriggerListener _listener;

  void triggerLEFT() {
    if (_listener != null) {
      _listener(TriggerDirection.LEFT);
    }
  }

  void triggerRIGHT() {
    if (_listener != null) {
      _listener(TriggerDirection.RIGHT);
    }
  }

  void triggerUP() {
    if (_listener != null) {
      _listener(TriggerDirection.UP);
    }
  }

  void triggerDOWN() {
    if (_listener != null) {
      _listener(TriggerDirection.DOWN);
    }
  }

  // ignore: use_setters_to_change_properties
  void addListener(final TriggerListener listener) {
    _listener = listener;
  }

  void removeListener() {
    _listener = null;
  }
}
