//
//  cogratePage.swift
//  financialGoal
//
//  Created by basant amin bakir on 30/09/2024.
//

//import SwiftUI
import SwiftUI
import UIKit

struct CelebrationView: View {
    var body: some View {
        ZStack {
            
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 50) {
              
                Text("🎉 Congratulations 🎉")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.top, 150.0)
                Text("100%")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)

                
                ZStack {
                    Circle()
                        .trim(from: 0.0, to: 1.0)
                        .stroke(
                            LinearGradient(gradient: Gradient(colors: [Color.purple]),
                                           startPoint: .leading, endPoint: .trailing),
                            lineWidth: 20
                        )
                        .frame(width: 180, height: 180)
                        .rotationEffect(.degrees(-90))
                        .shadow(color: Color.gray.opacity(0.5), radius: 10, x: 0, y: 5)

                    VStack {

                        Text("🥳")
                            .font(.system(size: 40))
                    }
                }

                Button(action: {
                    
                    print("Start New Goal tapped")
                }) {
                    Text("Start New Goal")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.mint)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)                }

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) //
            .background(ConfettiUIView().ignoresSafeArea()) //
            .onAppear {
                
            }
        }
    }
}

struct ConfettiUIView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        
        let emitterLayer = CAEmitterLayer()
        emitterLayer.emitterPosition = CGPoint(x: view.bounds.midX, y: -10) // Emitter position at the top
        emitterLayer.emitterSize = CGSize(width: view.bounds.size.width, height: 1)
        emitterLayer.emitterShape = .line
        
        let colors: [UIColor] = [.red, .green, .blue, .yellow, .orange, .purple, .cyan, .magenta]
        var cells: [CAEmitterCell] = []
        
        for color in colors {
            cells.append(createConfettiCell(color: color, shape: .rectangle))
            cells.append(createConfettiCell(color: color, shape: .circle))
            cells.append(createConfettiCell(color: color, shape: .star))
        }
        
        emitterLayer.emitterCells = cells
        view.layer.addSublayer(emitterLayer)
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
   
    private func createConfettiCell(color: UIColor, shape: ConfettiShape) -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.birthRate = 20
        cell.lifetime = 14.0
        cell.velocity = 150
        cell.velocityRange = 70
        cell.emissionRange = .pi
        cell.spin = 3.5
        cell.spinRange = 4.0
        
        cell.contents = createConfettiLayer(color: color, shape: shape)
        cell.scale = 0.4
        cell.scaleRange = 0.3
        cell.yAcceleration = 150
        cell.alphaSpeed = -0.2
        
        return cell
    }
  
    private func createConfettiLayer(color: UIColor, shape: ConfettiShape) -> CGImage? {
        let size = CGSize(width: 20, height: 20)
        UIGraphicsBeginImageContext(size)
        color.setFill()
        let path: UIBezierPath
        switch shape {
        case .circle:
            path = UIBezierPath(ovalIn: CGRect(origin: .zero, size: size))
        case .star:
            path = UIBezierPath()
            drawStar(path: path, rect: CGRect(origin: .zero, size: size))
        case .rectangle:
            path = UIBezierPath(rect: CGRect(origin: .zero, size: size))
        }
        path.fill()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image?.cgImage
    }
    
    private func drawStar(path: UIBezierPath, rect: CGRect) {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = rect.width / 2
        let starPoints = 5
        let angle = CGFloat.pi * 2 / CGFloat(starPoints * 2)
        let startAngle = -CGFloat.pi / 2
        
        path.move(to: CGPoint(x: center.x, y: center.y - radius))
        for i in 1...(starPoints * 2) {
            let angleOffset = CGFloat(i) * angle + startAngle
            let pointRadius = i % 2 == 0 ? radius : radius * 0.4
            let point = CGPoint(x: center.x + cos(angleOffset) * pointRadius,
                                y: center.y + sin(angleOffset) * pointRadius)
            path.addLine(to: point)
        }
        path.close()
    }
}


enum ConfettiShape {
    case circle
    case star
    case rectangle
}

struct CelebrationView_Previews: PreviewProvider {
    static var previews: some View {
        CelebrationView()
    }
}
