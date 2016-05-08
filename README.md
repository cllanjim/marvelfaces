# Adding the framework to your project
1. Open your project in Xcode.
2. Drag and drop the *FaceTracker.framework* file into the project navigator.
3. In the popup that appears, ensure *Copy items if needed* is checked and click *Finish*.
4. Select the project in the project navigator to open up the project settings. Select the main target and drag and drop the *FaceTracker.framework* file from the project navigator to the *Embedded Binaries* section.
5. Go to the *Build Settings* tab and set *Enable Bitcode* to *No*.
6. Open your project's Info.plist file. Add the following row: "App Transport Security". (To add a row, right-click an existing row and select 'Add Row', then use the drop-down to select the desired key.)
7. Click to open the disclosure triangle next to App Transport Security and add the sub-key "Allow Arbitrary Loads". Make sure to set the value for this row to YES.

# Using the framework
* A view controller called *FaceTrackerViewController* has been included which handles the face tracking and rendering. This view controller can be instantiated using code or through interface builder.
* The view controller provides a protocol called *FaceTrackerViewControllerDelegate* which notifies the delegate whenever the face points have changed.
* The delegate can use the returned face points to adjust the positioning of the views in the app.

# Demo App
A demo app has been included that shows an example of how to use the face tracker framework.