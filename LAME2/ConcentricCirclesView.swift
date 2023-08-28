// Test view for joystick control
import SwiftUI  // Import the SwiftUI framework

// Define a SwiftUI View struct named ConcentricCirclesView
struct ConcentricCirclesView: View {
    // Declare state variables for the black circle's position, speed, and direction
    @State private var blackCirclePosition: CGPoint? = nil
    @State private var speed: Double = 0
    @State private var direction: Double = 0
    
    // Declare constants for the outer and inner circle radii
    private let outerCircleRadius: CGFloat = UIScreen.main.bounds.width * 2/3 / 2
    private var innerCircleRadius: CGFloat { outerCircleRadius * 0.25 }

    // Define the body of the View
    var body: some View {
        // Calculate the diameter of the black circle
        let blackCircleDiameter: CGFloat = innerCircleRadius * 2

        // Use GeometryReader to get the dimensions of the parent view
        GeometryReader { geometry in
            // Calculate the center point of the parent view
            let centerPoint = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)

            // Create a ZStack to overlay multiple views
            ZStack {
                // Create a VStack to display speed and direction
                VStack {
                    Text("Speed: \(speed, specifier: "%.2f")")
                        .font(.title)
                    Text("Direction: \(direction, specifier: "%.2f")°")
                        .font(.title)
                }
                // Position the VStack at the top-center of the parent view
                .position(x: geometry.size.width / 2, y: geometry.size.height / 4)
                
                // Create another ZStack for the circles and lines
                ZStack {
                    // Draw the outer solid circle
                    Circle()
                        .stroke(lineWidth: 2)
                        .frame(width: outerCircleRadius * 2, height: outerCircleRadius * 2)

                    // Draw the inner solid circle
                    Circle()
                        .stroke(lineWidth: 2)
                        .frame(width: innerCircleRadius * 2, height: innerCircleRadius * 2)

                    // Draw the dashed circle
                    Circle()
                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                        .frame(width: (outerCircleRadius + innerCircleRadius), height: (outerCircleRadius + innerCircleRadius))

                    // Draw the black circle
                    Circle()
                        .fill()
                        .frame(width: blackCircleDiameter, height: blackCircleDiameter)
                        .position(blackCirclePosition ?? centerPoint)


                    Path { path in
                        // Vertical bisecting line for the outer circle
                        path.move(to: CGPoint(x: centerPoint.x, y: centerPoint.y - outerCircleRadius))
                        path.addLine(to: CGPoint(x: centerPoint.x, y: centerPoint.y - innerCircleRadius))
                        
                        path.move(to: CGPoint(x: centerPoint.x, y: centerPoint.y + innerCircleRadius))
                        path.addLine(to: CGPoint(x: centerPoint.x, y: centerPoint.y + outerCircleRadius))
                        
                        // Horizontal bisecting line for the outer circle
                        path.move(to: CGPoint(x: centerPoint.x - outerCircleRadius, y: centerPoint.y))
                        path.addLine(to: CGPoint(x: centerPoint.x - innerCircleRadius, y: centerPoint.y))
                        
                        path.move(to: CGPoint(x: centerPoint.x + innerCircleRadius, y: centerPoint.y))
                        path.addLine(to: CGPoint(x: centerPoint.x + outerCircleRadius, y: centerPoint.y))
                    }
                    .stroke(style: StrokeStyle(lineWidth: 2))


                }
                // Add drag gesture to the ZStack
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            // Calculate distance and angle from center
                            let delta = CGPoint(x: value.location.x - centerPoint.x, y: value.location.y - centerPoint.y)
                            let distance = sqrt(pow(delta.x, 2) + pow(delta.y, 2))
                            let angle = atan2(delta.y, delta.x)

                            // Set the black circle position
                            if distance > outerCircleRadius {
                                let boundedX = cos(angle) * outerCircleRadius + centerPoint.x
                                let boundedY = sin(angle) * outerCircleRadius + centerPoint.y
                                blackCirclePosition = CGPoint(x: boundedX, y: boundedY)
                            } else {
                                blackCirclePosition = value.location
                            }

                            // Calculate speed
                            speed = min(Double(distance / outerCircleRadius), 1.0)

                            // Calculate direction
                            direction = Double(angle) * 180 / Double.pi - 90 + 180
                            if direction < 0 {
                                direction += 360
                            } else if direction > 360 {
                                direction -= 360
                            }
                        }
                        .onEnded { _ in
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

// Preview the ConcentricCirclesView
struct ConcentricCirclesView_Previews: PreviewProvider {
    static var previews: some View {
        ConcentricCirclesView()
    }
}
