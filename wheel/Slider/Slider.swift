//
//  Slider.swift
//  wheel
//
//  Created by Gabriel Somma on 2023-05-10.
//

import Foundation
import SwiftUI

struct Slider: View {
    
    // MARK: Properties
    @State var startAngle: Double = 0
    @State var toAngle: Double = 180

    @State var startProgress: CGFloat = 0
    @State var toProgress: CGFloat = 0.5
    
    @State var isRedStart: Bool = true
    @State var isGreenStart: Bool = false
    

    
    var body: some View {
        let totalProgress = ((toAngle / 360) + (-startAngle / 360))
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
            Text("Total Progress: \(totalProgress)")
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
//                let reverseRotation = (startProgress > toProgress) ? -Double((1 - startProgress) * 360) : 0
                let totalProgress = ((toAngle / 360) + (-startAngle / 360))
                
                Circle()
                    .trim(from: 0, to: totalProgress)
                    .stroke(.blue, style: StrokeStyle(lineWidth: 40, lineCap: .round, lineJoin: .round))
//                    .rotationEffect(.init(degrees: -90))
                    .rotationEffect(.init(degrees: startAngle))
                
                // Slider Buttons
                Circle()
                    .foregroundColor(.red)
                    .frame(width: 30, height: 30)
                // Moving to right and rotating
                    .offset(x: width / 2)
                    .rotationEffect(.init(degrees: startAngle)).gesture(
                        DragGesture()
                            .onChanged({value in
                                onDrag(value: value, fromSlider: isRedStart)
                            })
                    )
//                    .rotationEffect(.init(degrees: -90))
                
                Circle()
                    .foregroundColor(.green)
                    .frame(width: 30, height: 30)
                // Moving to right and rotating
                    .offset(x: width / 2)
                    .rotationEffect(.init(degrees: toAngle))
                    .gesture(
                        DragGesture()
                            .onChanged({value in
                                onDrag(value: value, fromSlider: isGreenStart)
                            })
                    )
//                    .rotationEffect(.init(degrees: -90))
                
                
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
//        if angle < 0 { angle = 360 + angle}
        
        // Progress
        let progress = angle / 360
        
        if fromSlider {
            // Update from values
            self.startAngle = angle
            self.startProgress = progress

        } else {
            // update to values
            self.toAngle = angle
            self.toProgress = progress
        }
        
        if self.startAngle == self.toAngle {
            isRedStart.toggle()
            isGreenStart.toggle()
        }
            
    }
    
}

struct Slider_Previews: PreviewProvider {
    static var previews: some View {
        Slider()
    }
}

extension View {
    
    func screenBounds() -> CGRect {
        return UIScreen.main.bounds
    }
}
