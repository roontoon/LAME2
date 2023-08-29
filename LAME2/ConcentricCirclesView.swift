import SwiftUI

struct ConcentricCirclesView: View {
    @State private var direction: Double = 0 // This will hold the direction in degrees
    @State private var speed: Double = 0 // This will hold the speed
    
    var body: some View {
        GeometryReader { geometry in
            let centerPoint = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            let outerCircleRadius = min(geometry.size.width, geometry.size.height) / 2
            
            ZStack {
                // Draw the outer circle
                Circle()
                    .stroke(lineWidth: 2)
                    .frame(width: outerCircleRadius * 2, height: outerCircleRadius * 2)
                    .position(centerPoint)
                
                // Draw the inner circle
                Circle()
                    .stroke(lineWidth: 2)
                    .frame(width: outerCircleRadius * 0.5 * 2, height: outerCircleRadius * 0.5 * 2)
                    .position(centerPoint)
                
                // Draw the bisecting lines for the outer circle
                Path { path in
                    path.move(to: CGPoint(x: centerPoint.x, y: centerPoint.y - outerCircleRadius))
                    path.addLine(to: CGPoint(x: centerPoint.x, y: centerPoint.y + outerCircleRadius))
                    path.move(to: CGPoint(x: centerPoint.x - outerCircleRadius, y: centerPoint.y))
                    path.addLine(to: CGPoint(x: centerPoint.x + outerCircleRadius, y: centerPoint.y))
                }
                .stroke(style: StrokeStyle(lineWidth: 2))
                
                // Draw the sector
                Sector(center: centerPoint, endPoint: CGPoint(x: centerPoint.x + cos(CGFloat(direction) * .pi / 180) * CGFloat(speed), y: centerPoint.y + sin(CGFloat(direction) * .pi / 180) * CGFloat(speed)), startAngle: CGFloat(direction - 5), endAngle: CGFloat(direction + 5))
                    .fill(LinearGradient(gradient: Gradient(colors: [Color.green, Color.yellow, Color.red]), startPoint: .leading, endPoint: .trailing))
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let vector = CGVector(dx: value.location.x - centerPoint.x, dy: value.location.y - centerPoint.y)
                        let angle = atan2(vector.dy, vector.dx)
                        direction = Double(angle * 180 / .pi)
                        speed = Double(sqrt(pow(vector.dx, 2) + pow(vector.dy, 2)) / outerCircleRadius) * 100
                    }
            )
        }
    }
}

struct Sector: Shape {
    var center: CGPoint
    var endPoint: CGPoint
    var startAngle: CGFloat
    var endAngle: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: center)
        path.addArc(center: center, radius: sqrt(pow(endPoint.x - center.x, 2) + pow(endPoint.y - center.y, 2)), startAngle: .degrees(Double(startAngle)), endAngle: .degrees(Double(endAngle)), clockwise: false)
        path.closeSubpath()
        return path
    }
}
