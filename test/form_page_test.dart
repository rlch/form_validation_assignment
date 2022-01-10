import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_validation_assignment/main.dart';
import 'package:form_validation_assignment/state_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'form_page_test.mocks.dart';

@GenerateMocks([StateRepository])
void main() {
  testWidgets('FormPage in loading state only when getState() unresolved', (tester) async {
    final stateRepository = MockStateRepository();

    when(stateRepository.getStates()).thenAnswer(
      (_) => Future.delayed(
        const Duration(seconds: 5),
        () => ['test state'],
      ),
    );

    await tester.pumpWidget(
      FormPage(
        title: '',
        minInterests: 0,
        stateRepository: stateRepository,
      ),
    );

    await tester.pump(const Duration(seconds: 3));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
