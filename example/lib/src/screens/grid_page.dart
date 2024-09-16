part of '../../main.dart';

class GridPage extends StatefulWidget {
  static const screenName = 'grid';

  const GridPage({Key? key}) : super(key: key);

  @override
  State<GridPage> createState() => _GridPageState();
}

class _GridPageState extends State<GridPage> {
  static const _width = 100;
  static const _height = 150;
  static const _itemCount = _height * _width;

  Color _color(int index) {
    final x = index % _width;
    final y = index ~/ _width;
    final r = x / _width;
    final g = y / _height;
    final b = 1 - (r + g) / 2;
    return Color.fromRGBO(
      (r * 255).round(),
      (g * 255).round(),
      (b * 255).round(),
      1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grid Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Instabug.reportScreenChange('grid_refresh');
            },
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: _width,
        children: List.generate(
          _itemCount,
          (index) => InstabugPrivateView(
            child: Container(
              color: _color(index),
            ),
          ),
        ),
      ),
    );
  }
}
