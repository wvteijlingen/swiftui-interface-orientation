import XCTest
import UIKit
@testable import InterfaceOrientation

class InterfaceOrientationCoordinatorTests_base: XCTestCase {
    let coordinator = InterfaceOrientationCoordinator.shared
    var overrideIDs: [UUID] = []

    override func setUp() async throws {
        try await super.setUp()
        coordinator.defaultOrientations = .all
        coordinator.allowOverridingDefaultOrientations = false
        overrideIDs = []
    }

    override func tearDown() async throws {
        try await super.tearDown()
        for id in overrideIDs {
            coordinator.unregister(orientationsWithID: id)
        }
    }

    var overrideID: UUID {
        let id = UUID()
        overrideIDs.append(id)
        return id
    }
}

final class InterfaceOrientationCoordinatorTests_whenNoOverridesAllowed: InterfaceOrientationCoordinatorTests_base {
    override func setUp() async throws {
        try await super.setUp()
        coordinator.defaultOrientations = .portrait
        coordinator.allowOverridingDefaultOrientations = false
    }

    // MARK: -

    func test_supportedOrientations_withNoViews_returnsDefault() throws {
        let actual = coordinator.supportedOrientations
        let expected: UIInterfaceOrientationMask = .portrait

        XCTAssertEqual(actual, expected)
    }

    func test_supportedOrientations_whenOneView_returnsResolved() throws {
        coordinator.register(orientations: .landscapeLeft, id: overrideID)

        let actual = coordinator.supportedOrientations
        let expected: UIInterfaceOrientationMask = [.portrait]

        XCTAssertEqual(actual, expected)
    }

    func test_supportedOrientations_whenMultipleViews_returnsIntersection() throws {
        coordinator.register(orientations: .portrait, id: overrideID)
        coordinator.register(orientations: [.portrait, .landscapeLeft], id: overrideID)
        coordinator.register(orientations: [.portrait, .landscapeLeft, .landscapeRight], id: overrideID)

        let actual = coordinator.supportedOrientations
        let expected: UIInterfaceOrientationMask = [.portrait]

        XCTAssertEqual(actual, expected)
    }

    func test_supportedOrientations_whenNoIntersection_returnsDefault() throws {
        coordinator.register(orientations: .portrait, id: overrideID)
        coordinator.register(orientations: [.landscapeLeft], id: overrideID)
        coordinator.register(orientations: [.landscapeRight], id: overrideID)

        let actual = coordinator.supportedOrientations
        let expected: UIInterfaceOrientationMask = .portrait

        XCTAssertEqual(actual, expected)
    }
}

final class InterfaceOrientationCoordinatorTests_whenOverridesAllowed: InterfaceOrientationCoordinatorTests_base {
    override func setUp() async throws {
        try await super.setUp()
        coordinator.defaultOrientations = .all
        coordinator.allowOverridingDefaultOrientations = true
    }

    func test_supportedOrientations_withNoViews_returnsDefault() throws {
        let actual = coordinator.supportedOrientations
        let expected: UIInterfaceOrientationMask = .all

        XCTAssertEqual(actual, expected)
    }

    func test_supportedOrientations_whenOneView_returnsResolved() throws {
        coordinator.register(orientations: .landscapeLeft, id: overrideID)

        let actual = coordinator.supportedOrientations
        let expected: UIInterfaceOrientationMask = [.landscapeLeft]

        XCTAssertEqual(actual, expected)
    }

    func test_supportedOrientations_whenMultipleViews_returnsIntersection() throws {
        coordinator.register(orientations: .portrait, id: overrideID)
        coordinator.register(orientations: [.portrait, .landscapeLeft], id: overrideID)
        coordinator.register(orientations: [.portrait, .landscapeLeft, .landscapeRight], id: overrideID)

        let actual = coordinator.supportedOrientations
        let expected: UIInterfaceOrientationMask = [.portrait]

        XCTAssertEqual(actual, expected)
    }

    func test_supportedOrientations_whenNoIntersection_returnsDefault() throws {
        coordinator.register(orientations: .portrait, id: overrideID)
        coordinator.register(orientations: [.landscapeLeft], id: overrideID)
        coordinator.register(orientations: [.landscapeRight], id: overrideID)

        let actual = coordinator.supportedOrientations
        let expected: UIInterfaceOrientationMask = .all

        XCTAssertEqual(actual, expected)
    }
}
