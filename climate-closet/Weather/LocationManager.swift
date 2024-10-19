

import CoreLocation
import SwiftUI

// This class handles location services and is observable by SwiftUI views.
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    // CLLocationManager is the object that provides location services.
    private let manager = CLLocationManager()
    
    // @Published allows this property to update SwiftUI views automatically when the value changes.
    @Published var location: CLLocationCoordinate2D?

    // This initializer sets up the CLLocationManager and requests permission to use the location.
    override init() {
        super.init()
        manager.delegate = self
        // Check if location services are enabled
        if CLLocationManager.locationServicesEnabled() {
            manager.requestWhenInUseAuthorization()  // Request authorization to use location
            manager.startUpdatingLocation()  // Start fetching location updates
        } else {
            print("Location services are not enabled")
        }
    }


    // This delegate method is called whenever the CLLocationManager receives location updates.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Check if we have a valid location, and update the location property with the first location from the array.
        if let location = locations.first {
            self.location = location.coordinate  // Update the published location property.
            manager.stopUpdatingLocation()  // Stop fetching location to save battery once the location is retrieved.
        }
    }

    // This method handles errors if the location manager fails to get the location.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Print the error message for debugging purposes.
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
