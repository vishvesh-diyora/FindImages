import Foundation
import ObjectMapper

struct ImagesResponse : Mappable {
	var page : Int?
	var per_page : Int?
	var photos : [Photos]?
	var total_results : Int?
	var next_page : String?
	var prev_page : String?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		page <- map["page"]
		per_page <- map["per_page"]
		photos <- map["photos"]
		total_results <- map["total_results"]
		next_page <- map["next_page"]
		prev_page <- map["prev_page"]
	}

}
