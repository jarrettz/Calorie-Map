
import UIKit
import MapKit
import FloatingPanel
import CoreLocation

class ViewController: UIViewController {
  
    // Michael: - Properties
    
    var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var searchInputView: SearchInputView!
    
//    let searchVC = UISearchController(searchResultsController: ResultsViewController())

    // Michael: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewComponents()
        enableLocationServices()
        title = "Calorie Map"
//        view.addSubview(mapView)
//        searchVC.searchBar.backgroundColor = .secondarySystemBackground
//        searchVC.searchResultsUpdater = self
//        navigationItem.searchController = searchVC
//
//        let panel = FloatingPanelController()
//        panel.set(contentViewController: SearchViewController())
//        panel.addPanel(toParent: self)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        centerMapOnUserLocation(shouldLoadAnnotations: true)
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
        
        searchInputView = SearchInputView()
        
//        searchInputView.delegate = self
//        searchInputView.ViewController = self
        
        view.addSubview(searchInputView)
        searchInputView.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: -(view.frame.height - 300), paddingRight: 0, width: 0, height: view.frame.height)
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

// Michael: - MapKit Helper Functions

extension ViewController {
    
//    func zoomToFit(selectedAnnotation: MKAnnotation?) {
//        if mapView.annotations.count == 0 {
//            return
//        }
//
//        var topLeftCoordinate = CLLocationCoordinate2D(latitude: -90, longitude: 180)
//        var bottomRightCoordinate = CLLocationCoordinate2D(latitude: 90, longitude: -180)
//
//        if let selectedAnnotation = selectedAnnotation {
//            for annotation in mapView.annotations {
//                if let userAnno = annotation as? MKUserLocation {
//                    topLeftCoordinate.longitude = fmin(topLeftCoordinate.longitude, userAnno.coordinate.longitude)
//                    topLeftCoordinate.latitude = fmax(topLeftCoordinate.latitude, userAnno.coordinate.latitude)
//                    bottomRightCoordinate.longitude = fmax(bottomRightCoordinate.longitude, userAnno.coordinate.longitude)
//                    bottomRightCoordinate.latitude = fmin(bottomRightCoordinate.latitude, userAnno.coordinate.latitude)
//                }
//
//                if annotation.title == selectedAnnotation.title {
//                    topLeftCoordinate.longitude = fmin(topLeftCoordinate.longitude, annotation.coordinate.longitude)
//                    topLeftCoordinate.latitude = fmax(topLeftCoordinate.latitude, annotation.coordinate.latitude)
//                    bottomRightCoordinate.longitude = fmax(bottomRightCoordinate.longitude, annotation.coordinate.longitude)
//                    bottomRightCoordinate.latitude = fmin(bottomRightCoordinate.latitude, annotation.coordinate.latitude)
//                }
//            }
//
//            var region = MKCoordinateRegion(center: CLLocationCoordinate2DMake(topLeftCoordinate.latitude - (topLeftCoordinate.latitude - bottomRightCoordinate.latitude) * 0.65, topLeftCoordinate.longitude + (bottomRightCoordinate.longitude - topLeftCoordinate.longitude) * 0.65), span: MKCoordinateSpan(latitudeDelta: fabs(topLeftCoordinate.latitude - bottomRightCoordinate.latitude) * 3.0, longitudeDelta: fabs(bottomRightCoordinate.longitude - topLeftCoordinate.longitude) * 3.0))
//
//            region = mapView.regionThatFits(region)
//            mapView.setRegion(region, animated: true)
//        }

    
    func centerMapOnUserLocation(shouldLoadAnnotations: Bool) {
        guard let coordinates = locationManager.location?.coordinate else { return }
        let coordinateRegion = MKCoordinateRegion(center: coordinates, latitudinalMeters: 20000, longitudinalMeters: 20000)
        mapView.setRegion(coordinateRegion, animated: true)
        
//        if shouldLoadAnnotations {
//            loadAnnotations(withSearchQuery: "Coffee Shops")
//        }
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
            
            DispatchQueue.main.async {
                let controller = LocationRequestController()
                controller.locationManager = self.locationManager
                self.present(controller, animated: true, completion: nil)
            }
            
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
