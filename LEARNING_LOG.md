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