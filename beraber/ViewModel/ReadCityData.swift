//
//  ReadCityData.swift
//  beraber
//
//  Created by yozdemir on 10.04.2022.
//

import SwiftUI

class ReadCityData: ObservableObject  {
    @Published var cities = [CitiesModel]()
    
        
    init(){
        loadData()
    }
    
    func loadData()  {
        guard let url = Bundle.main.url(forResource: "TurkeyCities", withExtension: "json")
            else {
                print("Json file not found")
                return
            }
        
        let data = try? Data(contentsOf: url)
        let cities = try? JSONDecoder().decode([CitiesModel].self, from: data!)
        self.cities = cities!
    }
     
}
