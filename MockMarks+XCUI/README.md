# MockMarks+XCUI

An `XCTestCase` subclass named `MockMarksUITestCase` from which all MockMarks tests should inherit.

This package should be imported into your UI testing target, not your app target. To do this:
* Tap your app's project in the Project Navigator.
* Under "Targets", tap your app's UI testing target.
* Tap Build Phases.
* Unfold the "Link Binary With Libraries" section.
* Use the plus icon to add both `MockMarks` and `MockMarks+XCUI` to the list.
* Ensure they are both assigned the 'Required' status.

In your own test classes that subclass `MockMarksUITestCase`, there's just one thing to do:
* Call the custom `setUp()` method, like so, passing in whether or not you'd like to record.
* This will launch your app with the requires environment variables to use MockMarks.

```
override func setUp() {
  super.setUp(recording: false)
}
```
