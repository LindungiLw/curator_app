abstract class CuratorEvent {}

class LoadCuratorItems extends CuratorEvent {}

class AddCuratorItem extends CuratorEvent {
  final String title;
  final String category;
  final String imagePath;
  // AI Narrative akan di-generate terpisah melalui Gemini API

  AddCuratorItem({
    required this.title,
    required this.category,
    required this.imagePath,
  });
}

class DeleteCuratorItem extends CuratorEvent {
  final String id;
  DeleteCuratorItem({required this.id});
}