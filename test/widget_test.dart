import 'package:flutter_test/flutter_test.dart';
import 'package:turismo_local_here/main.dart';

void main() {
  testWidgets('TurismoLocalApp renders main map screen without errors', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TurismoLocalApp());
    await tester.pumpAndSettle();

    // Verify search bar placeholder text exists
    expect(find.textContaining('Buscar monumentos'), findsOneWidget);
  });
}
