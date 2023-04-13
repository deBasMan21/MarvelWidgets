//
//  ViewExtensions.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 09/02/2023.
//

import Foundation
import SwiftUI

extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

extension View {
    @ViewBuilder func autosizingSheet<Content: View>(showSheet: Binding<Bool>, content: @escaping () -> Content) -> some View {
        self.sheet(isPresented: showSheet) {
            AutoSizingSheet {
                content()
            }
        }
    }
}
