//
//  Slider.swift
//  wheel
//
//  Created by Gabriel Somma on 2023-05-10.
//

import Foundation
import SwiftUI

struct SliderPush: View {
    
    // MARK: Properties
    @State var startAngle: Double = 0
    @State var toAngle: Double = 180

    @State var startProgress: CGFloat = 0
    @State var toProgress: CGFloat = 0.5
    

    
    var body: some View {
        let reverseRotation = (startProgress > toProgress) ? -Double((1 - startProgress) * 360) : 0
        VStack {
            HStack{
                VStack(alignment: .leading, spacing: 8) {
                    Text("Wheeeeeeeeeel")
                        .font(.title.bold())
                }.frame(maxWidth: .infinity, alignment: .center)
            }
            ScheduleSlider()
                .padding(.top, 50)
            Spacer()
            Text("Start Progress: \(startProgress)")
            Text("To Progress: \(toProgress)")
            Text("Start Angle: \(startAngle)")
            Text("To Angle: \(toAngle)")
            Text("Red Progress: \(startProgress > toProgress ? 0 : startProgress)")
            Text("Green Progress: \(toProgress + (-reverseRotation / 360))")
            Text("Reverse Rotation degrees: \(reverseRotation)")
        }
        .padding()
        
        .frame(maxHeight: .infinity, alignment: .top)
        
    }
    
    // MARK: Slider
    @ViewBuilder
    func ScheduleSlider() -> some View {
        GeometryReader { proxy in
            
            let width = proxy.size.width
            
            ZStack {
                
                // MARK: Clock Design
                ZStack {
                    
                    ForEach(1...24, id: \.self) {index in
                        Rectangle()
                            .fill(.black)
                        // Each 3h will have big line
                            .frame(width: 1.5, height: index % 3 == 0 ? 10 : 5)
                        // Setting into entire circle
                            .offset(y: (width - 60) / 2)
                            .rotationEffect(.init(degrees: Double(index) * 15))
                    }
                    
                    // MARK: Clock Text
                    let texts = [12, 3, 6, 9, 12, 3, 6, 9]
                    ForEach(texts.indices, id: \.self){index in
                        
                        Text("\(texts[index])")
                            .font(.caption.bold())
                        // to rotate itself
                            .rotationEffect(.init(degrees: Double(index) * -45))
                            .offset(y: (width - 90) / 2)
                        // to rotate in the circle
                            .rotationEffect(.init(degrees: Double(index) * 45))
                    }
                }
                
                Circle()
                    .stroke(.black.opacity(0.06), lineWidth: 40)
                
                // Allow reverse swiping
                let reverseRotation = (startProgress > toProgress) ? -Double((1 - startProgress) * 360) : 0
                let totalProgress = (toProgress + (-reverseRotation / 360))
                
                Circle()
                    .trim(from: startProgress > toProgress ? 0 : startProgress, to: totalProgress)
                    .stroke(.blue, style: StrokeStyle(lineWidth: 40, lineCap: .round, lineJoin: .round))
                    .rotationEffect(.init(degrees: -90))
                    .rotationEffect(.init(degrees: reverseRotation))
                
                // Slider Buttons
                Circle()
                    .foregroundColor(.red)
                    .frame(width: 30, height: 30)
                // Moving to right and rotating
                    .offset(x: width / 2)
                    .rotationEffect(.init(degrees: startAngle)).gesture(
                        DragGesture()
                            .onChanged({value in
                                onDrag(value: value, fromSlider: true)
                            })
                    )
                    .rotationEffect(.init(degrees: -90))
                
                Circle()
                    .foregroundColor(.green)
                    .frame(width: 30, height: 30)
                // Moving to right and rotating
                    .offset(x: width / 2)
                    .rotationEffect(.init(degrees: toAngle))
                    .gesture(
                        DragGesture()
                            .onChanged({value in
                                onDrag(value: value)
                            })
                    )
                    .rotationEffect(.init(degrees: -90))
                
                
            }
        }
        .frame(width: screenBounds().width / 1.6, height: screenBounds().width / 1.6)
    }
    
    func onDrag(value: DragGesture.Value, fromSlider: Bool = false){
        
        // MARK: Converting translation into angle
        let vector = CGVector(dx: value.location.x, dy: value.location.y)
        
        //Removing radius of button
        let radians = atan2(vector.dy - 15, vector.dx - 15)
        
        //converting into angle
        var angle = radians * 180 / .pi
        if angle < 0 { angle = 360 + angle}
        
        // Progress
        let progress = angle / 360
        
        
        if self.startAngle < 0 {startAngle = startAngle + 360}
        if self.toAngle > 360 {toAngle = toAngle - 360}
        if self.startProgress < 0 {startProgress = startProgress + 1}
        if self.toProgress > 1 {toProgress = toProgress - 1}
        
        if fromSlider {
            // Update from values
            self.startAngle = angle
            self.startProgress = progress
            
            if abs(self.startAngle - self.toAngle) < 36 || abs(self.toAngle - self.startAngle) < 36 {
                if self.startAngle > self.toAngle {
                    self.toAngle = self.startAngle - 36
                    self.toProgress = self.startProgress - 0.1
                } else {
                    self.toAngle = self.startAngle + 36
                    self.toProgress = self.startProgress + 0.1
                }
            }
        } else {
            // update to values
            self.toAngle = angle
            self.toProgress = progress
            
            if abs(self.startAngle - self.toAngle) < 36 || abs(self.toAngle - self.startAngle) < 36 {
                if self.toAngle > self.startAngle {
                    self.startAngle = self.toAngle - 36
                    self.startProgress = self.toProgress - 0.1
                } else {
                    self.startAngle = self.toAngle + 36
                    self.startProgress = self.toProgress + 0.1
                }
            }
        }
            
    }
    
}

struct SliderPush_Previews: PreviewProvider {
    static var previews: some View {
        SliderPush()
    }
}
