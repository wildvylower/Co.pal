
class Story{
  final int id;
  final String title;
  final String difficulty;
  final String mapImage;
  final bool isLocked;

  
const Story({
  required this.id,
  required this.title,
  required this.difficulty,
  required this.mapImage,
  required this.isLocked,

});
}

final List<Story> stories = [
  const Story(
    id: 1,
    title: 'Pesta Ulang Tahun Beri',
    difficulty: 'Pemula',
    mapImage: 'assets/images/map.png',
    isLocked: false,
  ),
];
