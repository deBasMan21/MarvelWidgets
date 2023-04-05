//
//  ViewExtensions+tabbar.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 05/04/2023.
//

import Foundation
import SwiftUI
import Introspect

extension UIApplication {
    var key: UIWindow? {
        self.connectedScenes
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?
            .windows
            .filter({$0.isKeyWindow})
            .first
    }
}


extension UIView {
    func allSubviews() -> [UIView] {
        var subs = self.subviews
        for subview in self.subviews {
            let rec = subview.allSubviews()
            subs.append(contentsOf: rec)
        }
        return subs
    }
}
    

struct TabBarModifier {
    static func showTabBar() {
        UIApplication.shared.key?.allSubviews().forEach({ subView in
            if let view = subView as? UITabBar {
                view.isHidden = false
            }
        })
    }
    
    static func hideTabBar() {
        UIApplication.shared.key?.allSubviews().forEach({ subView in
            if let view = subView as? UITabBar {
                view.isHidden = true
            }
        })
    }
}

struct ShowTabBar: ViewModifier {
    func body(content: Content) -> some View {
        return content.padding(.zero).onAppear {
            TabBarModifier.showTabBar()
        }
    }
}
struct HiddenTabBar: ViewModifier {
    func body(content: Content) -> some View {
        return content.padding(.zero).onAppear {
            TabBarModifier.hideTabBar()
        }.onDisappear {
            TabBarModifier.showTabBar()
        }
    }
}

extension View {
    func showTabBar(featureFlag: Bool) -> some View {
        self.if(featureFlag, transform: { view in
            view.modifier(ShowTabBar())
        })
    }

    func hiddenTabBar(featureFlag: Bool) -> some View {
        self.if(featureFlag, transform: { view in
            view.modifier(HiddenTabBar())
        })
    }
}
