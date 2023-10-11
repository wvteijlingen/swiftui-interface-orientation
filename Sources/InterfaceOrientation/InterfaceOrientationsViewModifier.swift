import SwiftUI

extension View {
    /// Specifies the interface orientations supported by this view, as long as the view is visible.
    ///
    /// > This modifier requires correct set up of the ``InterfaceOrientationCoordinator``. See documentation for
    /// ``InterfaceOrientationCoordinator``
    ///
    /// ## Orientations in Info.plist
    /// The orientations specified in the Info.plist are the default supported orientations for the application.
    /// However, if a view specifies an orientation that is not present in the Info.plist, it will still be supported.
    ///
    /// ## Multiple orientations
    /// If orientations are specified by multiple views in the visible view hierarchy,
    /// the final supported orientations are defined by the intersection all specified orientations.
    ///
    /// For example, given the following code, the only supported orientation would be 'portrait', because that is
    /// the only orientation that is supported by all views:
    ///
    /// ```swift
    /// VStack {
    ///   A().interfaceOrientations([.portrait, .landscape])
    ///   B().interfaceOrientations([.portrait, .portraitUpsideDown])
    /// }
    /// ```
    public func interfaceOrientations(_ orientations: UIInterfaceOrientationMask) -> some View {
        modifier(InterfaceOrientationsViewModifier(orientations: orientations))
    }
}

private struct InterfaceOrientationsViewModifier: ViewModifier {
    private let orientations: UIInterfaceOrientationMask
    @State private var id = UUID()

    init(orientations: UIInterfaceOrientationMask) {
        self.orientations = orientations
    }

    func body(content: Content) -> some View {
        content
            .onAppear {
                InterfaceOrientationCoordinator.shared.register(orientations: orientations, id: id)
            }
            .onDisappear {
                InterfaceOrientationCoordinator.shared.unregister(orientationsWithID: id)
            }
            .onChange(of: orientations) { newValue in
                InterfaceOrientationCoordinator.shared.register(orientations: newValue, id: id)
            }
    }
}
