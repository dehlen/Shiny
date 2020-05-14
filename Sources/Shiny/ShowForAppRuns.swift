//
//  ShowForAppRuns.swift
//  
//
//  Created by Ehlen, David on 14.05.20.
//

import SwiftUI

private struct ShowForAppRuns: ViewModifier {
    private static var runCounts = [String: Int]()

    private let count: Int
    private let startShowingFromAppRun: Int
    private var runCount: Int = 0
    private let showForAppRuns = UserDefaultsProperty<Int>("showForAppRuns")

    init(count: Int, id: String, startShowingFromAppRun: Int = 1) {
        assert(startShowingFromAppRun >= 1)
        self.count = count
        self.startShowingFromAppRun = startShowingFromAppRun

        self.runCount = {
            guard let count = Self.runCounts[id] else {
                let key = showForAppRuns.value ?? 0
                showForAppRuns.value = key + 1
                let count = showForAppRuns.value ?? 0
                Self.runCounts[id] = count
                return count
            }

            return count
        }()
    }

    func body(content: Content) -> some View {
        if
            runCount >= startShowingFromAppRun,
            runCount < (count + startShowingFromAppRun)
        {
            return AnyView(content)
        } else {
            return AnyView(EmptyView())
        }
    }
}

private final class UserDefaultsProperty<T> {
    private let identifier: String

    public init(_ identifier: String) {
        self.identifier = identifier
    }

    // Would like to make the value property non-optional. But that depends on a fix/workaround
    // for https://bugs.swift.org/browse/SR-4479.
    /// Store/Retrieve a value for the given key in the UserDefaults
    var value: T? {
        set {
            UserDefaults.standard.set(newValue, forKey: identifier)
        }
        get {
            return UserDefaults.standard.object(forKey: identifier) as? T
        }
    }

    /// Remove key/value pair from UserDefaults
    func remove() {
        UserDefaults.standard.removeObject(forKey: identifier)
    }
}

public extension View {
    // TODO: Improve method and parameter naming.
    /**
    Show the view only for the given amount of app runs.
    - Parameter count: Show the view this many app runs.
    - Parameter id: Identifier for the view. Should be unique in the app. Prefer camel case notation.
    - Parameter startShowingFromAppRun: Start showing the view at this app run count.
    Tip: Specify `0` as `count` to see how it will look like as hidden.
    ```
    // This shows the text on the second time the app is run and shows it for two app runs.
    Text("🦄").showForAppRun(2, id: "unicornText", startShowingFromAppRun: 2)
    ```
    */
    func showForAppRuns(_ count: Int, id: String, startShowingFromAppRun: Int = 1) -> some View {
        modifier(ShowForAppRuns(count: count, id: id, startShowingFromAppRun: startShowingFromAppRun))
    }
}
