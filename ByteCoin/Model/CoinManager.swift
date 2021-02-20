//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation


// Create a protocol, which requires the struct/class with this protocol to have the didUpdateWeather capability
protocol CoinManagerDelegate {
    // by convention, in a delegate method, we always have the identity of the object (i.e. weatherManager) that caused this method.
    func didUpdateCoin(_ coinManager: CoinManager, lastPrice: Double)
    func didFailWithError(error: Error)
}


struct CoinManager {
    
    // Coin manager would delegate WeatherManagerDelegate to other struct or class
    var delegate: CoinManagerDelegate?
    
    // URL
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "051E99BB-4A3F-4439-A796-453FD6AA162D"
    
    // param
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    // methods
    
    func getCoinPrice(for currency: String) {
        
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performRequest(with: urlString)
    }

    
    func performRequest(with urlString: String) { // note that "with" here is an external parameter name => more readable
        ///
        /// 4 steps to get api data
        ///
        
        // 1. create a url
        if let url = URL(string: urlString) { // do this as long as URL() do not fail or not null
            
            // 2. create a URLSession
            let session = URLSession(configuration: .default)
            
            // 3. give the session a task
            // original code, let task = session.dataTask(with: url, completionHandler: handle(data:response:error:))
            // use closure to perform the handle function
            let task = session.dataTask(with: url) { (data, response, error) in
                // check if there is error
                if error != nil {
                    // note: within closure, needs to use self
                    self.delegate?.didFailWithError(error: error!)
                    return // return means exit this function here.
                }
                
                // if there is data
                if let safeData = data {
//                    let dataString = String(data: safeData, encoding: .utf8)
//                    print(dataString!)
                    
                    // if weather data can be parsed
                    if let lastPrice = self.parseJson(safeData) {
//                        print(lastPrice)

                        // perform didUpdateWeather,
                        // if the delegated struct/class has the WeatherManagerDelegate protocol and
                        // the delegate has been initialised (in viewDidLoad) and
                        // the didUpdateCoin() capability has been defined.
                        self.delegate?.didUpdateCoin(self, lastPrice: lastPrice) // note: within closure, needs to use self
                    }
                    
                }
            }
            
            // 4. start the task
            task.resume()
        }
    }
    
    
    
    
    func parseJson(_ coinData: Data) -> Double? {
        ///
        /// Parse Json weather data into city name, temperature, condition id and condition name. stored within a WeatherModel.
        ///
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let lastPrice = decodedData.rate
            return lastPrice
        } catch {
            // print error from decode() method, if any
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
