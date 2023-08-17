import SwiftUI

struct ContentView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var robotManager: RobotManager
    @EnvironmentObject var preference: Preference // Use environment object
//
    var body: some View {
        TabView {
            ControlView()
                .tabItem {
                    Label("Control", systemImage: "gamecontroller")
                }
                .tag(1)
            TrainingView() // No need to pass preference here
                .tabItem {
                    Label("Training", systemImage: "person.2.square.stack")
                }
                .tag(2)
            PreferencesView(preference: preference) // pass it here
                .tabItem {
                    Label("Preferences", systemImage: "gear")
                }
                .tag(3)
            ConcentricCirclesView()
                .tabItem {
                    Label("Circles", systemImage: "circle.circle")
                }
                .tag(4)
        }
        .environmentObject(robotManager)
        .environmentObject(locationManager)
    }
}
