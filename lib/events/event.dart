
import 'package:pull_to_refresh/pull_to_refresh.dart';

class StatusEvent {
  String labelId;
  RefreshStatus refreshStatus;
  LoadStatus loadStatus;
  String cid;
  StatusEvent(this.labelId, this.refreshStatus, this.loadStatus, {this.cid});
}


class PageEvent {

  static String noMore = "1";

  String pagingState;
  bool hasNext;
  PageEvent({this.pagingState, this.hasNext = true});

  @override
  String toString() {
    return "{pagingState: ${this.pagingState}, hasNext: ${this.hasNext}}";
  }
}
