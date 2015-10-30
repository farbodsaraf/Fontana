//
//  ItunesPlainTextToSpotifyURLTransformer.swift
//  Spreadit
//
//  Created by Marko Hlebar on 29/10/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ItunesPlainTextToSpotifyURLTransformer: ShareTransformer {
    typealias T = String
    
    func transform(object: T, handler: (url: NSURL?) -> Void) {
        let parameters = constructParameters(object)
        let urlString = "https://api.spotify.com/v1/search" + parameters
        Alamofire.request(
            .GET,
            urlString)
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
                
                if let data = response.data {
                    let urlString = self.parseJSON(data)
                    handler(url: NSURL(string: urlString!));
                }
        }
    }
    
    func parseJSON(JSONData : NSData) -> String? {
        let json = JSON(data: JSONData)
        return json["tracks"]["items"][0]["external_urls"]["spotify"].string
    }
    
    func constructParameters(plainText: String) -> String {
        let query = getQueryParameter(plainText)
        return "?q=" + query + "&type=track,artist"
    }
    
    func getQueryParameter(plainText: String) -> String {
        var trimmedString = plainText.stringByReplacingOccurrencesOfString("Listen to ", withString: "")
        trimmedString = trimmedString.stringByReplacingOccurrencesOfString(" by ", withString: " ")
        trimmedString = trimmedString.stringByReplacingOccurrencesOfString(" on @AppleMusic.", withString: "")
        return trimmedString.stringByReplacingOccurrencesOfString(" ", withString: "+")
    }
}
