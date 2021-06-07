//
//  LocationDataManager.swift
//  Veximoji Example
//
//  Created by Arnaldo Rozon on 5/23/21.
//

import Foundation

class LocationDataManager {
  
  var decoder = JSONDecoder()
  
  func decode() -> [LocationCoords]? {
    guard let url = Bundle.main.url(forResource: "locations", withExtension: "json") else {
      fatalError("Error unable to locate locations.json")
    }
    
    guard let data = try? Data(contentsOf: url) else {
      fatalError("Failed to load locations.json file from bundle")
    }
    
    do {
      let data = try decoder.decode([LocationCoords].self, from: data)
      return data
    } catch {
      fatalError("Error decoding locations.json")
    }
  }
  
}
