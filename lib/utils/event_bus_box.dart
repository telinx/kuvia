import 'package:event_bus/event_bus.dart';

// 实例 Event bus
EventBus eventBus = EventBus();


// 当前播放的视频
class CurrentPlayVideoEvent {
  String currentId;
  bool doPause;
  CurrentPlayVideoEvent(this.currentId, {this.doPause = false});
}

// for you当前播放的视频
class ForYouCurrentPlayVideoEvent {
  String currentId;
  bool doPause;
  ForYouCurrentPlayVideoEvent(this.currentId, {this.doPause = false});
}

class ScrollEvent{
  bool toTop;
  String tabName;
  ScrollEvent({this.toTop = true, this.tabName});

  @override
  String toString() {
    return {toTop: this.toTop, tabName: this.tabName}.toString();
  }
}

class HandlerCallback {
  bool status;
  HandlerCallback(this.status);
}