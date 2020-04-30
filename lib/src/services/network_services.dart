import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:alphadealdemo/src/services/post_response.dart';

class NetworkServices{
  Future<List<PostsResponse>> fetchPost(int startIndex,int limit) async{
    final url = '';

    final http.Response response = await http.get((url));

    if (response.statusCode == 200){
//      final List<PostsResponse> postResponse =
//          List<PostsResponse>.from(postsResponseFromJson(response.body));
//
//      return postResponse;
    }

    throw Exception('Network failed');
  }
}