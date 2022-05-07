//
//  ImagesViewModel.swift
//  FindImages
//
//  Created by admin on 07/05/22.
//

import Foundation
import Alamofire
import ObjectMapper

var apikeyError = false

class ImagesViewModel {
    static var shared = ImagesViewModel()
    
    func getImagesApiCall(page: Int,search: String,completion: @escaping (ImagesResponse?) -> Void) {
        let params = [APIKey.page: page,APIKey.query: search] as [String : Any]
        let headers = [APIKey.authorization: apikeyError ? APIManager.apiKey1 : APIManager.apiKey2] as HTTPHeaders
        AF.request(APIManager.search, method: .get, parameters: params, headers: headers).responseString(completionHandler: { result in
            if result.error == nil {
                print(result.value ?? "")
                let resObj = Mapper<ImagesResponse>().map(JSONString: result.value ?? "")
                completion(resObj)
            } else {
                apikeyError = !apikeyError
            }
        })
    }
}
