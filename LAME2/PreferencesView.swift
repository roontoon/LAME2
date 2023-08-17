import SwiftUI
//
struct PreferencesView: View {
    @EnvironmentObject var locationManager: LocationManager
    @ObservedObject var preference: Preference

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Button(action: {
                        // Assuming you want to update the userLatitude and userLongitude here
                        preference.userLatitude = locationManager.userLatitude
                        preference.userLongitude = locationManager.userLongitude
                    }) {
                        Text("Get Current GPS")
                    }

                    HStack {
                        Text("Latitude")
                        Spacer()
                        Text("\(preference.userLatitude, specifier: "%.7f")")
                    }

                    HStack {
                        Text("Longitude")
                        Spacer()
                        Text("\(preference.userLongitude, specifier: "%.7f")")
                    }

                    HStack {
                        Text("Cutting Width")
                        Spacer()
                        Slider(value: Binding(
                            get: { Double(self.preference.cuttingWidth) },
                            set: { self.preference.cuttingWidth = Int($0) }),
                               in: 0.5...30,
                               step: 0.5)
                        Text("\(preference.cuttingWidth) cm")
                    }

                    HStack {
                        Text("Lane Overlap")
                        Spacer()
                        Slider(value: Binding(
                            get: { Double(self.preference.laneOverlap) },
                            set: { self.preference.laneOverlap = Int($0) }),
                               in: 0...100,
                               step: 1)
                        Text("\(preference.laneOverlap)%")
                    }
                }
            }
            .navigationTitle("Preferences")
        }
    }
}
