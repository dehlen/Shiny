//
//  Embeds.swift
//  
//
//  Created by Ehlen, David on 14.05.20.
//

import SwiftUI

public extension View {
    func embedInNavigation() -> NavigationView<Self> {
        NavigationView { self }
    }
}


public extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}
