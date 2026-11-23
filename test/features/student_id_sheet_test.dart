// The Student ID button on Profile opens the digital ID card.
import 'package:flutter_test/flutter_test.dart';
import 'package:vsquare/core/constants/app_strings.dart';
import 'package:vsquare/data/dummy/dummy_profile.dart';
import 'package:vsquare/features/profile/screens/profile_screen.dart';
import 'package:vsquare/features/profile/widgets/student_id_sheet.dart';

import '../helpers/test_app.dart';

void main() {
  setUpAll(loadAppFonts);

  testWidgets('Student ID opens the card with profile details', (tester) async {
    await pumpScreen(tester, const ProfileScreen());
    await tester.tap(find.text(AppStrings.studentId));
    await tester.pumpAndSettle();

    final sheet = find.byType(StudentIdSheet);
    expect(sheet, findsOneWidget);
    expect(
      find.descendant(of: sheet, matching: find.text(dummyProfile.user.name)),
      findsOneWidget,
    );
    expect(
      find.descendant(of: sheet, matching: find.text(dummyProfile.program)),
      findsOneWidget,
    );
  });
}
