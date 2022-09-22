//
//  Home.swift
//  Metaballs
//
//  Created by Nick Rice on 22/09/2022.
//

import SwiftUI

struct Home: View {
    @State private var dragOffset: CGSize = .zero
    
    var body: some View {
        VStack {
            SingleMetaball()
        }
    }
    
    @ViewBuilder
    func SingleMetaball() -> some View {
        
        // MARK: Custom Color Mask
        Rectangle()
            .fill(.linearGradient(colors: [Color("Color1"), Color("Color2")], startPoint: .topLeading, endPoint: .bottomTrailing))
            .mask {
                Canvas { context, size in
                    context.addFilter(.alphaThreshold(min: 0.5, color: .white))
                    context.addFilter(.blur(radius: 30))
                    
                    context.drawLayer { ctx in
                        for index in [1,2] {
                            if let resolvedView = context.resolveSymbol(id: index) {
                                ctx.draw(resolvedView, at: CGPoint(x: size.width / 2, y: size.height / 2))
                            }
                        }
                    }
                    
                } symbols: {
                    Metaballs()
                        .tag(1)
                    
                    Metaballs(offset: dragOffset)
                        .tag(2)
                }
            }
    
        .gesture(
            DragGesture()
                .onChanged({ value in
                    dragOffset = value.translation
                })
                .onEnded({ _ in
                    withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                        dragOffset = .zero
                    }
                })
        )
    }
    
    @ViewBuilder
    func Metaballs(offset: CGSize = .zero) -> some View {
        Circle()
            .fill(.white)
            .frame(width: 150, height: 150)
            .offset(offset)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
