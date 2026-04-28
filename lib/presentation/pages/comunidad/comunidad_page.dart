import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/community_provider.dart';
import '../../widgets/app_bar_custom.dart';
import '../../widgets/card_item.dart';

class ComunidadPage extends StatelessWidget {
  const ComunidadPage({super.key});

  @override
  Widget build(BuildContext context) {
    final community = context.watch<CommunityProvider>();
    final posts = community.posts;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const AppBarCustom(title: 'Comunidad'),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openCreatePostSheet(context),
        icon: const Icon(Icons.add_a_photo_outlined),
        label: const Text('Publicar'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colors.primaryContainer,
                  colors.tertiaryContainer.withValues(alpha: 0.88),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Postales de la Sierra',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: colors.onPrimaryContainer,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Comparte fotos, recomendaciones, reseñas y experiencias de ruta. Esta beta funciona ya dentro de la app con publicaciones, likes y comentarios.',
                  style: TextStyle(
                    color: colors.onPrimaryContainer.withValues(alpha: 0.92),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...posts.map((post) => _CommunityPostCard(post: post)),
          const SizedBox(height: 90),
        ],
      ),
    );
  }
}

class _CommunityPostCard extends StatelessWidget {
  const _CommunityPostCard({required this.post});

  final CommunityPost post;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final provider = context.read<CommunityProvider>();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 220,
            width: double.infinity,
            child: DestinationImage(
              imageUrl: post.imageUrl,
              title: post.title,
              subtitle: post.destination,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: colors.primaryContainer,
                      child: Text(
                        post.author.isNotEmpty ? post.author[0].toUpperCase() : 'C',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.author,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${post.destination} • ${post.createdAtLabel}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: colors.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                    _SmallBadge(label: post.category, color: colors.secondary),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  post.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 8),
                Text(post.body),
                if (post.recommendation.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colors.secondaryContainer.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.lightbulb_outline, color: colors.secondary),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Tip: ${post.recommendation}',
                            style: TextStyle(
                              color: colors.onSecondaryContainer,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _MetaPill(
                      icon: Icons.star_rounded,
                      text: '${post.rating.toStringAsFixed(1)} / 5',
                      color: const Color(0xFFE4A11B),
                    ),
                    _MetaPill(
                      icon: Icons.favorite_outline,
                      text: '${post.likes} likes',
                      color: colors.primary,
                    ),
                    _MetaPill(
                      icon: Icons.comment_outlined,
                      text: '${post.comments.length} comentarios',
                      color: colors.tertiary,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.tonalIcon(
                        onPressed: () => provider.toggleLike(post.id),
                        icon: Icon(
                          post.likedByMe ? Icons.favorite : Icons.favorite_border,
                        ),
                        label: Text(post.likedByMe ? 'Te gusta' : 'Me gusta'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _openPostDetail(context, post.id),
                        icon: const Icon(Icons.forum_outlined),
                        label: const Text('Ver post'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void _openPostDetail(BuildContext context, String postId) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => _PostDetailSheet(postId: postId),
  );
}

class _PostDetailSheet extends StatefulWidget {
  const _PostDetailSheet({required this.postId});

  final String postId;

  @override
  State<_PostDetailSheet> createState() => _PostDetailSheetState();
}

class _PostDetailSheetState extends State<_PostDetailSheet> {
  final _authorController = TextEditingController();
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _authorController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CommunityProvider>();
    final post = provider.posts.firstWhere((item) => item.id == widget.postId);
    final colors = Theme.of(context).colorScheme;

    return SafeArea(
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.88,
        minChildSize: 0.55,
        maxChildSize: 0.95,
        builder: (context, controller) {
          return ListView(
            controller: controller,
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              SizedBox(
                height: 220,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: DestinationImage(
                    imageUrl: post.imageUrl,
                    title: post.title,
                    subtitle: post.destination,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                post.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 8),
              Text('${post.author} • ${post.destination} • ${post.createdAtLabel}'),
              const SizedBox(height: 14),
              Text(post.body),
              if (post.recommendation.isNotEmpty) ...[
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: colors.secondaryContainer.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Recomendación: ${post.recommendation}',
                    style: TextStyle(
                      color: colors.onSecondaryContainer,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 18),
              Row(
                children: [
                  _MetaPill(
                    icon: Icons.star_rounded,
                    text: '${post.rating.toStringAsFixed(1)} / 5',
                    color: const Color(0xFFE4A11B),
                  ),
                  const SizedBox(width: 8),
                  _MetaPill(
                    icon: Icons.favorite_outline,
                    text: '${post.likes} likes',
                    color: colors.primary,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Comentarios',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 10),
              ...post.comments.map(
                (comment) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerHighest.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.author,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 4),
                      Text(comment.text),
                      const SizedBox(height: 6),
                      Text(
                        comment.createdAtLabel,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _authorController,
                decoration: const InputDecoration(
                  labelText: 'Tu nombre',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _commentController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Escribe tu comentario',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () {
                  final author = _authorController.text.trim();
                  final text = _commentController.text.trim();
                  if (author.isEmpty || text.isEmpty) return;
                  context.read<CommunityProvider>().addComment(
                        post.id,
                        author: author,
                        text: text,
                      );
                  _commentController.clear();
                },
                icon: const Icon(Icons.send_outlined),
                label: const Text('Publicar comentario'),
              ),
            ],
          );
        },
      ),
    );
  }
}

void _openCreatePostSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => const _CreatePostSheet(),
  );
}

class _CreatePostSheet extends StatefulWidget {
  const _CreatePostSheet();

  @override
  State<_CreatePostSheet> createState() => _CreatePostSheetState();
}

class _CreatePostSheetState extends State<_CreatePostSheet> {
  final _authorController = TextEditingController();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _recommendationController = TextEditingController();

  String _destination = 'Mirador Cuatro Palos';
  String _category = 'Foto';
  double _rating = 4.5;

  static const _destinations = [
    'Mirador Cuatro Palos',
    'Jalpan de Serra',
    'Mision de Jalpan',
    'Rio Escanela y Puente de Dios',
    'Cascada El Chuveje',
    'Sotano del Barro',
    'Mision de Landa',
  ];

  static const _categories = [
    'Foto',
    'Reseña',
    'Comida',
    'Ruta',
    'Consejo',
    'Recuerditos',
  ];

  @override
  void dispose() {
    _authorController.dispose();
    _titleController.dispose();
    _bodyController.dispose();
    _imageUrlController.dispose();
    _recommendationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.9,
        minChildSize: 0.6,
        maxChildSize: 0.96,
        builder: (context, controller) {
          return ListView(
            controller: controller,
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              Text(
                'Nueva publicación',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Beta funcional: puedes publicar ya mismo con foto opcional, recomendación y destino.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 18),
              TextField(
                controller: _authorController,
                decoration: const InputDecoration(
                  labelText: 'Tu nombre',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Título de tu post',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                initialValue: _destination,
                decoration: const InputDecoration(
                  labelText: 'Destino relacionado',
                  border: OutlineInputBorder(),
                ),
                items: _destinations
                    .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                    .toList(),
                onChanged: (value) => setState(() => _destination = value!),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: const InputDecoration(
                  labelText: 'Tipo de publicación',
                  border: OutlineInputBorder(),
                ),
                items: _categories
                    .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                    .toList(),
                onChanged: (value) => setState(() => _category = value!),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _bodyController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Cuenta tu experiencia',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _recommendationController,
                decoration: const InputDecoration(
                  labelText: 'Recomendación breve',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'URL de foto opcional',
                  hintText: 'Si no pones foto, usamos una postal genérica',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Calificación: ${_rating.toStringAsFixed(1)} / 5',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              Slider(
                value: _rating,
                min: 1,
                max: 5,
                divisions: 8,
                label: _rating.toStringAsFixed(1),
                onChanged: (value) => setState(() => _rating = value),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () {
                  final author = _authorController.text.trim();
                  final title = _titleController.text.trim();
                  final body = _bodyController.text.trim();
                  if (author.isEmpty || title.isEmpty || body.isEmpty) return;
                  context.read<CommunityProvider>().addPost(
                        author: author,
                        title: title,
                        body: body,
                        destination: _destination,
                        category: _category,
                        rating: _rating,
                        imageUrl: _imageUrlController.text.trim(),
                        recommendation: _recommendationController.text.trim(),
                      );
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.publish_outlined),
                label: const Text('Publicar en comunidad'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({
    required this.icon,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(color: color, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _SmallBadge extends StatelessWidget {
  const _SmallBadge({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
