part of '../screens.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Not Found Page')),
      body: Center(
        child: CustomButton(
          onPressed: () => Modular.to.navigate('/'),
          title: 'Back To Home',
        ),
      ),
    );
  }
}
