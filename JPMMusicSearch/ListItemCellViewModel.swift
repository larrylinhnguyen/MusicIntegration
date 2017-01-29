//
//  ListItemCellViewModel.swift
//  JPMMusicSearch
//
//  Created by Larry on 1/8/17.
//  Copyright © 2017 Savings iOS Dev. All rights reserved.
//

import Foundation



protocol ListItemCellViewModelDelegate: class {
    
    func imageDataDownloadDidFinished()
}


final class ListItemCellViewModel {
    
    weak var delegate: ListItemCellViewModelDelegate?
    
    let artistName: String
    let trackName: String
    let artworkThumbnailUrl: String
    
    var imageData: Data? {
        didSet {
            if imageData != nil {
                delegate?.imageDataDownloadDidFinished()
            }
        }
    }
    
    private let dataSource: ITunesDataSource
    
    init(track: Track, dataSource: ITunesDataSource) {
        artistName = track.artistname
        trackName = track.trackName
        artworkThumbnailUrl = track.artworkThumbnailUrl
        
        self.dataSource = dataSource
        
        downloadImageData()
    }
    
    
    private func downloadImageData() {
        
        dataSource.downloadImage(from: artworkThumbnailUrl, completion: { [weak self] data in
            if data != nil {
                self?.imageData = data
                print("Got data! \(data)")
            }
        })
    }
    
}
