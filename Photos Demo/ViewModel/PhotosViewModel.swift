//
//  PhotosViewModel.swift
//  Photos Demo
//
//  Created by Tanvir Rahman on 2/9/24.
//

import Foundation
import Alamofire

class PhotosViewModel: ObservableObject {

    @Published var viewModelPhotos : [Photo] = []
    @Published var totalPhotos: Int = 0
    
    func fetchPhotos(_ page: Int){
        var headers = HTTPHeaders()
        headers["Authorization"] = "vm92QCeCUpbBrDTvodY70SiekrTOvfnwlszlwQRe7CcDOX2SCkmK8qYX"
        
        AF.request("https://api.pexels.com/v1/curated?page=\(page)&per_page=60",method: .get, headers: headers ).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let data = try JSONDecoder().decode(PhotosModel.self, from: data)
                    self.viewModelPhotos += data.photos ?? []
                    self.totalPhotos = data.totalResults ?? 0
                }catch {
                    print("decode error \(error.localizedDescription)")
                }
            case .failure(let error):
                print(error)
            }
            if let data  = response.data {
                do {
                    let decode = try JSONDecoder().decode(Photo.self, from: data)
                    print(data.prettyPrintedJSONString ?? Data())
                }catch {
                    print("Failed to decode JSON: \(error)")
                }
            }
            
        }
        
    }
    
}

extension Data {
    var prettyPrintedJSONString: NSString? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        return prettyPrintedString
    }
}
