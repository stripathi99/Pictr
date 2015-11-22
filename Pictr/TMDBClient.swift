//
//  TMDBClient.swift
//  Pictr
//
//  Created by Shubham Tripathi on 12/11/15.
//  Copyright © 2015 coolshubh4. All rights reserved.
//

import Foundation

class TMDBClient : NSObject {
    
    /* Shared session */
    var session: NSURLSession
    
    /* Configuration object */
    //var config = TMDBConfig()
    
    enum MovieFetchRequestType {
        case NowPlaying, TopRated, Upcoming, Popular
    }
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    // MARK: - GET
    
    func taskForGETMethod(method: String, parameters: [String : AnyObject]?, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        var mutableParameters = [String: AnyObject]()
        /* 1. Set the parameters */
        if parameters != nil {
            mutableParameters = parameters!
        }
        //var mutableParameters = parameters
        mutableParameters[ParameterKeys.ApiKey] = Constants.ApiKey
        
        /* 2/3. Build the URL and configure the request */
        let urlString = Constants.BaseURLSecure + method + TMDBClient.escapedParameters(mutableParameters)
        let url = NSURL(string: urlString)!
        print("request url - \(urlString)")
        let request = NSURLRequest(URL: url)
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            if let error = downloadError {
                //let newError = TMDBClient.errorForData(data, response: response, error: error)
                completionHandler(result: nil, error: error)
            } else {
                TMDBClient.parseJSONWithCompletionHandler(data!, completionHandler: completionHandler)
            }
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    func taskForGETImage(size: String, filePath: String, completionHandler: (imageData: NSData?, error: NSError?) ->  Void) -> NSURLSessionTask {
        
        /* 1. Set the parameters */
        // There are none...
        
        /* 2/3. Build the URL and configure the request */
        _ = [size, filePath]
        let baseURL = NSURL(string: "https://image.tmdb.org/t/p/")!
        let url = baseURL.URLByAppendingPathComponent(size).URLByAppendingPathComponent(filePath)
        let request = NSURLRequest(URL: url)
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            if let error = downloadError {
                //let newError = TMDBClient.errorForData(data, response: response, error: error)
                completionHandler(imageData: nil, error: error)
            } else {
                completionHandler(imageData: data, error: nil)
            }
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    
    // MARK: - Helpers
    
    /* Helper: Substitute the key for the value that is contained within the method name */
    class func subtituteKeyInMethod(method: String, key: String, value: String) -> String? {
        if method.rangeOfString("{\(key)}") != nil {
            return method.stringByReplacingOccurrencesOfString("{\(key)}", withString: value)
        } else {
            return nil
        }
    }
    
//    /* Helper: Given a response with error, see if a status_message is returned, otherwise return the previous error */
//    class func errorForData(data: NSData?, response: NSURLResponse?, error: NSError) -> NSError {
//        
//        do {
//            let parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? [String : AnyObject]
//            if let errorMessage = parsedResult![TMDBClient.JSONResponseKeys.StatusMessage] as? String {
//                let userInfo = [NSLocalizedDescriptionKey : errorMessage]
//                return NSError(domain: "TMDB Error", code: 1, userInfo: userInfo)
//            }
//        } catch {}
//        
//        return error
////        if let parsedResult = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? [String : AnyObject] {
////            
////            if let errorMessage = parsedResult[TMDBClient.JSONResponseKeys.StatusMessage] as? String {
////                
////                let userInfo = [NSLocalizedDescriptionKey : errorMessage]
////                
////                return NSError(domain: "TMDB Error", code: 1, userInfo: userInfo)
////            }
////        }
////        
////        return error
//    }
    
    /* Helper: Given raw JSON, return a usable Foundation object */
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        do {
            let parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
            completionHandler(result: parsedResult, error: nil)
        } catch {
            completionHandler(result: nil, error: NSError(domain: "Pictr", code: 1, userInfo: [NSLocalizedDescriptionKey : "Could not parse JSON"]))
        }
    }
    
    /* Helper function: Given a dictionary of parameters, convert to a string for a url */
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
    
    // MARK: - Shared Instance
    
    class func sharedInstance() -> TMDBClient {
        
        struct Singleton {
            static var sharedInstance = TMDBClient()
        }
        
        return Singleton.sharedInstance
    }
}