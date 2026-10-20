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