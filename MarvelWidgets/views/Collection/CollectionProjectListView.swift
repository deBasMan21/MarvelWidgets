//
//  CollectionProjectListView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 17/07/2023.
//

import SwiftUI

struct CollectionProjectListView: View {
    @State var inSheet: Bool
    @State var projects: [ProjectWrapper]
    
    var body: some View {
        VStack(spacing: 30) {
            ForEach(projects) { project in
                HorizontalProjectView(project: project, inSheet: inSheet)
            }
        }
    }
}
