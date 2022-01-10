# Tutero QA Assignment

## About

The first part of this assignment is a testing challenge, where you will write unit tests, widget tests and integration test(s) to demonstrate your knowledge of testing with the Flutter driver.

## Criteria

You will be judged off your choice of granularity and exhaustiveness of your tests, as well as the quality and efficiency of the code you write. 

## Notes

Your tests should account for both web and mobile/desktop platforms. Make sure you study the code-base and account for cases where functionality might be platform-dependent.

- Avoid handling dependency injection with `get_it`; your performance will be based off code written in the `test/` directory.


## Example

### 1. Find logic to test

Upon building the app, we see a circular progress indicator. We investigate the source of this widget, to find the following logic:

```dart
Center(
  child: FutureBuilder<List<String>>(
      future: widget.stateRepository.getStates(),
      builder: (context, stateSnap) {
      ...
        if (!stateSnap.hasData) {
          return const CircularProgressIndicator();
        }
      ...
```

This implies that whenever we're loading information from the `getStates()` method from the `StateRepository`, the app should be in a loading state. Therefore, we can write a __widget test__ to account for this edge case:

```dart
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
```

You may build off this example and the `MockStateRepository` generated in `test/`.

Good luck! 🚀
