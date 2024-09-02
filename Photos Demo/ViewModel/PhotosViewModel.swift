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
    
    
    func fetchPhotos(){
        var headers = HTTPHeaders()
        headers["Authorization"] = "vm92QCeCUpbBrDTvodY70SiekrTOvfnwlszlwQRe7CcDOX2SCkmK8qYX"
        AF.request("https://api.pexels.com/v1/curated?page=2&per_page=100",method: .get, headers: headers ).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    
                    let data = try JSONDecoder().decode(PhotosModel.self, from: data)
                    self.viewModelPhotos = data.photos ?? []
                    
                }catch {
                    print("decode error \(error.localizedDescription)")
                }
            case .failure(let error):
                print(error)
            }
            if let data  = response.data {
                do {
                    let decode = try JSONDecoder().decode(Photo.self, from: data)
                    print(decode)
                }catch {
                    print("Failed to decode JSON: \(error)")
                }
            }
            
        }
        
    }
    
}
