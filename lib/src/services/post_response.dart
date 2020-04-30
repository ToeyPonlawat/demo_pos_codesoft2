// To parse this JSON data, do
//
// final postsResponse = postsResponseFromJson(jsonString);

import 'dart:convert';

List postsResponseFromJson(String str) => List.from(json.decode(str).map((x) => PostsResponse.fromJson(x)));

String postsResponseToJson(List data) => json.encode(List.from(data.map((x) => x.toJson())));

class PostsResponse {
  int userId;
  int id;
  String title;
  String body;

  PostsResponse({
    this.userId,
    this.id,
    this.title,
    this.body,
  });

  factory PostsResponse.fromJson(Map<String, dynamic> json) => PostsResponse(
    userId: json["userId"],
    id: json["id"],
    title: json["title"],
    body: json["body"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "id": id,
    "title": title,
    "body": body,
  };
}