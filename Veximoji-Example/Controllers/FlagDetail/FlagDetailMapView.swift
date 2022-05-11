//
//  FlagDetailMapView.swift
//  Veximoji-Example
//
//  Created by Arnaldo Rozon on 5/10/22.
//

import UIKit
import MapKit

class FlagDetailMapView: MKMapView {
  
  // MARK: -
  
  var locationMarker = MKPointAnnotation()
  
  // MARK: - Initializers
  
  init() {
    super.init(frame: .zero)
    
    translatesAutoresizingMaskIntoConstraints = false
    mapType = MKMapType.standard
    isZoomEnabled = true
    isScrollEnabled = true
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Configurations
  
  func configureMap(coords: VXGeoLocationData) {
    let coords = CLLocationCoordinate2D(latitude: coords.latitude, longitude: coords.longitude)
    let span = MKCoordinateSpan(latitudeDelta: 10.0, longitudeDelta: 10.0)
    let region = MKCoordinateRegion(center: coords, span: span)
    
    // Configure Map
    setRegion(region, animated: true)
    centerCoordinate = CLLocationCoordinate2D(latitude: coords.latitude, longitude: coords.longitude)
    
    // Configure Marker
    locationMarker.coordinate = coords
    addAnnotation(locationMarker)
  }
  
}
