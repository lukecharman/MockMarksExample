# MockMarks

## What is MockMarks?

MockMarks is a pair of Swift packages used to easily create local, mocked responses to network calls made
via `URLSession`. These are managed entirely within Xcode, and no HTTP server or other intermediary is required.
Using MockMarks, you can:

* Queue specific mocked JSON responses to requests to specific endpoint URLs.
* Return those mocked responses in the order they were queued to create a flow.
* Use `URLSession` as normal in your app's features, meaning MockMarks is not exposed to your features internally.

## How does it work?

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

## Show me!

There's a `MockMarksExample` in this repo. Build it, take a look.
