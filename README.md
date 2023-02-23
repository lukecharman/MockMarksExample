# Stubbie

## What is Stubbie?

Stubbie is a pair of Swift packages used to easily create local, stubbed responses to network calls made via `URLSession`. These are managed entirely within Xcode, and no HTTP server or other intermediary is required. Using Stubbie, you can:

* Queue specific stubbed JSON responses to requests to specific endpoint URLs.
* Return those stubbed responses in the order they were queued to create a flow.
* Use `URLSession` as normal in your app's features, meaning Stubbie is not exposed to your features internally.

## How does it work?

`Stubbie` and its sister package `StubbieTestUtils` are added as dependencies of your `App` and its `AppUITests` targets respectively. They're only a few kilobytes in size and will have no major impact on the size of your release binary in the App Store. Stubbie works best when your app uses a shared instance of `URLSession`, as in this case, you only need `import Stubbie` once. To get up and running:

* Add `Stubbie` as a dependency of your app.
* Add `Stubbie` and `StubbieTestUtils` as dependencies of your UI test target
  * Project Settings -> tap your UI test target -> Build Phases -> add them inside Link Binary With Libraries
* In your app, set up Stubbie as soon as your app launches:
  ```
  if Stubbie.isXCUITest {
    Stubbie.setUp()
    Stubbie.session = StubbieURLSession(stubbing: .shared) 
  }
  ```
* When you use `URLSession` in your app, use `Stubbie.session` instead:
  ```
  SomeRandomViewModel(urlSession: Stubbie.session ?? .shared)
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
* In your UI test target, have the test classes inherit from `StubbieUITestCase`.
* In the actual tests, launch the app with the name of the stubs file to use for this test.
  Here, we'd name the stub file in the app target "test_aThing_doesAnotherThing().json"
  ```
  class StubbieSamplerUITests: StubbieUITestCase {
    func test_aThing_doesAnotherThing() {
      launchApp(withStubsNamed: #function)
      XCTAssert(self.app.staticTexts["STUBBED"].waitForExistence(timeout: 5))
    }
  }
  ```

For now, that's about it! The app will then use the mocked responses, in order, when you call `URLSession`'s `dataTask` methods.

The JSON files live inside your app bundle, but we don't want to ship them with the app itself. So, we can use a build phase that's something like this to strip them out:
  ```
  if [ "${CONFIGURATION}" = "Release" ]; then
    rm "${BUILT_PRODUCTS_DIR}/StubbieSampler.app/test_mockedResponse_array().json"
    echo "Release build, clearing test JSON files from build."
  fi
```

More info to come, early days, etc.

## Show me!

There's a `StubbieSampler` in this repo. Build it, take a look.
