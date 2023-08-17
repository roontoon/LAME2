import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager
    @Published var userLatitude: Double = 0.0
    @Published var userLongitude: Double = 0.0
//
    override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            userLatitude = location.coordinate.latitude
            userLongitude = location.coordinate.longitude
            
            //print("Updated Latitude: \(userLatitude)")
            //print("Updated Longitude: \(userLongitude)")
        }
    }
}
