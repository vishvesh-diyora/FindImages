
import Foundation
import ObjectMapper

struct Src : Mappable {
	var original : String?
	var large2x : String?
	var large : String?
	var medium : String?
	var small : String?
	var portrait : String?
	var landscape : String?
	var tiny : String?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		original <- map["original"]
		large2x <- map["large2x"]
		large <- map["large"]
		medium <- map["medium"]
		small <- map["small"]
		portrait <- map["portrait"]
		landscape <- map["landscape"]
		tiny <- map["tiny"]
	}

}
