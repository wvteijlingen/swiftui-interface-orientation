import SwiftUI

extension View {
    /// Specifies the interface orientations supported by this view.
    ///
    /// > This modifier requires correct set up of the ``InterfaceOrientationCoordinator``. See documentation for
    /// ``InterfaceOrientationCoordinator``
    ///
    /// ## Multiple orientations
    /// If orientations are specified by multiple views, the allowed orientations for the interface
    /// are defined by the lowest common denominator (i.e. the intersection of all specified orientations).
    ///
    /// For example, given the following code, the only allowed orientation is `.portrait` because that is
    /// the only orientation which is supported by all views:
    ///
    /// ```swift
    /// VStack {
    ///     A().interfaceOrientations([.portrait, .landscape])
    ///     B().interfaceOrientations([.portrait, .portraitUpsideDown])
    /// }
    /// ```
    /// - Parameter orientations: The orientations supported by this view, or `nil` to use default app orientations.
    public func interfaceOrientations(_ orientations: UIInterfaceOrientationMask?) -> some View {
        return modifier(InterfaceOrientationsViewModifier(orientations: orientations ?? []))
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
                if !orientations.isEmpty {
                    InterfaceOrientationCoordinator.shared.register(orientations: orientations, id: id)
                }
            }
            .onDisappear {
                InterfaceOrientationCoordinator.shared.unregister(orientationsWithID: id)
            }
            .onChange(of: orientations) { newValue in
                if orientations.isEmpty {
                    InterfaceOrientationCoordinator.shared.unregister(orientationsWithID: id)
                } else {
                    InterfaceOrientationCoordinator.shared.register(orientations: newValue, id: id)
                }
            }
    }
}
