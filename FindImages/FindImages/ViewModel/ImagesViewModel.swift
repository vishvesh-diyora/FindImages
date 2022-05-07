//
//  ImagesViewModel.swift
//  FindImages
//
//  Created by admin on 07/05/22.
//

import Foundation
import Alamofire
import ObjectMapper

var apikeyError = 1

class ImagesViewModel {
    static var shared = ImagesViewModel()
    
    func getImagesApiCall(parentVC: UIViewController,page: Int,search: String,completion: @escaping (ImagesResponse?) -> Void) {
        let params = [APIKey.page: page,APIKey.query: search] as [String : Any]
        var apiKey = APIManager.apiKey1
        switch apikeyError {
        case 1:
            apiKey = APIManager.apiKey1
        case 2:
            apiKey = APIManager.apiKey2
        case 3:
            apiKey = APIManager.apiKey3
        case 4:
            apiKey = APIManager.apiKey4
        default:
            apiKey = APIManager.apiKey1
        }
        let headers = [APIKey.authorization: apiKey] as HTTPHeaders
        AF.request(APIManager.search, method: .get, parameters: params, headers: headers).responseString(completionHandler: { result in
            if result.error == nil {
                let resObj = Mapper<ImagesResponse>().map(JSONString: result.value ?? "")
                completion(resObj)
            } else {
                apikeyError += 1
                if NetworkManager.isConnectedToNetwork() {
                    let alert = UIAlertController(title: "API key request limit exceeded", message: "search again 3 4 times because i added some more api key for better experience. and if this will not work than you need to add your own api key in APIManager file in project", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "Ok", style: .default)
                    alert.addAction(alertAction)
                    parentVC.present(alert, animated: true)
                }
            }
        })
    }
}
