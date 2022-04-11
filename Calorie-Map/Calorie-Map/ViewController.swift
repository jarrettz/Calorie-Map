
import UIKit
import MapKit

class ViewController: UIViewController, UISearchResultsUpdating {
  
    
    
    let mapView = MKMapView()
    
    let searchVC = UISearchController(searchResultsController: ResultsViewController())

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Calorie Map"
        view.addSubview(mapView)
        searchVC.searchBar.backgroundColor = .secondarySystemBackground
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.frame.size.width, height: view.frame.size.height - view.safeAreaInsets.top)
        let annotation = MKPointAnnotation()
        let annotationTwo = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 37.77, longitude: -122.43)
        annotationTwo.coordinate = CLLocationCoordinate2D(latitude: 38.77, longitude: -122.43)
        mapView.addAnnotation(annotation)
        mapView.addAnnotation(annotationTwo)
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 500000, longitudinalMeters: 500000)
        mapView.setRegion(region, animated: true)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    

}

// TO DO
/*
 Link location 1 to search box 1
 Link location 2 to search box 2
 */
