
import UIKit
import MapKit

class ViewController: UIViewController {
    
    let mapView = MKMapView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Calorie Map"
        view.addSubview(mapView)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = view.bounds
        let annotation = MKPointAnnotation()
        let annotationTwo = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 37.77, longitude: -122.43)
        annotationTwo.coordinate = CLLocationCoordinate2D(latitude: 38.77, longitude: -122.43)
        mapView.addAnnotation(annotation)
        mapView.addAnnotation(annotationTwo)
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 500000, longitudinalMeters: 500000)
        mapView.setRegion(region, animated: true)
    }
    

}

