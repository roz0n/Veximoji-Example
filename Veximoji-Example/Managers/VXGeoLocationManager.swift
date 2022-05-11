//
//  VXGeoLocationManager.swift
//  Veximoji Example
//
//  Created by Arnaldo Rozon on 5/23/21.
//

import Foundation

protocol VXGeoLocationManagerDelegate {
  func decodeSuccess(coords: [VXGeoLocationData])
  func decodeError(error: Error?, message: String?)
}

class VXGeoLocationManager {
  
  // MARK: -
  
  lazy var decoder = JSONDecoder()
  var delegate: VXGeoLocationManagerDelegate?
  
  // MARK: -
  
  public func decodeIsoCodeLocations() {
    guard let url = Bundle.main.url(forResource: "iso-geolocation-data", withExtension: "json") else {
      fatalError("Error unable to locate locations.json")
    }
    
    guard let data = try? Data(contentsOf: url) else {
      delegate?.decodeError(error: nil, message: "Error decoding locations.json")
      return
    }
    
    do {
      let decodedData = try self.decoder.decode([VXGeoLocationData].self, from: data)
      delegate?.decodeSuccess(coords: decodedData)
    } catch let err {
      delegate?.decodeError(error: err, message: "Error decoding locations.json")
    }
  }
  
}
