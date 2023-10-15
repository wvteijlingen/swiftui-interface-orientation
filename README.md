# swiftui-interface-orientation

The view modifier that Apple forgot. *SwiftInterfaceOrientation* allows you to easily specify the orientations
that are supported by your SwiftUI views.

## Usage

Attach the `.interfaceOrientations` modifier to any SwiftUI view to specify the interface orientations that are
supported by that view. As long as the view is visible, rotation to the specified orientations will be allowed.

For example, the following view will be restricted to the `.portrait` orientation, unless the Toggle is switched on:

```swift
import InterfaceOrientation

struct MyView: View {
    @State private var isLandscapeAllowed = false

    var body: some View {
        Toggle("Allow landscape", isOn: $isLandscapeAllowed)
            .interfaceOrientations(isLandscapeAllowed ? [.portrait, .landscape] : .portrait)
    }
}
```

## Setup
Create an application delegate using `@UIApplicationDelegateAdaptor`, and implement `application(_:supportedInterfaceOrientationsFor:)`:

```swift
private class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        InterfaceOrientationCoordinator.shared.supportedOrientations
    }
}
```

## Multiple views

If orientations are specified by multiple views, the supported orientations for the app are defined by the lowest
common denominator (i.e. the intersection of all specified orientations).

For example, given the following code, the only allowed orientation is `.portrait` because that is
the only orientation which is supported by all views:

```swift
VStack {
    A().interfaceOrientations([.portrait, .landscape])
    B().interfaceOrientations([.portrait, .portraitUpsideDown])
}
```

## Default orientations

When there are no views that specify custom orientations, a set of default orientations will be used.

*SwiftInterfaceOrientation* attempts to read this set from the Info.plist, but you can set it manually using
`InterfaceOrientationCoordinator.shared.defaultOrientations`

### Overriding default orientations

Views are allowed to support orientations that are not present in the set of default orientations.

This means that if a view supports `.landscapeLeft`, the interface can rotate to landscape, even when
the default orientations don't include `.landscapeLeft`.
