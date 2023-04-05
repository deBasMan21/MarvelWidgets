//
//  ViewExtensions+tabbar.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 05/04/2023.
//

import Foundation
import SwiftUI

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
                view.setTabBarHidden(false)
            }
        })
    }
    
    static func hideTabBar() {
        UIApplication.shared.key?.allSubviews().forEach({ subView in
            if let view = subView as? UITabBar {
                view.setTabBarHidden(true)
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
    @State var inSheet: Bool
    
    init(inSheet: Bool) {
        self.inSheet = inSheet
    }
    
    func body(content: Content) -> some View {
        return content.padding(.zero).onAppear {
            TabBarModifier.hideTabBar()
        }.onDisappear {
            if inSheet {
                TabBarModifier.showTabBar()
            }
        }
    }
}

extension View {
    func showTabBar(featureFlag: Bool) -> some View {
        self.if(featureFlag, transform: { view in
            view.modifier(ShowTabBar())
        })
    }

    func hiddenTabBar(featureFlag: Bool, inSheet: Bool = false) -> some View {
        self.if(featureFlag && !inSheet, transform: { view in
            view.modifier(HiddenTabBar(inSheet: inSheet))
        })
    }
}

extension UITabBar {
    func setTabBarHidden(_ hidden: Bool, animated: Bool = true, duration: TimeInterval = 0.3) {
        if self.isHidden != hidden {
            if animated {
                //Show the tabbar before the animation in case it has to appear
                if self.isHidden {
                    self.isHidden = hidden
                }
                
                let factor: CGFloat = hidden ? 1 : -1
                let y = self.frame.origin.y + (self.frame.size.height * factor)
                UIView.animate(withDuration: duration, animations: {
                    self.frame = CGRect(x: self.frame.origin.x, y: y, width: self.frame.width, height: self.frame.height)
                }) { (bool) in
                    //hide the tabbar after the animation in case ti has to be hidden
                    if !(self.isHidden){
                        self.isHidden = hidden
                    }
                }
            }
        }
    }
}
