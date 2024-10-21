part of '../screens.dart';

class ComplexPage extends StatelessWidget {
  const ComplexPage({super.key});

  @override
  Widget build(BuildContext context) {
    int numberOfWidgets = 100;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Complex Page"),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomCard(
                    width: 40,
                    height: 40,
                  ),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomCard(
                        height: 10,
                        width: 150,
                      ),
                      SizedBox(height: 8),
                      CustomCard(
                        height: 10,
                        width: 200,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 80,
              child: ListView.separated(
                itemBuilder: (_, __) => const CustomCard(
                  width: 80,
                ),
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemCount: numberOfWidgets,
                scrollDirection: Axis.horizontal,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemBuilder: (_, __) => const CustomCard(
                  height: 100,
                ),
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemCount: numberOfWidgets,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  const CustomCard({super.key, this.width, this.height});

  final double? width, height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black12,
      ),
    );
  }
}
