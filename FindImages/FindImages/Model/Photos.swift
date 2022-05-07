
import Foundation
import ObjectMapper

struct Photos : Mappable {
	var id : Int?
	var width : Int?
	var height : Int?
	var url : String?
	var photographer : String?
	var photographer_url : String?
	var photographer_id : Int?
	var avg_color : String?
	var src : Src?
	var liked : Bool?
	var alt : String?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		id <- map["id"]
		width <- map["width"]
		height <- map["height"]
		url <- map["url"]
		photographer <- map["photographer"]
		photographer_url <- map["photographer_url"]
		photographer_id <- map["photographer_id"]
		avg_color <- map["avg_color"]
		src <- map["src"]
		liked <- map["liked"]
		alt <- map["alt"]
	}

}
