import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_infinite_list/src/models/post.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_infinite_list/src/bloc/post_event.dart';
import 'package:flutter_infinite_list/src/bloc/post_state.dart';



class PostBloc extends Bloc<PostEvent, PostState> {

  final http.Client httpClient;

  PostBloc({@required this.httpClient});

  // @override
  // Stream<PostState> transformEvents(
  //   Stream<PostEvent> events,
  //   Stream<PostState> Function(PostEvent event) next,
  // ) {
  //   return super.transformEvents(
  //     events.debounceTime(
  //       Duration(milliseconds: 500),
  //     ),
  //     next,
  //   );
  // }


  @override
  PostState get initialState => PostUninitialized();

  @override
  Stream<PostState> mapEventToState(PostEvent event) async* {
    final currentState = state;
    if(event is Fetch && !_hasReachedMax(currentState)) {
      try {
        if(currentState is PostUninitialized) {
          final posts = await _fetchPosts(0, 20);
          yield PostLoaded(posts: posts, hasReachedMax: false);
          return;
        }
        if(currentState is PostLoaded) {
          final posts =
            await _fetchPosts(currentState.posts.length, 20);
          yield posts.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : PostLoaded(
                posts: currentState.posts + posts,
                hasReachedMax: false,
              );
        }
      }
      catch (_) {
        yield PostError();
      }
    }
  }

  bool _hasReachedMax(PostState state) => state is PostLoaded && state.hasReachedMax;

  Future<List<Post>> _fetchPosts(int startIndex, int limit) async {
    final response = await httpClient.get(
      'https://jsonplaceholder.typicode.com/posts?_start=$startIndex&_limit=$limit');
    if(response.statusCode == 200){
      final data = json.decode(response.body) as List;
      return data.map((rawPost){
        return Post(
          id: rawPost['id'],
          title: rawPost['title'],
          body: rawPost['body'],
        );
      }).toList();
    }else {
      throw Exception('error fetching posts');
    }
  }


}
