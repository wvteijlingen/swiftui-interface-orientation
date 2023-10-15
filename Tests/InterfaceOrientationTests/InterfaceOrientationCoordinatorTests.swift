import XCTest
import UIKit
@testable import InterfaceOrientation

final class InterfaceOrientationCoordinatorTests_whenNoOverridesAllowed: XCTestCase {
    var coordinator: InterfaceOrientationCoordinator!

    override func setUp() async throws {
        try await super.setUp()

        coordinator = InterfaceOrientationCoordinator(
            defaultOrientations: .portrait,
            allowOverridingDefaultOrientations: false
        )
    }

    func test_supportedOrientations_withNoViews_returnsDefault() throws {
        let actual = coordinator.supportedOrientations
        let expected: UIInterfaceOrientationMask = .portrait

        XCTAssertEqual(actual, expected)
    }

    func test_supportedOrientations_whenOneView_returnsResolved() throws {
        coordinator.register(orientations: .landscapeLeft, id: UUID())

        let actual = coordinator.supportedOrientations
        let expected: UIInterfaceOrientationMask = [.portrait]

        XCTAssertEqual(actual, expected)
    }

    func test_supportedOrientations_whenMultipleViews_returnsIntersection() throws {
        coordinator.register(orientations: .portrait, id: UUID())
        coordinator.register(orientations: [.portrait, .landscapeLeft], id: UUID())
        coordinator.register(orientations: [.portrait, .landscapeLeft, .landscapeRight], id: UUID())

        let actual = coordinator.supportedOrientations
        let expected: UIInterfaceOrientationMask = [.portrait]

        XCTAssertEqual(actual, expected)
    }

    func test_supportedOrientations_whenNoIntersection_returnsDefault() throws {
        coordinator.register(orientations: .portrait, id: UUID())
        coordinator.register(orientations: [.landscapeLeft], id: UUID())
        coordinator.register(orientations: [.landscapeRight], id: UUID())

        let actual = coordinator.supportedOrientations
        let expected: UIInterfaceOrientationMask = .portrait

        XCTAssertEqual(actual, expected)
    }
}

final class InterfaceOrientationCoordinatorTests_whenOverridesAllowed: XCTestCase {
    var coordinator: InterfaceOrientationCoordinator!

    override func setUp() async throws {
        try await super.setUp()

        coordinator = InterfaceOrientationCoordinator(
            defaultOrientations: .all,
            allowOverridingDefaultOrientations: true
        )
    }

    func test_supportedOrientations_withNoViews_returnsDefault() throws {
        let actual = coordinator.supportedOrientations
        let expected: UIInterfaceOrientationMask = .all

        XCTAssertEqual(actual, expected)
    }

    func test_supportedOrientations_whenOneView_returnsResolved() throws {
        coordinator.register(orientations: .landscapeLeft, id: UUID())

        let actual = coordinator.supportedOrientations
        let expected: UIInterfaceOrientationMask = [.landscapeLeft]

        XCTAssertEqual(actual, expected)
    }

    func test_supportedOrientations_whenMultipleViews_returnsIntersection() throws {
        coordinator.register(orientations: .portrait, id: UUID())
        coordinator.register(orientations: [.portrait, .landscapeLeft], id: UUID())
        coordinator.register(orientations: [.portrait, .landscapeLeft, .landscapeRight], id: UUID())

        let actual = coordinator.supportedOrientations
        let expected: UIInterfaceOrientationMask = [.portrait]

        XCTAssertEqual(actual, expected)
    }

    func test_supportedOrientations_whenNoIntersection_returnsDefault() throws {
        coordinator.register(orientations: .portrait, id: UUID())
        coordinator.register(orientations: [.landscapeLeft], id: UUID())
        coordinator.register(orientations: [.landscapeRight], id: UUID())

        let actual = coordinator.supportedOrientations
        let expected: UIInterfaceOrientationMask = .all

        XCTAssertEqual(actual, expected)
    }
}
