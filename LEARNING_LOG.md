# Learning Log

## Lesson 01: First unit test
- Learned: Arrange/Act/Assert, test(), expect(), reading a failure message
- Struggled with: the Git staging step (add before commit)
- Key insight: when a test fails, decide if the code or the test is wrong

## Lesson 02: Matchers and group
- Learned: equals, isEmpty, hasLength; group; test names must describe behavior
- Struggled with: a test name that did not match what the code checked
- Key insight: a misleading test name sends people looking in the wrong place

## Lesson 03: Testing that code throws
- Learned: throwsArgumentError, red then green, wrapping the call in () =>
- Struggled with: my first test called division directly, so expect never got a function
- Key insight: a test should fail first, so I know it can catch the bug

## Lesson 04: setUp and stateful classes
- Learned: setUp gives each test a fresh object; shared state makes tests order-dependent
- Struggled with: my reset test passed even when reset() did nothing
- Key insight: break the code on purpose to check that a test can fail



## Lesson 05: Async tests
- Learned: A Future is a value that arrives later. An async test needs an `async` body and `await` so the test waits for the value before checking it. To test a Future that fails, I pass the Future to `await expectLater(future, throwsException)`.
- Struggled with: A typo in my expected string (`'Noshd'`). The failure message pointed to it with "Differ at offset 4", and I fixed the test, not the code. When I removed `await`, the failure said `Actual: <Instance of 'Future<String>'>`, because I was comparing a Future to a String.
- Key insight: A sync function throws at the call, so I wrap it in `() =>` and let `expect` call it safely. An async function never throws at the call. The error is stored inside the Future, so I pass the Future directly.

### Interview Q&A
**Q: Why do async tests need `await`?**
A: Without it, the test can finish before the Future completes, so the check either runs on a Future instead of the real value or never runs at all, and the test gives false confidence.

**Q: Why do I use `() =>` to test a sync exception but not an async one?**
A: A sync function throws the moment it is called, before `expect` starts, so I give `expect` a closure to call inside its own try/catch. An async function returns a Future that completes with the error later, so I pass that Future to `expectLater` and await it.



## Lesson 06: Fakes and mocks
- Learned: Dependency injection means a class receives what it needs (`UserService(UserApi api)`) instead of creating it. In tests I swap the real API for a fake so nothing touches the network. With `mocktail` I create a mock in one line, set its answers inside each test with `when(...).thenAnswer(...)`, and check calls with `verify(...).called(1)`.
- Struggled with: My first failure test called `failedApi.getUserName()` directly, so it tested my own fake, not `UserService`. It would have kept passing even if `UserService` swallowed the error. I also used `expectLater` on a plain String, which only needs `expect`.
- Key insight: A test is only worth keeping if it can fail when the code under test breaks.

### Interview Q&A
**Q: Why do we fake or mock dependencies in unit tests?**
A: A real server makes tests slow, flaky when the internet is down, and unpredictable when data changes, and I can't force it to fail on demand. A fake or mock keeps tests fast, isolated and deterministic, and lets me simulate failures.

**Q: What is the difference between a fake and a mock?**
A: A fake is a replacement class I write by hand. A mock is created by a library like mocktail, so I set its behavior per test and can verify that it was called.

**Q: When should I use `verify`?**
A: When the call itself is the behavior, like saving to a database or sending an analytics event. For ordinary results I use `expect`, because verifying every call ties tests to how the code works inside and makes refactoring harder.



## Lesson 07: Testing a repository (API plus cache)
- Learned: A repository sits between the app and its data (a remote source and a local cache). To unit test it, I mock both helpers with mocktail and control what each returns. I tested three behaviors: (1) the happy path returns the remote name and saves it to the cache, (2) when the remote fails it returns the cached name, (3) when the remote fails and the cache is empty it rethrows the error.
- Struggled with: I changed `read()` from `Future<String?>` to `Future<String>`, which removed the "nothing cached" case. Then I returned `''` for an empty cache. That hid the error, because the UI could not tell "server down and nothing saved" from a genuinely empty name. My `try` block also wrapped `_cache.save(name)`, so a failed save would have looked like a server failure.
- Key insight: Never swallow an error by returning a fake default value. Let the error travel up with `rethrow;` so the state layer can show an error state. Keep the `try` block as narrow as possible, so it only catches the thing you expect to fail.

### Interview Q&A
**Q: How do you unit test a repository?**
A: I inject mocks for its dependencies (remote source and cache) and test only the repository's own logic: what it returns, which dependencies it calls, and what it does when they fail. No real network or database is involved.

