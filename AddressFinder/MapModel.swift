//
//  MapModel.swift
//  AddressFinder
//
//  Created by 21SP-2 on 4/19/22.
//

import Foundation
import MapKit

struct Address: Codable {
    let data: [Datum]
}

struct Datum: Codable {
    let latitude, longitude: Double
    let name: String?
}

struct Location: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}
class MapAPI: ObservableObject {
    private let BASE_URL = "http://api.positionstack.com/v1/forward"
    private let API_KEY = "1db14edef6fc08627b92b95bf6252b7f"
    
    @Published var region: MKCoordinateRegion
    @Published var coordinates = []
    @Published var locations: [Location] = []
    
    init () {
        let lat = 51.50
        let lon = -0.1275
        
        self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lon), span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5) )
    }

    func getLocation(address: String, delta: Double) {
        locations.removeAll()
        let pAddress = address.replacingOccurrences(of: " ", with: "%20")
        let url_string = "\(BASE_URL)?access_key=\(API_KEY)&query=\(pAddress)&limit=5&output=json"
        guard let url = URL(string: url_string) else {
            print("Invalid URL")
            return
        }
        let sem = DispatchSemaphore.init(value:0)
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            
            guard let data = data else {
                print(error!.localizedDescription)
                return
            }
            guard let newCoordinates = try? JSONDecoder().decode(Address.self, from:data) else {return}
            if newCoordinates.data.isEmpty {
                print("Could not find the address...")
                return
            }
            print("Inside datatask")
            for data in newCoordinates.data {
                let details = data
                let lat = details.latitude
                let lon = details.longitude
                let name = details.name
                print(name!)
                self.coordinates = [lat, lon]
                self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lon), span: MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta))
                
                let new_location = Location(name: name ?? "Not found", coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
                self.locations.append(new_location)
            }
            sem.signal()
        }
        .resume()
        print("Locations were queried.")
        sem.wait()
    }
}
