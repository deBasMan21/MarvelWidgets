//
//  CategoryFilterView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 06/04/2023.
//

import Foundation
import SwiftUI

struct CategoryFilterView: View {
    @Binding var selectedCategories: [String]
    @State var categories: [String] = ["Thriller", "Sci-Fi", "Animation", "Action", "Fantasy", "Romance", "Mystery", "Horror", "Comedy", "Drama", "Adventure", "Family", "Crime", "Short"]
    
    var body: some View {
        HStack {
            Text("Category: ")
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(categories, id: \.self) { category in
                        Text(category)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 7)
                            .background(selectedCategories.contains(category) ? Color.accentColor : Color.filterGray)
                            .cornerRadius(8)
                            .onTapGesture {
                                if selectedCategories.contains(category),
                                   let index = selectedCategories.firstIndex(of: category) {
                                    selectedCategories.remove(at: index)
                                } else {
                                    selectedCategories.append(category)
                                }
                            }
                    }
                }
            }
        }
    }
}
