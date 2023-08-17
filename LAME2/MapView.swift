import SwiftUI
import MapKit
//
struct MapView: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    @Binding var waypoints: [TrainingView.CustomPointAnnotation]
    @Binding var polyline: MKPolyline?

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.setRegion(region, animated: true)
        uiView.removeAnnotations(uiView.annotations)
        uiView.addAnnotations(waypoints)
        uiView.removeOverlays(uiView.overlays)
        if let polyline = polyline {
            uiView.addOverlay(polyline)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let view = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
            view.frame = CGRect(x: 0, y: 0, width: 5, height: 5)
            view.layer.cornerRadius = 2.5
            view.backgroundColor = .blue
            return view
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polylineOverlay = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polylineOverlay)
                renderer.strokeColor = .blue
                renderer.lineWidth = 3
                return renderer
            }
            return MKOverlayRenderer()
        }
    }
}
