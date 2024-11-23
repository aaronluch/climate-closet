import CoreLocation
import SwiftUI

// This class handles location services and is observable by SwiftUI views.
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    // CLLocationManager is the object that provides location services.
    private let manager = CLLocationManager()
    
    @Published var location: CLLocationCoordinate2D?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        // Check if location services are enabled
        if CLLocationManager.locationServicesEnabled() {
            manager.requestWhenInUseAuthorization()  // Request authorization to use location
            manager.startUpdatingLocation()  // Start fetching location updates
        } else {
            print("Location services are not enabled")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.location = location.coordinate
            manager.stopUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("Location access denied")
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        default:
            break
        }
    }

}
