part of '../../main.dart';

class ComplexPage extends StatefulWidget {
  static const initialDepth = 10;
  static const initialBreadth = 2;
  static const screenName = 'complex';
  final bool isMonitored;

  const ComplexPage({
    Key? key,
    this.isMonitored = false,
  }) : super(key: key);

  const ComplexPage.monitored({
    Key? key,
    this.isMonitored = true,
  }) : super(key: key);

  @override
  State<ComplexPage> createState() => _ComplexPageState();
}

class _ComplexPageState extends State<ComplexPage> {
  final depthController = TextEditingController();
  final breadthController = TextEditingController();
  int depth = ComplexPage.initialDepth;
  int breadth = ComplexPage.initialBreadth;
  GlobalKey _reloadKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    depthController.text = depth.toString();
    breadthController.text = breadth.toString();
  }

  void _handleRender() {
    setState(() {
      breadth =
          int.tryParse(breadthController.text) ?? ComplexPage.initialBreadth;
      depth = int.tryParse(depthController.text) ?? ComplexPage.initialBreadth;
      _reloadKey = GlobalKey();
    });
  }



  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return _buildPage(textTheme);
  }

  Widget _buildPage(TextTheme textTheme) {
    final content = [
      InstabugTextField(
        label: 'Depth (default: ${ComplexPage.initialDepth})',
        labelStyle: textTheme.labelMedium,
        controller: depthController,
      ),
      InstabugTextField(
        label: 'Breadth (default: ${ComplexPage.initialBreadth})',
        labelStyle: textTheme.labelMedium,
        controller: breadthController,
      ),
      InstabugButton(
        onPressed: _handleRender,
        text: 'Render',
      ),
      SizedBox.fromSize(
        size: const Size.fromHeight(
          12.0,
        ),
      ),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: NestedView(
          depth: depth,
          breadth: breadth,
        ),
      ),
    ];

    if (widget.isMonitored) {
      return KeyedSubtree(
        key: _reloadKey,
        child: Page(
            title: 'Monitored Complex',
            children: content,
        ),
      );
    } else {
      return Page(
        title: 'Complex',
        children: content,
      );
    }
  }
}