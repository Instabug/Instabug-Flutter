part of '../screens.dart';
//ignore_for_file:invalid_use_of_internal_member

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _instabug = true, _apm = true, _screenLoading = true, _uiTrace = true;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _instabug = await Instabug.isEnabled();
    _apm = await APM.isEnabled();
    _screenLoading = await APM.isScreenLoadingEnabled();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomSwitchListTile(
              value: _instabug,
              onChanged: (value) {
                Instabug.setEnabled(value);
                setState(() => _instabug = value);
              },
              title: "Instabug",
            ),
            CustomSwitchListTile(
              value: _apm,
              onChanged: (value) {
                APM.setEnabled(value);
                setState(() => _apm = value);
              },
              title: "APM",
            ),
            CustomSwitchListTile(
              value: _screenLoading,
              onChanged: (value) {
                APM.setScreenLoadingEnabled(value);
                setState(() => _screenLoading = value);
              },
              title: "Screen Loading",
            ),
            CustomSwitchListTile(
              value: _uiTrace,
              onChanged: (value) {
                APM.setAutoUITraceEnabled(value);
                setState(() => _uiTrace = value);
              },
              title: "UI Trace",
            ),
            CustomButton(
              onPressed: () => Modular.to.navigate('/simplePage'),
              title: 'Navigate To Simple Page',
            ),
            CustomButton(
              onPressed: () => Modular.to.pushNamed('/complexPage'),
              title: 'Navigate To Complex Page',
            ),
            CustomButton(
              onPressed: () => Modular.to.pushNamed('/simplePage'),
              title: 'Navigate To Second Page (using push)',
            ),
            CustomButton(
              onPressed: () =>
                  Modular.to.navigate('/simplePage?name=Inastabug'),
              title: 'Navigate To Second Page (with params)',
            ),
            CustomButton(
              onPressed: () => Modular.to.navigate('/redirect'),
              title: 'Navigate Using RedirectRoute',
            ),
            CustomButton(
              onPressed: () => Modular.to.navigate('/bindsPage'),
              title: 'Navigate To Binds Page',
            ),
            const SizedBox(
              height: 32,
            ),
            CustomButton(
              onPressed: () => Modular.to.navigate('/secondModule/'),
              title: 'Navigate To Second Module (Nested Routes)',
            ),
            CustomButton(
              onPressed: () => Modular.to.navigate('/thirdModule/'),
              title: 'Navigate To Third Module (Binds)',
            ),
            CustomButton(
              onPressed: () => Modular.to.navigate('/asde'),
              title: 'Navigation History',
            ),
          ],
        ),
      ),
    );
  }
}
