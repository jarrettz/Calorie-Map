
import UIKit
import MapKit
import FloatingPanel
import CoreLocation

class ViewController: UIViewController {
  
    // Michael: - Properties
    
    var mapView: MKMapView!
    var locationManager: CLLocationManager!
    
//    let searchVC = UISearchController(searchResultsController: ResultsViewController())

    // Michael: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewComponents()
        enableLocationServices()
//        title = "Calorie Map"
//        view.addSubview(mapView)
//        searchVC.searchBar.backgroundColor = .secondarySystemBackground
//        searchVC.searchResultsUpdater = self
//        navigationItem.searchController = searchVC
//
//        let panel = FloatingPanelController()
//        panel.set(contentViewController: SearchViewController())
//        panel.addPanel(toParent: self)

    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        mapView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.frame.size.width, height: view.frame.size.height - view.safeAreaInsets.top)
//        let annotation = MKPointAnnotation()
//        let annotationTwo = MKPointAnnotation()
//        annotation.coordinate = CLLocationCoordinate2D(latitude: 37.77, longitude: -122.43)
//        annotationTwo.coordinate = CLLocationCoordinate2D(latitude: 38.77, longitude: -122.43)
//        mapView.addAnnotation(annotation)
//        mapView.addAnnotation(annotationTwo)
//        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 500000, longitudinalMeters: 500000)
//        mapView.setRegion(region, animated: true)
//    }
    
    // Michael: - Helper Functions
    
    func configureViewComponents() {
        view.backgroundColor = .white
        configureMapView()
    }
    
    func configureMapView() {
        mapView = MKMapView()
        mapView.showsUserLocation = true
//        mapView.delegate = self
        mapView.userTrackingMode = .follow
//
        view.addSubview(mapView)
        mapView.addConstraintsToFillView(view: view)
    }
}
// Michael: - CLLocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {
    
    func enableLocationServices() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            print("Location auth status is NOT DETERMINED")
            
//            DispatchQueue.main.async {
//                let controller = LocationRequestController()
//                controller.locationManager = self.locationManager
//                self.present(controller, animated: true, completion: nil)
//            }
            
        case .restricted:
            print("Location auth status is RESTRICTED")
        case .denied:
            print("Location auth status is DENIED")
        case .authorizedAlways:
            print("Location auth status is AUTHORIZED ALWAYS")
        case .authorizedWhenInUse:
            print("Location auth status is AUTHORIZED WHEN IN USE")
        }
    }
}


// TO DO
/*
 Link location 1 to search box 1
 Link location 2 to search box 2
 */
