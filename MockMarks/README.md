# MockMarks

## Still To Do
* Decide on how error is represented in the json and how to mock it usefully.
* Write some decent documentation including "What can i mock?" list of things in the JSON that are acceptable

## What is MockMarks?

MockMarks is a pair of Swift packages used to easily create local, stubbed responses to network calls made via `URLSession`. These are managed entirely within Xcode, and no HTTP server or other intermediary is required. Using MockMarks, you can:

* Queue specific stubbed JSON responses to requests to specific endpoint URLs.
* Return those stubbed responses in the order they were queued to create a flow.
* Use `URLSession` as normal in your app's features, meaning MockMarks is not exposed to your features internally.

## How does it work?

`MockMarks` and its sister package `MockMarks+XCUI` are added as dependencies of your `App` and its `AppUITests` targets respectively. They're only a few kilobytes in size and will have no major impact on the size of your release binary in the App Store. MockMarks works best when your app uses a shared instance of `URLSession`, as in this case, you only need `import MockMarks` once. To get up and running:

* Add `MockMarks` as a dependency of your app.
* Add `MockMarks` and `MockMarks+XCUI` as dependencies of your UI test target
  * Project Settings -> tap your UI test target -> Build Phases -> add them inside Link Binary With Libraries
* In your app, set up MockMarks as soon as your app launches:
  ```
  if MockMarks.isXCUITest {
    MockMarks.setUp()
    MockMarks.session = MockMarks.Session(stubbing: .shared) 
  }
  ```
* When you use `URLSession` in your app, use `MockMarks.session` instead:
  ```
  SomeRandomViewModel(urlSession: MockMarks.session ?? .shared)
  ```
* Inside your app target, create your stub JSON files (more info on this coming!)
  ```
  [
    {
      "url": "https://the-endpoint/you/wanna/stub",
      "stub": {
        "yourStubbedResponse": "goesHere"
      }
    }
  ]
  ```
* In your UI test target, have the test classes inherit from `MockMarksUITestCase`.
* In the actual tests, launch the app with the name of the stubs file to use for this test.
  Here, we'd name the stub file in the app target "test_aThing_doesAnotherThing().json"
  ```
  class MockMarksExampleUITests: MockMarksUITestCase {
    func test_aThing_doesAnotherThing() {
      launchApp(withStubsNamed: #function)
      XCTAssert(self.app.staticTexts["STUBBED"].waitForExistence(timeout: 5))
    }
  }
  ```

For now, that's about it! The app will then use the mocked responses, in order, when you call `URLSession`'s `dataTask` methods.

The JSON files live inside your app bundle, but we don't want to ship them with the app itself. So, we can strip them out by excluding them from release builds. More info to come, early days, etc.

## Show me!

There's a `MockMarksExample` in this repo. Build it, take a look.
