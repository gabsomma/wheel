//
//  DragButton.swift
//  wheel
//
//  Created by Gabriel Somma on 2023-05-12.
//

import Foundation

struct DragButton {
    var angle: Double
    var progress: CGFloat
    var state: dragState
    
    enum dragState: String {
        case normal = "normal"
        case pushedLeft = "left"
        case pushedRight = "right"
        
    }
    
    init(angle: Double, progress: CGFloat, state: dragState) {
        self.angle = angle
        self.progress = progress
        self.state = state
    }
    
}
