part of '../screens.dart';

class SimplePage extends StatelessWidget {
  const SimplePage({super.key});

  @override
  Widget build(BuildContext context) {
    final canPop = Modular.to.canPop();
    const int extendedMicroseconds = 50000;

    return Scaffold(
      appBar: AppBar(title: const Text('Second Page')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (Modular.args.queryParams.containsKey("name")) ...[
              Text(
                "Parameters: ${Modular.args.queryParams["name"]}",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
            ],
            CustomButton(
              onPressed: () =>
                  _extendScreenLoading(context, extendedMicroseconds),
              title: 'Extend SCL for $extendedMicroseconds μs',
            ),
            CustomButton(
              onPressed: () {
                if (canPop) {
                  Modular.to.pop();
                } else {
                  Modular.to.navigate('/');
                }
              },
              title: 'Back to Home ${canPop ? "(pop)" : ""}',
            ),
          ],
        ),
      ),
    );
  }

  void _extendScreenLoading(BuildContext context, int microseconds) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            content: Text("extend Screen for $microseconds microseconds"),
            duration: Duration(microseconds: microseconds),
          ),
        )
        .closed
        .then((value) => APM.endScreenLoading());
  }
}
