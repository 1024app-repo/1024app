import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:communityfor1024/api/api.dart';

import 'bloc.dart';

class TopicListBloc extends Bloc<TopicListEvent, TopicListState> {
  int page = 0;

  @override
  TopicListState get initialState => TopicListUninitialized();

  @override
  Stream<TopicListState> mapEventToState(
    TopicListEvent event,
  ) async* {
    final currentState = state;
    try {
      if (event is LoadMoreEvent) {
        if (currentState is TopicListLoaded) {
          page = page + 1;
          final res = await API.getTopicList(event.nodeId, page);
          final hasReachedMax = page > res.total;
          yield hasReachedMax
              ? currentState.copyWith()
              : TopicListLoaded(topics: currentState.topics + res.rows);
          event.controller.finishLoad(success: true, noMore: hasReachedMax);
        }
      } else if (event is RefreshEvent) {
        page = 1;
        final res = await API.getTopicList(event.nodeId, 1);
        yield TopicListLoaded(topics: res.rows);
        event.controller.finishRefresh(success: true);
      }
    } catch (e) {
      print(e.toString());
      yield TopicListError();
    }
  }
}
