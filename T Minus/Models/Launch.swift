//
//  Launch.swift
//  T Minus
//
//  Created by Dylan Hawley on 7/4/24.
//

import SwiftUI
import SwiftData

@Model
class Launch {
    /// A unique identifier associated with each launch.
    @Attribute(.unique) var code: String

    var net: Date
    var vehicle: String
    var mission: String
    var details: String
    var orbit: String
    var pad: String
    var country_code: String
    var location: Location
    var timezone_name: String

    /// Creates a new launch from the specified values.
    init(
        code: String,
        net: Date,
        vehicle: String,
        mission: String,
        details: String,
        orbit: String,
        pad: String,
        country_code: String,
        longitude: Double,
        latitude: Double,
        timezone_name: String
    ) {
        self.code = code
        self.net = net
        self.vehicle = vehicle
        self.mission = mission
        self.details = details
        self.orbit = orbit
        self.pad = pad
        self.country_code = country_code
        self.location = Location(name: pad, longitude: longitude, latitude: latitude)
        self.timezone_name = timezone_name
    }
}

/// A convenience for accessing a launch in an array by its identifier.
extension Array where Element: Launch {
    // Gets the first launch in the array with the specified ID, if any.
    subscript(id: Launch.ID?) -> Launch? {
        first { $0.id == id }
    }
}

// A string represenation of the launch.
extension Launch: CustomStringConvertible {
    var description: String {
        "\(code) \(mission) \(vehicle) \(pad)"
    }
}

extension Launch {
    /// A filter that checks for text in the launch's location name.
    static func predicate(
        searchText: String,
        onlyFutureLaunches: Bool = false,
        onlyPastLaunches: Bool = false,
        onlyUSLaunches: Bool = true
    ) -> Predicate<Launch> {
        let currentDate = Date()
        
        return #Predicate<Launch> { launch in
            (searchText.isEmpty || launch.vehicle.localizedStandardContains(searchText) ||
             launch.details.localizedStandardContains(searchText) ||
             launch.mission.localizedStandardContains(searchText)) &&
            (!onlyFutureLaunches || launch.net > currentDate) &&
            (!onlyPastLaunches || launch.net < currentDate) &&
            (!onlyUSLaunches || launch.country_code == "USA")
        }
    }

    /// Report the range of dates over which there are launches.
    static func dateRange(modelContext: ModelContext) -> ClosedRange<Date> {
        let descriptor = FetchDescriptor<Launch>(sortBy: [.init(\.net, order: .forward)])
        guard let launches = try? modelContext.fetch(descriptor),
              let first = launches.first?.net,
              let last = launches.last?.net else { return .distantPast ... .distantFuture }
        return first ... last
    }

    /// Reports the total number of launches.
    static func totalLaunches(modelContext: ModelContext) -> Int {
        (try? modelContext.fetchCount(FetchDescriptor<Launch>())) ?? 0
    }
}

/// Ensure that the model's conformance to Identifiable is public.
extension Launch: Identifiable {}
