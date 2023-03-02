# MockMarks+XCUI

An `XCTestCase` subclass named `MockMarksUITestCase` from which all MockMarks tests should inherit.

This package should only be imported into your UI testing target. To do this:
* Tap your app's project in the Project Navigator.
* Under "Targets", tap your app's UI testing target.
* Tap Build Phases.
* Unfold the "Link Binary With Libraries" section.
* Use the plus icon to add both `MockMarks` and `MockMarks+XCUI` to the list.
