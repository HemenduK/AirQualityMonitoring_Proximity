//
//  AirQualityViewModel.swift
//  AirQualityMonitoring_Proximity
//
//  Created by Hemendu.Kathiriya on 06/11/21.
//

import UIKit
import Starscream

public typealias AQSuceessResponse<Type> = (Type)->Void

enum AQIObserverEvent {
    case updateDisplayList
    case updateCityAQI([AirQualityModel]?)
}

class AirQualityViewModel: NSObject {
    var socket: WebSocket!
    var isConnected = false
    let server = WebSocketServer()
    var arrAQ = [AirQualityModel]()
    var closure: AQSuceessResponse<AQIObserverEvent>?
    var detailedCityAQI = [String: [AirQualityModel]]()
    var selectedCity: AirQualityModel?
    
    override init() {
        super.init()
        establishConnection()
    }
    
    func establishConnection(){
        var request = URLRequest(url: URL(string: GLOBALCONSTANT.SOCKETURL)!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
    }
    
    // MARK: Disconnect Action
    func disconnect() {
        if isConnected {
            socket.disconnect()
        } else {
            socket.connect()
        }
    }
    
    //MARK: UPDATE VALUES AND SORT ARRAY
    func updateArray(_ list: [AirQualityModel]) {
        for item in list {
            let newItem = item
            // Latest AQI for city
            if let oldItem = arrAQ.filter({$0 == item}).first,
               let index = arrAQ.firstIndex(of: oldItem)
               {
                newItem.lastUpdated = oldItem.time?.timeAgo
                if newItem.category == .poor && oldItem.category == .good {
                    newItem.hasDegraded = true
                }
                arrAQ.remove(at: index)
                arrAQ.insert(newItem, at: index)
            } else {
                arrAQ.append(newItem)
            }
            
            if var values = detailedCityAQI[newItem.city!] {
                values.append(newItem)
                detailedCityAQI[newItem.city!] = values.sorted(by: {$0.time! < $1.time!})
            } else {
                detailedCityAQI[newItem.city!] = [newItem]
            }
        }
    }
}

extension AirQualityViewModel: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            isConnected = true
            print("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            isConnected = false
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            print("Received data: \(string)")
            if let data = string.data(using: .utf8){
                do {
                    let jsonDictionary =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                    let responseArr: [[String : Any]] = jsonDictionary as! [[String : Any]]
                    for dicAQ in responseArr{
                        let aqModel = AirQualityModel(fromDictionary: dicAQ)
                        arrAQ.append(aqModel)
                    }
                    updateArray(arrAQ)
                    if let closure = closure{
                        closure(.updateDisplayList)
                        guard let city = selectedCity else {
                            return
                        }
                        closure(.updateCityAQI(detailedCityAQI[city.city!]))
                    }
                } catch {
                    print("No data available")
                }
            }
        case .binary(let data):
            print("Received data: \(data.count)")
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            isConnected = false
        case .error(let error):
            isConnected = false
            handleError(error)
        }
    }
    
    func handleError(_ error: Error?) {
        if let e = error as? WSError {
            print("websocket encountered an error: \(e.message)")
        } else if let e = error {
            print("websocket encountered an error: \(e.localizedDescription)")
        } else {
            print("websocket encountered an error")
        }
    }
}
