
import UIKit
import MapKit
import FloatingPanel
import CoreLocation

class ViewController: UIViewController {
  
    // Michael: - Properties
    
    var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var searchInputView: SearchInputView!

    let centerMapButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "location-arrow-flat").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCenterLocation), for: .touchUpInside)
        return button
    }()
    
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
    
    // Michael: - Selectors
    
    @objc func handleCenterLocation() {
        centerMapOnUserLocation(shouldLoadAnnotations: false)
    }
    
    // Michael: - Helper Functions
    
    func configureViewComponents() {
        view.backgroundColor = .white
        configureMapView()
        
        searchInputView = SearchInputView()
        
        searchInputView.delegate = self
        searchInputView.ViewController = self
        
        view.addSubview(searchInputView)
        searchInputView.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: -(view.frame.height - 88), paddingRight: 0, width: 0, height: view.frame.height)
        
        view.addSubview(centerMapButton)
        centerMapButton.anchor(top: nil, left: nil, bottom: searchInputView.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 16, paddingRight: 16, width: 50, height: 50)

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

// Michael: - SearchCellDelegate

extension ViewController: SearchCellDelegate {
    
    func getDirections(forMapItem mapItem: MKMapItem) {
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking])
    }
    
    func distanceFromUser(location: CLLocation) -> CLLocationDistance? {
        guard let userLocation = locationManager.location else { return nil }
        return userLocation.distance(from: location)
    }
}

// Michael: - SearchInputViewDelegate

extension ViewController: SearchInputViewDelegate {
    
    func searchBy(naturalLanguageQuery: String, region: MKCoordinateRegion, coordinates: CLLocationCoordinate2D, completion: @escaping (_ response: MKLocalSearch.Response?, _ error: NSError?) -> ()) {
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = naturalLanguageQuery
        request.region = region
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            
            guard let response = response else {
                completion(nil, error! as NSError)
                return
            }
        
            completion(response, nil)
        }
    }

    func handleSearch(withSearchText searchText: String) {
        removeAnnotations()
        
        loadAnnotations(withSearchQuery: searchText)
      
    }
    
    
    func animateCenterMapButton(expansionState: SearchInputView.ExpansionState, hideButton: Bool) {
        switch expansionState {
        case .NotExpanded:
            UIView.animate(withDuration: 0.25) {
                self.centerMapButton.frame.origin.y -= 250
            }

            if hideButton {
                self.centerMapButton.alpha = 0
            } else {
                self.centerMapButton.alpha = 1
            }

        case .PartiallyExpanded:
            
            if hideButton {
                self.centerMapButton.alpha = 0
            } else {
                UIView.animate(withDuration: 0.25) {
                    self.centerMapButton.frame.origin.y += 250
                }
            }

        case .FullyExpanded:
            if !hideButton {
                UIView.animate(withDuration: 0.25) {
                    self.centerMapButton.alpha = 1
                }
            }
        }
}
}

// Michael: - MapKit Helper Functions

extension ViewController {
    
    func loadAnnotations(withSearchQuery query: String) {
        
        guard let coordinate = locationManager.location?.coordinate else { return }
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
        
        searchBy(naturalLanguageQuery: query, region: region, coordinates: coordinate) { (response, error) in
            
            guard let response = response else { return }
            
            response.mapItems.forEach({ (mapItem) in
                let annotation = MKPointAnnotation()
                annotation.title = mapItem.name
                annotation.coordinate = mapItem.placemark.coordinate
                self.mapView.addAnnotation(annotation)
            })
            
            self.searchInputView.searchResults = response.mapItems
        }
        
    }
    
    func centerMapOnUserLocation(shouldLoadAnnotations: Bool) {
        guard let coordinates = locationManager.location?.coordinate else { return }
        let coordinateRegion = MKCoordinateRegion(center: coordinates, latitudinalMeters: 2000, longitudinalMeters: 2000)
        mapView.setRegion(coordinateRegion, animated: true)
        
        if shouldLoadAnnotations {
            loadAnnotations(withSearchQuery: "Bar")
        }
    }
    
    func removeAnnotations() {
        mapView.annotations.forEach { (annotation) in
            if let annotation = annotation as? MKPointAnnotation {
                mapView.removeAnnotation(annotation)
            }
        }
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


