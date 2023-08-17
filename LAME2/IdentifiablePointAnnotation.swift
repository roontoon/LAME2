
import Foundation
import MapKit

class IdentifiablePointAnnotation: NSObject, MKAnnotation, Identifiable {
    let id: Int
    let coordinate: CLLocationCoordinate2D

    init(id: Int, coordinate: CLLocationCoordinate2D) {
        self.id = id
        self.coordinate = coordinate
    }
}
