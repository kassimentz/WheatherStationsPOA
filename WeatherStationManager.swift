//
//  WeatherStationManager.swift
//  WheatherStationsPOA
//
//  Created by iossenac on 29/10/16.
//  Copyright © 2016 Kassiane Mentz. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

//faz o acesso à inclusao no meu model. trará um array de estacao
class WeatherStationManager: NSObject {
    
    // MARK: - Closures (ou bloco de instrucao)
    
    func loadWeatherStations(callback: @escaping(
        _ weatherStations: [WeatherStation]?, _ error: Error?) -> ()){
        
        DispatchQueue.main.async {
            Alamofire.request("https://metroclimaestacoes.procempa.com.br/metroclima/seam/resource/rest/externalRest/ultimaLeitura").responseJSON {response
                in
                
                var weatherStations = [WeatherStation]()
                
                let json = JSON(data: response.data!)
                
                for (_, subJSON): (String, JSON) in json {
                    
                    let weatherStation = WeatherStation(station: subJSON["estacao"].string,
                                                        latitude: subJSON["latitude"].double,
                                                        longitude: subJSON["latitude"].double,
                                                        temperaturaExterna: subJSON["temperaturaExterna"].double,
                                                        sensacaoTermica: subJSON["sensacaoTermica"].double,
                                                        temperaturaMinimaPrevisao: subJSON["temperaturaMinimaPrevisao"].double,
                                                        temperaturaMaximaPrevisao: subJSON["temperaturaMaximaPrevisao"].double)
                    
                    weatherStations.append(weatherStation)
                    
                }
                
                callback(weatherStations, json.error)
                
            }
        }
        
    }

}
