//
//  Location.swift
//  Rocketry
//
//  Created by Dylan Hawley on 7/10/24.
//

import CoreLocation

/// A location on Earth.
struct Location: Codable {
    /// A string that describes the location.
    var name: String

    /// The longitude of the location, given in degrees between -180 and 180.
    var longitude: Double

    /// The latitude of the location, given in degrees between -90 and 90.
    var latitude: Double

    /// The longitude and latitude collected into a location coordinate.
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

/// A string represenation of the location.
extension Location: CustomStringConvertible {
    /// A string represenation of the location coordinate.
    var description: String {
        "["
        + longitude.formatted(.number.precision(.fractionLength(1)))
        + ", "
        + latitude.formatted(.number.precision(.fractionLength(1)))
        + "] "
        + name
    }
}
