//
//  Model.swift
//  IndependenceDay
//
//  Created by Alena Belenets on 21.09.2023.
//

import Foundation

enum Airplanes: String {
    case airplane1 = "airplane1"
    case airplane2 = "airplane2"
    case airplane3 = "airplane3"

}
struct GameModel {
    var name: String
    let airplane: String
    var duration: Double
    var score: Int
    var record: Int
    let leftButton: String
    let rightButton: String
    let telescopicSign: String
    let bullet: String
    let enemy: String
    let fontNamed: String
    let keyForAirplane: String
    let keyForDuration: String
    let nameOsBulletSong: String
    let nameOfSky: String
    let nameOfAttack: String
    let done: String

    static func getGameModel() -> GameModel {
        GameModel(name: "Player", airplane: Airplanes.airplane1.rawValue, duration: 1, score: 0, record: 0, leftButton: "left", rightButton: "right", telescopicSign: "telescopicSign", bullet: "bullet", enemy: "enemy", fontNamed: "The Bold Font", keyForAirplane: "AirplaineKey", keyForDuration: "DurationKey", nameOsBulletSong: "bulletSound.mp3", nameOfSky: "sky", nameOfAttack: "boom", done: "done")

    }
}
