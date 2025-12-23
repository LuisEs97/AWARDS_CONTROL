class Nominee {
  final String name;
  final String imagePath;
  final String? videoPath;
  final String? audioPath;

  Nominee({
    required this.name,
    required this.imagePath,
    this.videoPath,
    this.audioPath,
  });
}
