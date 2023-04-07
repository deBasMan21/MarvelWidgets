//
//  AccessoryCircularWidget.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 08/02/2023.
//

import SwiftUI

struct AccessoryCircularWidget: View {
    @State var project: ProjectWrapper
    
    var body: some View {
        ZStack {
            Color.black
            
            VStack {
                Text("\(project.attributes.getDaysUntilRelease(withDaysString: false) ?? "")")
                    .font(.system(size: 20))
                    .bold()
                
                Text(project.attributes.title)
                    .font(.system(size: 8))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }.widgetURL(project.getUrl())
    }
}
