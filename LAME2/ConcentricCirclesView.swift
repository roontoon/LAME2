import SwiftUI

struct ConcentricCirclesView: View {
    // State variables to hold the position of the black circle, speed, and direction
    @State private var blackCirclePosition: CGPoint? = nil
    @State private var speed: Double = 0
    @State private var direction: Double = 0
    
    // Constants for the radius of the outer and inner circles
    private let outerCircleRadius: CGFloat = UIScreen.main.bounds.width * 2/3 / 2
    private var innerCircleRadius: CGFloat { outerCircleRadius * 0.25 }
    
    var body: some View {
        // Diameter of the black circle
        let blackCircleDiameter: CGFloat = innerCircleRadius * 2

        // GeometryReader to get the dimensions of the parent view
        GeometryReader { geometry in
            // Center point of the parent view
            let centerPoint = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)

            // ZStack to overlay multiple shapes and text
            ZStack {
                // VStack for displaying speed and direction
                VStack {
                    Text("Speed: \(speed, specifier: "%.2f")")
                        .font(.title)
                    Text("Direction: \(direction, specifier: "%.2f")°")
                        .font(.title)
                }
                // Position the VStack
                .position(x: geometry.size.width / 2, y: geometry.size.height / 4)
                
                // ZStack for drawing circles and handling gestures
                ZStack {
                    // Outer circle
                    Circle()
                        .stroke(lineWidth: 2)
                        .frame(width: outerCircleRadius * 2, height: outerCircleRadius * 2)

                    // Inner circle
                    Circle()
                        .stroke(lineWidth: 2)
                        .frame(width: innerCircleRadius * 2, height: innerCircleRadius * 2)

                    // Custom shape for the gradient
                    if let blackCirclePosition = blackCirclePosition { // Safely unwrap optional
                        Sector(center: centerPoint, endPoint: blackCirclePosition, startAngle: CGFloat(direction - 45), endAngle: CGFloat(direction + 45))
                            .fill(RadialGradient(gradient: Gradient(colors: [Color.green, Color.red]), center: .center, startRadius: innerCircleRadius, endRadius: sqrt(pow(blackCirclePosition.x - centerPoint.x, 2) + pow(blackCirclePosition.y - centerPoint.y, 2))))
                    }
                    
                    // Black circle
                    Circle()
                        .fill()
                        .frame(width: blackCircleDiameter, height: blackCircleDiameter)
                        .position(blackCirclePosition ?? centerPoint) // Use the center as the default position
                }
                // Gesture handling for the black circle
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            // Calculate the new position, speed, and direction
                            let delta = CGPoint(x: value.location.x - centerPoint.x, y: value.location.y - centerPoint.y)
                            let distance = sqrt(pow(delta.x, 2) + pow(delta.y, 2))
                            let angle = atan2(delta.y, delta.x)

                            // Bound the position within the outer circle
                            if distance > outerCircleRadius {
                                let boundedX = cos(angle) * outerCircleRadius + centerPoint.x
                                let boundedY = sin(angle) * outerCircleRadius + centerPoint.y
                                blackCirclePosition = CGPoint(x: boundedX, y: boundedY)
                            } else {
                                blackCirclePosition = value.location
                            }

                            // Update speed and direction
                            speed = min(Double(distance / outerCircleRadius) * 100, 100)
                            direction = Double(angle) * 180 / Double.pi
                            if direction < 0 {
                                direction += 360
                            }
                        }
                        .onEnded { _ in
                            // Reset to initial state when the gesture ends
                            blackCirclePosition = centerPoint
                            speed = 0
                            direction = 0
                        }
                )
                // Initialize the black circle's position
                .onAppear {
                    blackCirclePosition = centerPoint
                }
            }
        }
    }
}

// Custom shape for drawing the sector with gradient
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

// Preview
struct ConcentricCirclesView_Previews: PreviewProvider {
    static var previews: some View {
        ConcentricCirclesView()
    }
}
