//
//  Preferences.swift
//  LAME2
//
//  Created by Roontoon on 7/26/23.
//
//
import Foundation
import Combine

class Preference: ObservableObject {
    @Published var userLongitude: Double {
        didSet {
            UserDefaults.standard.set(userLongitude, forKey: "userLongitude")
        }
    }
    @Published var userLatitude: Double {
        didSet {
            UserDefaults.standard.set(userLatitude, forKey: "userLatitude")
        }
    }
    @Published var cuttingWidth: Int {
        didSet {
            UserDefaults.standard.set(cuttingWidth, forKey: "cuttingWidth")
        }
    }
    @Published var laneOverlap: Int {
        didSet {
            UserDefaults.standard.set(laneOverlap, forKey: "laneOverlap")
        }
    }

    init() {
        self.userLongitude = UserDefaults.standard.double(forKey: "userLongitude")
        self.userLatitude = UserDefaults.standard.double(forKey: "userLatitude")
        self.cuttingWidth = UserDefaults.standard.integer(forKey: "cuttingWidth")
        self.laneOverlap = UserDefaults.standard.integer(forKey: "laneOverlap")
    }
}
