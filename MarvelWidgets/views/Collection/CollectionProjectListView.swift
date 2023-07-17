//
//  CollectionProjectListView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 17/07/2023.
//

import SwiftUI

struct CollectionProjectListView: View {
    @State var collectionId: Int
    @State var inSheet: Bool
    @State var projects: [ProjectWrapper] = []
    
    var body: some View {
        VStack(spacing: 30) {
            ForEach(projects) { project in
                HorizontalProjectView(project: project, inSheet: inSheet)
            }
        }.task {
            await getCollectionDetails()
        }
    }
    
    func getCollectionDetails() async {
        let collection = await ProjectService.getCollectionById(id: collectionId)
        guard let projects = collection?.attributes.projects?.data else { return }
        self.projects = projects
    }
}
