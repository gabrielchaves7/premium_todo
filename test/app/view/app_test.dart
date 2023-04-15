import 'package:flutter_test/flutter_test.dart';
import 'package:premium_todo/app/app.dart';
import 'package:premium_todo/todo/todo.dart';

void main() {
  group('App', () {
    testWidgets('renders CounterPage', (tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(TodoPage), findsOneWidget);
    });
  });
}
