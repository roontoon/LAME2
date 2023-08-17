import SwiftUI
import MapKit
//
struct TrainingView: View {
    @StateObject var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.00001, longitudeDelta: 0.00001)
    )
    @State private var waypoints: [CustomPointAnnotation] = []
    @State private var polyline: MKPolyline?
    @State private var shouldRecenter = false

    class CustomPointAnnotation: NSObject, MKAnnotation {
        let id: Int
        @objc dynamic var coordinate: CLLocationCoordinate2D

        init(id: Int, coordinate: CLLocationCoordinate2D) {
            self.id = id
            self.coordinate = coordinate
        }
    }

    var body: some View {
        VStack {
            MapView(region: $region, waypoints: $waypoints, polyline: $polyline)
                .edgesIgnoringSafeArea(.all)
                .onChange(of: shouldRecenter) { newValue in
                    if newValue {
                        updateCenter()
                        shouldRecenter = false // Reset after re-centering
                    }
                }
            HStack {
                Button(action: zoomIn) {
                    Image(systemName: "plus.magnifyingglass")
                }
                Button(action: zoomOut) {
                    Image(systemName: "minus.magnifyingglass")
                }
                Button(action: recenterMap) {
                    Image(systemName: "location.circle")
                }
                Button(action: addWaypoint) {
                    Image(systemName: "plus")
                }
            }
            .font(.largeTitle)
            .padding()
        }
        .onAppear {
            updateCenter()
        }
    }

  /*  private func addWaypoint() {
        if let location = locationManager.lastLocation {
            let id = waypoints.count + 1
            let newWaypoint = CustomPointAnnotation(id: id, coordinate: location.coordinate)
            waypoints.append(newWaypoint)
            updatePolyline()
            print("Adding waypoint at latitude: \(location.coordinate.latitude), longitude: \(location.coordinate.longitude)")
        } else {
            print("Failed to retrieve location for waypoint")
        }
    }*/
    private func addWaypoint() {
        let id = waypoints.count + 1
        let newWaypoint = CustomPointAnnotation(id: id, coordinate: CLLocationCoordinate2D(latitude: locationManager.userLatitude, longitude: locationManager.userLongitude))
        waypoints.append(newWaypoint)
        updatePolyline()
        print("Adding waypoint at latitude: \(locationManager.userLatitude), longitude: \(locationManager.userLongitude)")
    }
    private func zoomIn() {
        region.span.latitudeDelta /= 2.0
        region.span.longitudeDelta /= 2.0
    }

    private func zoomOut() {
        region.span.latitudeDelta *= 2.0
        region.span.longitudeDelta *= 2.0
    }

    private func recenterMap() {
        shouldRecenter.toggle()
    }

    private func updateCenter() {
        region.center.latitude = locationManager.userLatitude
        region.center.longitude = locationManager.userLongitude
    }

    private func updatePolyline() {
        let coordinates = waypoints.map { $0.coordinate }
        polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
    }
}
