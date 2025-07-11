part of '../../main.dart';

class SessionReplayPage extends StatefulWidget {
  static const screenName = 'SessionReplay';

  const SessionReplayPage({Key? key}) : super(key: key);

  @override
  State<SessionReplayPage> createState() => _SessionReplayPageState();
}

class _SessionReplayPageState extends State<SessionReplayPage> {
  @override
  Widget build(BuildContext context) {
    return Page(title: 'Session Replay', children: [
      const SectionTitle('Enabling Session Replay'),
      InstabugButton(
        key: const Key('instabug_sesssion_replay_disable'),
        onPressed: () => SessionReplay.setEnabled(false),
        text: "Disable Session Replay",
      ),
      InstabugButton(
        key: const Key('instabug_sesssion_replay_enable'),
        onPressed: () => SessionReplay.setEnabled(true),
        text: "Enable Session Replay",
      ),
      const SectionTitle('Enabling Session Replay Network'),
      InstabugButton(
        key: const Key('instabug_sesssion_replay_network_disable'),
        onPressed: () => SessionReplay.setNetworkLogsEnabled(false),
        text: "Disable Session Replay Network",
      ),
      InstabugButton(
        key: const Key('instabug_sesssion_replay_network_enable'),
        onPressed: () => SessionReplay.setNetworkLogsEnabled(true),
        text: "Enable Session Replay Network",
      ),
      const SectionTitle('Enabling Session Replay User Steps'),
      InstabugButton(
        key: const Key('instabug_sesssion_replay_user_steps_disable'),
        onPressed: () => SessionReplay.setUserStepsEnabled(false),
        text: "Disable Session Replay User Steps",
      ),
      InstabugButton(
        key: const Key('instabug_sesssion_replay_user_steps_enable'),
        onPressed: () => SessionReplay.setUserStepsEnabled(true),
        text: "Enable Session Replay User Steps",
      ),
      const SectionTitle('Enabling Session Replay Logs'),
      InstabugButton(
        key: const Key('instabug_sesssion_replay_logs_disable'),
        onPressed: () => SessionReplay.setInstabugLogsEnabled(false),
        text: "Disable Session Replay Logs",
      ),
      InstabugButton(
        key: const Key('instabug_sesssion_replay_logs_enable'),
        onPressed: () => SessionReplay.setInstabugLogsEnabled(true),
        text: "Enable Session Replay Logs",
      ),
      const SectionTitle('Enabling Session Replay Repro steps'),
      InstabugButton(
        key: const Key('instabug_sesssion_replay_repro_steps_disable'),
        onPressed: () =>
            Instabug.setReproStepsConfig(
                sessionReplay: ReproStepsMode.disabled),
        text: "Disable Session Replay Repro steps",
      ),
      InstabugButton(
        key: const Key('instabug_sesssion_replay_repro_steps_enable'),
        onPressed: () =>
            Instabug.setReproStepsConfig(sessionReplay: ReproStepsMode.enabled),
        text: "Enable Session Replay Repro steps",
      ),
      InstabugButton(
        key: const Key('instabug_sesssion_replay_tab_screen'),
        onPressed: () =>
            Navigator.of(context).pushNamed(TopTabBarScreen.route),
        text: 'Open Tab Screen',
      ),
    ]);
  }
}

class TopTabBarScreen extends StatelessWidget {
  static const String route = "/tap";

  const TopTabBarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Top TabBar with 4 Tabs'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Home', icon: Icon(Icons.home)),
              Tab(text: 'Search', icon: Icon(Icons.search)),
              Tab(text: 'Alerts', icon: Icon(Icons.notifications)),
              Tab(text: 'Profile', icon: Icon(Icons.person)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('Home Screen')),
            Center(child: Text('Search Screen')),
            Center(child: Text('Alerts Screen')),
            Center(child: Text('Profile Screen')),
          ],
        ),
      ),
    );
  }
}
