import SwiftUI
import MapKit
//
struct MapOverlay: UIViewRepresentable {
    @Binding var polyline: MKPolyline?

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeOverlays(uiView.overlays)
        if let polyline = polyline {
            uiView.addOverlay(polyline)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapOverlay

        init(_ parent: MapOverlay) {
            self.parent = parent
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
