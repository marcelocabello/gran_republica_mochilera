import 'package:flutter/foundation.dart';

class CommunityProvider extends ChangeNotifier {
  CommunityProvider() : _posts = List<CommunityPost>.from(_seedPosts);

  final List<CommunityPost> _posts;

  List<CommunityPost> get posts => List<CommunityPost>.unmodifiable(_posts);

  void addPost({
    required String author,
    required String title,
    required String body,
    required String destination,
    required String category,
    required double rating,
    String imageUrl = '',
    String recommendation = '',
  }) {
    _posts.insert(
      0,
      CommunityPost(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        author: author.trim(),
        title: title.trim(),
        body: body.trim(),
        destination: destination.trim(),
        category: category.trim(),
        rating: rating,
        imageUrl: imageUrl.trim(),
        recommendation: recommendation.trim(),
        likes: 0,
        likedByMe: false,
        comments: const <CommunityComment>[],
        createdAtLabel: 'Ahora',
      ),
    );
    notifyListeners();
  }

  void toggleLike(String postId) {
    final index = _posts.indexWhere((post) => post.id == postId);
    if (index == -1) return;
    final post = _posts[index];
    final liked = !post.likedByMe;
    _posts[index] = post.copyWith(
      likedByMe: liked,
      likes: liked ? post.likes + 1 : (post.likes - 1).clamp(0, 999999),
    );
    notifyListeners();
  }

  void addComment(String postId, {required String author, required String text}) {
    final index = _posts.indexWhere((post) => post.id == postId);
    if (index == -1) return;
    final post = _posts[index];
    final comments = List<CommunityComment>.from(post.comments)
      ..add(
        CommunityComment(
          author: author.trim(),
          text: text.trim(),
          createdAtLabel: 'Hace un momento',
        ),
      );
    _posts[index] = post.copyWith(comments: comments);
    notifyListeners();
  }
}

@immutable
class CommunityPost {
  const CommunityPost({
    required this.id,
    required this.author,
    required this.title,
    required this.body,
    required this.destination,
    required this.category,
    required this.rating,
    required this.imageUrl,
    required this.recommendation,
    required this.likes,
    required this.likedByMe,
    required this.comments,
    required this.createdAtLabel,
  });

  final String id;
  final String author;
  final String title;
  final String body;
  final String destination;
  final String category;
  final double rating;
  final String imageUrl;
  final String recommendation;
  final int likes;
  final bool likedByMe;
  final List<CommunityComment> comments;
  final String createdAtLabel;

  CommunityPost copyWith({
    String? id,
    String? author,
    String? title,
    String? body,
    String? destination,
    String? category,
    double? rating,
    String? imageUrl,
    String? recommendation,
    int? likes,
    bool? likedByMe,
    List<CommunityComment>? comments,
    String? createdAtLabel,
  }) {
    return CommunityPost(
      id: id ?? this.id,
      author: author ?? this.author,
      title: title ?? this.title,
      body: body ?? this.body,
      destination: destination ?? this.destination,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      imageUrl: imageUrl ?? this.imageUrl,
      recommendation: recommendation ?? this.recommendation,
      likes: likes ?? this.likes,
      likedByMe: likedByMe ?? this.likedByMe,
      comments: comments ?? this.comments,
      createdAtLabel: createdAtLabel ?? this.createdAtLabel,
    );
  }
}

@immutable
class CommunityComment {
  const CommunityComment({
    required this.author,
    required this.text,
    required this.createdAtLabel,
  });

  final String author;
  final String text;
  final String createdAtLabel;
}

const List<CommunityPost> _seedPosts = [
  CommunityPost(
    id: 'post-1',
    author: 'Mariana Viajera',
    title: 'Amanecer en Cuatro Palos',
    body:
        'Llegamos tempranísimo y valió totalmente la pena. La neblina se abrió poco a poco y el mirador quedó impresionante. Si van, llévense chamarra y café porque arriba pega fuerte el aire.',
    destination: 'Mirador Cuatro Palos',
    category: 'Mirador',
    rating: 4.9,
    imageUrl: '',
    recommendation: 'Llegar antes de las 7:00 am para ver mejor la vista.',
    likes: 24,
    likedByMe: false,
    comments: [
      CommunityComment(
        author: 'Rafa',
        text: 'Confirmo lo de la chamarra, yo fui confiado y sí hacía bastante frío.',
        createdAtLabel: 'Hace 2 h',
      ),
      CommunityComment(
        author: 'Lu',
        text: 'Qué buena recomendación, justo quiero ir este fin.',
        createdAtLabel: 'Hace 1 h',
      ),
    ],
    createdAtLabel: 'Hace 3 h',
  ),
  CommunityPost(
    id: 'post-2',
    author: 'Sofía Ruta',
    title: 'Dónde comer rico en Jalpan',
    body:
        'Después de caminar por el centro encontramos unas gorditas serranas y café de olla buenísimos. Si traen cupones de la libreta, sí se siente el beneficio en la parada.',
    destination: 'Jalpan de Serra',
    category: 'Comida',
    rating: 4.7,
    imageUrl: '',
    recommendation: 'Pidan gorditas y agua fresca si vienen del calor.',
    likes: 18,
    likedByMe: false,
    comments: [
      CommunityComment(
        author: 'Karen',
        text: 'Las gorditas con café fue justo mi combo favorito también.',
        createdAtLabel: 'Hace 5 h',
      ),
    ],
    createdAtLabel: 'Hace 6 h',
  ),
  CommunityPost(
    id: 'post-3',
    author: 'Equipo Sierra',
    title: 'Recuerditos que sí valen la pena',
    body:
        'En la parte de tienda encontramos postales y artesanías con más personalidad que los souvenirs típicos. Buen punto para comprar algo antes de volver.',
    destination: 'Landa y Jalpan',
    category: 'Recuerditos',
    rating: 4.8,
    imageUrl: '',
    recommendation: 'Vale la pena apartar un poco de presupuesto para artesanías locales.',
    likes: 11,
    likedByMe: false,
    comments: [
      CommunityComment(
        author: 'Mónica',
        text: 'Yo también encontré postales muy bonitas ahí.',
        createdAtLabel: 'Hace 1 día',
      ),
    ],
    createdAtLabel: 'Hace 1 día',
  ),
];