**Q: Why use `verify` for the cache save but `expect` for the returned name?**
A: The returned name is a value, so `expect` checks it. Saving to the cache is a side effect with no return value, so only `verify(...).called(1)` can prove it happened. When I deleted the save line, `expect` still passed and only `verify` failed.

**Q: Why should `read()` return `String?` and not `String`?**
A: `null` means "nothing cached". A non-nullable return type forces me to invent a fake value for the empty case, which hides real failures. With `String?`, the repository decides explicitly what to do with `null`.

**Q: Why rethrow instead of returning an empty string?**
A: A fake value gives the UI no way to show an error or a retry button. Rethrowing passes the real error up so the state layer can handle it.

**Q: What is the difference between `rethrow;` and `throw e;`?**
A: `rethrow;` passes the original error on with its original stack trace. `throw e;` throws a new error from the current line and loses the original stack trace, which makes debugging harder.

**Q: Why catch `on Exception` and not everything?**
A: `Exception` covers expected failures such as network errors. Catching everything would also swallow programming errors (`Error` types), which should crash loudly so I notice them.

**Q: Why keep the `try` block narrow?**
A: If it also wraps `_cache.save(name)`, a cache failure is treated like a server failure, and the user may get old data even though the server just returned fresh data.

**Q: Should a failed cache save break the screen?**
A: It is a design decision. Many teams catch it, log it, and still return the fresh data, because a broken cache should not break the screen. The right choice depends on how important the cache is to the app.

### Tests written
- returns the remote name and saves it to the cache
- returns the cached name when the remote source fails
- rethrows when the remote fails and the cache is empty

**Progress score: 36/100**



## Lesson 08: Testing a Cubit with bloc_test
- Learned: A Cubit holds state and changes it with `emit()`. `blocTest` replaces manual setup: `build` creates a fresh Cubit, `act` calls its methods, `expect` lists the states it should emit in order, `setUp` prepares mocks for that test, and `verify` checks calls afterwards. The initial state is NOT in the `expect` list, only states emitted after the Cubit is built. A real Cubit emits a sequence (loading, then loaded or error), and I test it by mocking the repository with mocktail. `Equatable` gives states value equality, so `blocTest` can compare them.
- Struggled with: I changed the Cubit's error message to `'offline'` so my test would pass. But the Cubit catches every Exception, not only network failures, so "offline" would be wrong for other errors. I restored `'Could not load profile'` and fixed the test instead. I also put a test outside its group again, and forgot `const` on a state.
- Key insight: When a test fails, decide which side is wrong before changing anything. A user-facing message should be true for every case that can produce it, and the test should follow the correct behavior, not the other way round. Also, a state class without a correct `props` makes comparisons meaningless, so a test can pass without checking anything.

### Interview Q&A
**Q: What is the difference between Cubit and Bloc?**
A: A Cubit changes state by calling methods that `emit` new states. A Bloc receives events and maps them to states. Cubit is simpler and has less code, and Bloc is more structured when I want to track every event.

**Q: How do you test a Cubit?**
A: With `blocTest`. I mock its dependencies (usually a repository), call the method in `act`, and list the exact states it should emit, in order, in `expect`.

**Q: Why isn't the initial state in the `expect` list?**
A: `blocTest` only lists states emitted after the Cubit is created. I test the initial state separately with a plain test: `expect(cubit.state, const ProfileInitial())`.

**Q: Why do Bloc states usually extend Equatable?**
A: `blocTest` and Bloc itself compare states with `==`. Without value equality, two objects with identical data are different instances, so tests fail even when the output is right, and Bloc may rebuild the UI when nothing really changed.

**Q: What does `blocTest`'s `setUp` do, and how is it different from the group's `setUp`?**
A: It prepares things for that single test only, such as `when(...)` stubs on mocks. The group's `setUp` runs before every test in the group.

**Q: Why mock the repository when testing a Cubit?**
A: I'm testing the Cubit's logic (which states it emits), not the network or database. A mock keeps the test fast and deterministic, and lets me simulate success and failure on demand.

**Q: What would you check if a state class's equality seems broken?**
A: I'd check its `props` list. If `props` is missing or leaves out a field, two different states look equal and a test can pass without ever checking that field.

### Tests written
- CounterCubit: initial state is 0, increment emits [1], decrement emits [-1], two increments emit [1, 2]
- ProfileCubit: initial state is ProfileInitial
- ProfileCubit: emits [loading, loaded] when load succeeds
- ProfileCubit: emits [loading, error] when load fails

**Progress score: 42/100**

