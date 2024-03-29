//
//  AccessoryRectengularWidget.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 08/02/2023.
//

import SwiftUI

struct AccessoryRectengularWidget: View {
    @State var project: ProjectWrapper
    
    var body: some View {
        HStack {
            if let dateFormatted = project.attributes.getDaysUntilRelease(withDaysString: false) {
                Text(dateFormatted)
                    .font(.system(size: 50))
                    .minimumScaleFactor(0.01)
                    .bold()
                    .frame(width: 30)
                
                Divider()
            }
            
            VStack {
                Text(project.attributes.title)
                    .multilineTextAlignment(.center)
                
                Text(project.attributes.getReleaseDateString())
                    .font(.system(size: 10))
                    .lineLimit(1)
            }
        }.widgetURL(URL(string: project.getUrl()))
    }
}
