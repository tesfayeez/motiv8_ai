// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class QuotesModel {
  final String quote;

  final String author;
  QuotesModel({
    required this.quote,
    required this.author,
  });

  QuotesModel copyWith({
    String? quote,
    String? category,
    String? author,
  }) {
    return QuotesModel(
      quote: quote ?? this.quote,
      author: author ?? this.author,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'quote': quote,
      'author': author,
    };
  }

  factory QuotesModel.fromMap(Map<String, dynamic> map) {
    return QuotesModel(
      quote: map['quote'] as String,
      author: map['author'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory QuotesModel.fromJson(String source) =>
      QuotesModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'QuotesModel(quote: $quote,  author: $author)';

  @override
  bool operator ==(covariant QuotesModel other) {
    if (identical(this, other)) return true;

    return other.quote == quote && other.author == author;
  }

  @override
  int get hashCode => quote.hashCode ^ author.hashCode;
}
