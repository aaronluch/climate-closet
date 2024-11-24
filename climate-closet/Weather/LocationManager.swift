import CoreLocation
import SwiftUI

// Manages location updates and handles user authorization for location services
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let manager = CLLocationManager()
    @Published var location: CLLocationCoordinate2D?
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var isLocationDenied = false // Track if the user denied location access

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.locationServicesEnabled() {
            // Request permission to use location
            manager.requestWhenInUseAuthorization()
        } else {
            print("Location services are not enabled.")
        }
    }

    // update authorized status and track
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        self.authorizationStatus = status
        
        switch status {
        case .notDetermined:
            print("Authorization not determined. Requesting access.")
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("Location access denied or restricted.")
            isLocationDenied = true
        case .authorizedWhenInUse, .authorizedAlways:
            print("Location authorized. Starting location updates.")
            startUpdatingLocation()
        @unknown default:
            print("Unknown authorization status.")
        }
    }

    // updates user's location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location.coordinate
        print("Location updated: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        manager.stopUpdatingLocation() // Stop updates after getting the location
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }

    private func startUpdatingLocation() {
        DispatchQueue.main.async {
            self.manager.startUpdatingLocation()
        }
    }
}
