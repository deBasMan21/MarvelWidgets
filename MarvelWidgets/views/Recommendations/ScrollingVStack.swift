//
//  ScrollingVStack.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 04/06/2023.
//

import Foundation
import SwiftUI

extension VStack {
    func snappingScrollView(
        amount: Int,
        height: CGFloat,
        activeIndex: Binding<Int>,
        refreshCallback: @escaping () -> Int,
        fetchNextCallback: @escaping () async -> Int
    ) -> some View {
        return self.modifier(
            ScrollingVStackModifier(
                items: amount,
                itemHeight: height,
                index: activeIndex,
                refreshCallback: refreshCallback,
                fetchNextCallback: fetchNextCallback
            )
        )
    }
}

struct ScrollingVStackModifier: ViewModifier {
    @State private var scrollOffset: CGFloat = 0
    @State private var dragOffset: CGFloat = 0
    @State private var previousIndex: CGFloat = 0
    @Binding private var index: Int
    
    private var items: Int
    private var itemHeight: CGFloat
    private var refreshCallback: () -> Int
    private var fetchNextCallback: () async -> Int
    
    private var contentHeight: CGFloat {
        CGFloat(items) * itemHeight
    }
    private var screenHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    
    init(
        items: Int,
        itemHeight: CGFloat,
        index: Binding<Int>,
        refreshCallback: @escaping () -> Int,
        fetchNextCallback: @escaping () async -> Int
    ) {
        self.items = items
        self.itemHeight = itemHeight
        self.refreshCallback = refreshCallback
        self.fetchNextCallback = fetchNextCallback
        self._index = index
        
        // Set Initial Offset to first Item
        self._scrollOffset = State(wrappedValue: contentHeight / 2 - screenHeight / 2)
        self._previousIndex = State(wrappedValue: CGFloat(items) - 1)
    }
    
    func scrollToIndex(index: Int) {
        previousIndex = CGFloat(index)
        
        // Calculate the offset for the first item
        let offset: CGFloat = (contentHeight / 2) - (screenHeight / 2) - (CGFloat(index) * itemHeight)
        
        // Calculate duration for the animation
        var duration = abs(offset - scrollOffset) / itemHeight * 0.1
        duration = min(duration, 1)
        
        // Animate scrolling to top
        withAnimation(Animation.easeInOut(duration: duration)) {
            scrollOffset = offset
        }
    }
    
    func body(content: Content) -> some View {
        content
            .offset(x: 0, y: scrollOffset + dragOffset + 22)
            .gesture(DragGesture()
                .onChanged({ event in
                    dragOffset = event.translation.height
                })
                .onEnded({ event in
                    // Scroll to where user dragged
                    scrollOffset += event.translation.height
                    dragOffset = 0
                    
                    // Center position of current offset
                    let center = scrollOffset + (contentHeight / 2.0)
                    
                    // Calculate which item we are closest to using the defined size
                    var index = center / itemHeight
                    
                    // Calculate velocity based on the predicted location
                    let velocity = event.predictedEndLocation.y - event.location.y
                    
                    // Check if the velocity is high enough to swipe to the next page
                    if abs(velocity) > 100 {
                        // Check if the velocity is upwards or downwards
                        if velocity > 0 {
                            // Get the new index
                            index = CGFloat(Int(index))
                            
                            // If it is still the same it needs to be upped by one
                            if index == previousIndex {
                                index += 1
                            }
                        } else {
                            // Get the new index
                            index = CGFloat(Int(index))
                            
                            // If it is still the same it needs to be subtracted by one
                            if index == previousIndex {
                                index -= 1
                            }
                        }
                    } else {
                        // Not enough velocity so go back to previous index
                        index = previousIndex
                    }
                    
                    var amount: Int? = nil
                    
                    if index > CGFloat(items) - 1 {
                        amount = self.refreshCallback()
                    }
                    
                    // Protect from scrolling out of bounds
                    index = min(index, CGFloat(items) - 1)
                    index = max(index, 0)
                    
                    // Set the previous index to this one
                    previousIndex = index
                    
                    // Set final offset (snapping to item)
                    let newOffset = index * itemHeight - (contentHeight / 2.0) + (screenHeight / 2.0) - ((screenHeight - itemHeight) / 2.0)
                    
                    // Calculate duration for the animation
                    let duration = abs(scrollOffset - newOffset) / (3 * screenHeight)
                    
                    // Animate snapping
                    withAnimation(Animation.easeOut(duration: duration)) {
                        scrollOffset = newOffset
                    }
                    
                    Task {
                        if index == 0 {
                            amount = await self.fetchNextCallback()
                        }
                        
                        if let amount = amount {
                            await MainActor.run {
                                scrollOffset += ((CGFloat(amount) * itemHeight) / 2)
                                previousIndex += CGFloat(amount)
                            }
                        }
                        
                        self.index = Int(previousIndex)
                    }
                })
            ).onChange(of: index, perform: { newValue in
                if CGFloat(newValue) != previousIndex {
                    scrollToIndex(index: newValue)
                }
            })
    }
}
