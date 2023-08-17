import SwiftUI

@main
struct LAME2App: App {
    @StateObject var locationManager = LocationManager()
    @StateObject private var robotManager = RobotManager()
    @StateObject private var preference = Preference()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(robotManager)
                .environmentObject(preference)
                .environmentObject(locationManager)
        }
    }
}