## Lesson 09: Widget tests (find, tap, expect)
- Learned: A widget test builds a widget in a fake screen and checks what the user sees and does. The steps are: `pumpWidget` (build), `tester.tap` (act), `tester.pump` (redraw one frame), then `expect(find..., findsOneWidget)`. I wrap the widget in `MaterialApp` because `Scaffold` needs the Material environment above it.
- Struggled with: I predicted that removing `pump()` meant no widget was open. In fact the widget is built and the tap happens, but `setState` only marks the widget for a redraw and a test only draws a frame when I call `pump()`. The failure said `Found 0 widgets with text "Count: 1"`. I also gave two buttons the same tooltip and misspelled the group name.
- Key insight: In a widget test, a correct app can still fail because the check ran before the screen updated. After every action that changes the UI, call `pump()` before checking.

### Interview Q&A
**Q: What is the difference between a unit test and a widget test?**
A: A unit test checks logic in plain Dart code. A widget test builds a widget in a simulated screen, then finds widgets, taps them, and checks what changed on the screen, all without a device or emulator.

**Q: What does `tester.pump()` do, and why do you need it?**
A: It makes Flutter draw one new frame. `setState` only marks a widget as needing a rebuild, so after a tap I call `pump()` and then check the result.

**Q: What is the difference between `pump()` and `pumpAndSettle()`?**
A: `pump()` draws one frame. `pumpAndSettle()` keeps drawing frames until all animations finish. I use `pump()` by default because it is faster and more predictable, and `pumpAndSettle()` when an animation or navigation transition has to complete first.

**Q: Why wrap the widget in `MaterialApp` in the test?**
A: Widgets like `Scaffold` and `Text` need things provided higher up the tree, such as theme, text direction, and navigation. Without `MaterialApp` the test can crash for reasons unrelated to my widget.

**Q: What does `findsOneWidget` mean, and what are the others?**
A: It is a matcher meaning exactly one match was found. Others are `findsNothing`, `findsNWidgets(n)`, and `findsWidgets` (at least one).

**Q: How do you avoid repeating the same setup in widget tests?**
A: I move the common `pumpWidget` call into a small helper function at the bottom of the test file, so I only change it in one place.

**Q: Why can a widget test pass while the app still has a bug?**
A: Widget tests run in a simulated environment. For example, two `FloatingActionButton`s with the same default hero tag only throw an error when navigating between screens, which my widget tests never did.

### Tests written
- shows Count: 0 at the start
- shows Count: 1 after tapping the add button
- shows Count: -1 after tapping the remove button

**Progress score: 46/100**

## Lesson 10: Widget tests with a mocked Cubit
- Learned: To test a screen that uses a Cubit, I mock the Cubit (`MockCubit<State>` from bloc_test), set its state with `when(() => cubit.state).thenReturn(...)`, and give it to the page with `BlocProvider.value`. Then the test only checks: given this state, does the screen show the right thing? For a button, I use `verify(() => cubit.load()).called(1)` to prove the page asked the Cubit to act.
- Struggled with: `find.text('Noshad')` found nothing because `find.text` matches the whole string, and the screen shows `'Hello, Noshad'`. I also turned the page into a StatefulWidget with an empty State, which adds code for no reason.
- Key insight: Each layer is tested on its own. The Cubit test checks which states are emitted, the widget test checks what each state looks like and what a tap asks for. A mock Cubit never changes state on its own, so a tap test checks the call, not the screen.

### Interview Q&A
**Q: Why mock the Cubit in a widget test instead of using the real one?**
A: I am testing the UI layer. A mock lets me put the screen in any state instantly, with no timing, network, or repository, and the Cubit's logic already has its own tests.

**Q: How do you provide a Cubit to a widget in a test?**
A: I wrap the page in `BlocProvider<MyCubit>.value(value: mockCubit, child: ...)` inside a `MaterialApp`, the same way the real app provides the real Cubit.

**Q: How do you test that a button tap triggers an action?**
A: I stub the method with `when(() => cubit.load()).thenAnswer((_) async {})`, tap the button, call `pump()`, and use `verify(() => cubit.load()).called(1)`. I verify the call because a mock Cubit never emits a new state by itself.

**Q: What does `find.text` match?**
A: The whole string exactly. For a partial match I use `find.textContaining`.

**Q: Why use a sealed class for states?**
A: With a `switch` over a sealed class, Dart checks that I handle every state and gives a compile error if I forget one, so a new state cannot silently go unhandled in the UI.

**Q: Should a widget use StatefulWidget when a Cubit holds the state?**
A: No. If the widget has no state of its own, StatelessWidget is enough. An empty State class is noise.

### Tests written
- shows a spinner while loading
- shows the name when loaded
- shows the error message when loading failed
- tapping Retry calls load on the cubit

**Progress score: 50/100**