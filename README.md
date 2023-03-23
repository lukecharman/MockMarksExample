# MockMarks

## ❓ So, what is MockMarks?

MockMarks is a pair of Swift packages used to easily create local, mocked responses to network calls made
via `URLSession`. These are managed entirely within Xcode, and no HTTP server or other intermediary is required.
Using MockMarks, you can:

* Queue specific mocked JSON responses to requests to specific endpoint URLs.
* Return those mocked responses in the order they were queued to create a flow.
* Use `URLSession` as normal in your app's features, meaning MockMarks is not exposed to your features internally.

## 🧱 And how do I implement it?

`MockMarks` and its sister package `MockMarks+XCUI` are added as dependencies of your `App` and its `AppUITests`
targets respectively. They're only a few kilobytes in size and will have no major impact on the size of your release
binary in the App Store. MockMarks works best when your app uses a shared instance of `URLSession`, as in this case,
you only need `import MockMarks` once. To get up and running:

### In the project:
* Add `MockMarks` as a dependency of your app.
* Add `MockMarks` and `MockMarks+XCUI` as dependencies of your UI test target
  * Tap your app's project in the Project Navigator.
  * Under "Targets", tap your app's UI testing target.
  * Tap Build Phases.
  * Unfold the "Link Binary With Libraries" section.
  * Use the plus icon to add both `MockMarks` and `MockMarks+XCUI` to the list.
  * Ensure they are both assigned the 'Required' status.

### In the app:
* In your app, set up MockMarks as soon as your app launches:
  ```
  MockMarks.shared.setUp(session: Session())
  ```
* This will implicitly mock `URLSession.shared`, but you can pass in your own if you prefer.
* When you use `URLSession` in your app, use `MockMarks.session` instead:
  ```
  ViewModel(urlSession: MockMarks.shared.session as? URLSession ?? .shared)
  ```
  
### In the UI test target:
* In your UI test target, have the test classes inherit from `MockMarksUITestCase`.
* Call the custom `setUp()` method, like so, passing in whether or not you'd like to record.
  ```
  override func setUp() {
    super.setUp(recording: false)
  }
  ```
* This will launch your app with the required environment variables to use MockMarks.

## 🔴 Can I record with it?

Yes! One of MockMarks' handier features is the ability to record real responses provided by your APIs, and then play
them back when running the tests. You can think of this similarly to how recording works in popular snapshot testing
libraries, where you'll record a "known good" state of your API, then not hit the real network when running your tests,
allowing your UI tests to be exactly that, rather than full integration tests.

*Note: One gap here that I hope to plug in future updates to MockMarks is the ability to verify that the recorded
responses are still in line with those provided by the real backend, and some way to notify you if your backend has
changed and you're running tests against mocks which do not reflect the real API.*

### How to record:
* First, write your UI test using your real API. Ensure that it's reliable and passes.
* Once you're happy, ask MockMarks to record it by changing your `setUp()` method, like so:
  ```
  override func setUp() {
    super.setUp(recording: true)
  }
  ```
* Now, run the test again.
* As the test progresses, each call to the network through your mocked `URLSession` will now be captured.
* When the test completes, these are written to a `__Mocks__` directory in your UI tests target.
* They will be automatically titled with the name of the individual test case you were running, plus `.json`.

### How to play back:
* First, switch recording mode back off:
  ```
  override func setUp() {
    super.setUp(recording: false)
  }
  ```
* Now, re-run your tests.
* MockMarks will detect that a mock exists with the given test name, and will pass it on to your app.

## 👩‍💻 Can I try it for myself?

There's a `MockMarksExample` in this repository. You can build it and take a look, it's super simple. It uses a
free "random word" API as an example and its UI test target shows how to mock single or multiple calls to single or
multiple endpoints with MockMarks.

## 💡 What are your future plans for MockMarks?

It's still early days, and I'm excited to see how we can continue to grow MockMarks into an even more useful UI
test mocking library. It's a specific use case that I don't really want to deviate from too much, I'm thinking of
these tests as snapshots with a flow, and separate from integration testing (which is still crucially important).

Some specific things that still need doing / some ideas for the future:
* Decide on how errors are represented in the JSON and how to mock them usefully.
  * We need to think about Swift Errors vs. NSErrors vs. a JSON dictionary of error parameters, etc.
* Automatically generate mocks for an API using some sort of scripting and Swagger, etc.
* Verify recorded mocks are still up to date versus responses delivered from the backend they are mocking.

