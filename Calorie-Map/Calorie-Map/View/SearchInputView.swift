//
//  SearchInputView.swift
//  Calorie-Map
//
//  Created by Michael Tayamen Satumba Jr. on 4/13/22.
//

import UIKit
import MapKit

private let reuseIdentifier = "SearchCell"

//protocol SearchInputViewDelegate {
//    func animateCenterMapButton(expansionState: SearchInputView.ExpansionState, hideButton: Bool)
//    func handleSearch(withSearchText searchText: String)
//    func addPolyline(forDestinationMapItem destinationMapItem: MKMapItem)
//    func selectedAnnotation(withMapItem mapItem: MKMapItem)
//}

class SearchInputView: UIView, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SearchCell
        return cell
    }

    
    
    // Michael: - Properties
    
    var searchBar: UISearchBar!
    var tableView: UITableView!
    var expansionState: ExpansionState!
    
    enum ExpansionState {
        case NotExpanded
        case PartiallyExpanded
        case FullyExpanded
        case ExpandToSearch
    }

    let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 5
        view.alpha = 0.8
        return view
    }()

    // Michael: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViewComponents()
        
        expansionState = .NotExpanded
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Michael: - Selectors
    
    @objc func handleSwipeGesture(sender: UISwipeGestureRecognizer) {
        if sender.direction == .up {
            if expansionState == .NotExpanded {
//                delegate?.animateCenterMapButton(expansionState: self.expansionState, hideButton: false)
                
                animateInputView(targetPosition: self.frame.origin.y - 250) { (_) in
                    self.expansionState = .PartiallyExpanded
                }
            }
            
            if expansionState == .PartiallyExpanded {
//                delegate?.animateCenterMapButton(expansionState: self.expansionState, hideButton: true)
                
                animateInputView(targetPosition: self.frame.origin.y - 350) { (_) in
                    self.expansionState = .FullyExpanded
                }
            }
        } else {
         
            if expansionState == .FullyExpanded {
                self.searchBar.endEditing(true)
                self.searchBar.showsCancelButton = false
                
                animateInputView(targetPosition: self.frame.origin.y + 350) { (_) in
//                    self.delegate?.animateCenterMapButton(expansionState: self.expansionState, hideButton: false)
                    self.expansionState = .PartiallyExpanded
                    
                }
            }
            
            if expansionState == .PartiallyExpanded {
//                delegate?.animateCenterMapButton(expansionState: self.expansionState, hideButton: false)
                
                animateInputView(targetPosition: self.frame.origin.y + 250) { (_) in
                    self.expansionState = .NotExpanded
                }
            }
            
        }
    }

    // Michael: - Helper Functions
    

    func animateInputView(targetPosition: CGFloat, completion: @escaping(Bool) -> ()) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.frame.origin.y = targetPosition
        }, completion: completion)
    }
    
    func configureViewComponents() {
        backgroundColor = .white

        addSubview(indicatorView)
        indicatorView.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 40, height: 8)
        indicatorView.centerX(inView: self)

        configureSearchBar()
        configureTableView()
        configureGestureRecognizers()
    }
//
    func configureSearchBar() {
        searchBar = UISearchBar()
        searchBar.placeholder = "Where to?"
//        searchBar.delegate = self
        searchBar.barStyle = .black
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)

        addSubview(searchBar)
        searchBar.anchor(top: indicatorView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 50)
    }

    func configureTableView() {
        tableView = UITableView()
        tableView.rowHeight = 72
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(SearchCell.self, forCellReuseIdentifier: reuseIdentifier)

        addSubview(tableView)
        tableView.anchor(top: searchBar.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 100, paddingRight: 0, width: 0, height: 0)
    }
    
    func configureGestureRecognizers() {
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeUp.direction = .up
        addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeDown.direction = .down
        addGestureRecognizer(swipeDown)
    }




// Michael: - UITableViewDataSource/Delegate

}
