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