import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:communityfor1024/api/api.dart';

import './bloc.dart';

class TopicDetailBloc extends Bloc<TopicDetailEvent, TopicDetailState> {
  int page = 0;

  @override
  TopicDetailState get initialState => TopicDetailUninitialized();

  @override
  Stream<TopicDetailState> mapEventToState(
    TopicDetailEvent event,
  ) async* {
    final currentState = state;
    try {
      if (event is LoadMoreEvent) {
        if (currentState is TopicDetailLoaded) {
          page = page + 1;
          final res = await API.getTopicDetail(event.topicId, page);
          final hasReachedMax = page > res.total;
          yield hasReachedMax
              ? currentState.copyWith(
                  current: res.page,
                  total: res.total,
                )
              : currentState.copyWith(
                  replies: currentState.replies + res.rows,
                  current: res.page,
                  total: res.total,
                );
          event.controller.finishLoad(success: true, noMore: hasReachedMax);
        }
      } else if (event is RefreshEvent) {
        page = 1;
        final res = await API.getTopicDetail(event.topicId, 1);
        yield TopicDetailLoaded(
          subject: res.rows.first,
          replies: res.rows,
          current: res.page,
          total: res.total,
        );
        event.controller.finishRefresh(success: true);
      }
    } catch (e) {
      print(e.toString());
      yield TopicDetailError();
    }
  }
}
