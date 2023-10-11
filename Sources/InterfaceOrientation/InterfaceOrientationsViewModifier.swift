import SwiftUI

extension View {
    /// Specifies the interface orientations supported by this view, as long as the view is visible.
    ///
    /// > This modifier requires correct set up of the ``InterfaceOrientationCoordinator``. See documentation for
    /// ``InterfaceOrientationCoordinator``
    ///
    /// ## Multiple orientations
    /// If orientations are specified by multiple views in the visible view hierarchy,
    /// the resolved set of allowed orientations is defined by the intersection of all specified orientations.
    ///
    /// For example, given the following code, the only allowed orientation is 'portrait', because that is
    /// the only orientation that is specified by all views:
    ///
    /// ```swift
    /// VStack {
    ///     A().interfaceOrientations([.portrait, .landscape])
    ///     B().interfaceOrientations([.portrait, .portraitUpsideDown])
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
