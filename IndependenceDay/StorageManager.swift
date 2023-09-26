//
//  StorageManager.swift
//  IndependenceDay
//
//  Created by Alena Belenets on 22.09.2023.
//

import Foundation


class StorageManager {

    static let shared = StorageManager()

    private let defaults = UserDefaults.standard
    private let gameKey = "gameKey"
    private let documentDirectory = FileManager.default
}
