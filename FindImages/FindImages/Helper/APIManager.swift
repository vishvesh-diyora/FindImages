//
//  APIManager.swift
//  FindImages
//
//  Created by admin on 07/05/22.
//

import Foundation
 
class APIManager {
    
    //pexels.com has api request limit so i set many api keys for better expirence
    static internal let apiKey1 = "563492ad6f91700001000001add2e3bd3b244b99b71f9bfd4c5f32fb"
    static internal let apiKey2 = "563492ad6f91700001000001145f0d731ef44492ba53504f56dd9a66"
    static internal let apiKey3 = "563492ad6f91700001000001c97a8cea647743f3b001c504c17af77a"
    static internal let apiKey4 = "563492ad6f91700001000001c97a8cea647743f3b001c504c17af77a"
    
    
    static internal let baseUrl = "https://api.pexels.com/v1/"
    static internal let search = baseUrl + "search"
}


struct APIKey {
    static internal let query = "query"
    static internal let page = "page"
    static internal let authorization = "Authorization"
}
