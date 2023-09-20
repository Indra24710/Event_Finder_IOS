import Foundation

struct VenueAPIModel: Codable {
    let name, type, id: String
    let url: String
    let address: Address
    let location: Location
    let boxOfficeInfo: BoxOfficeInfo?
    let generalInfo: GeneralInfo?


    enum CodingKeys: String, CodingKey {
        case name, type, id, url, address, location
        case boxOfficeInfo = "boxOfficeInfo"
        case generalInfo = "generalInfo"
    }
}

struct Address: Codable {
    let line1: String
}




struct GeneralInfo: Codable {
    let generalRule, childRule: String?
}

struct BoxOfficeInfo: Codable {
    let phoneNumberDetail, openHoursDetail, willCallDetail: String?
}


struct Location: Codable {
    let longitude, latitude: String
}

