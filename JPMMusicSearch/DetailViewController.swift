//
//  DetailViewController.swift
//  JPMMusicSearch
//
//  Created by Larry on 1/8/17.
//  Copyright © 2017 Savings iOS Dev. All rights reserved.
//

import UIKit

final class DetailViewController: UIViewController {
    @IBOutlet weak var lyricsTextField: UITextView!
    
    @IBOutlet weak var artistNameLabel: UILabel!
    
    @IBOutlet weak var albumNameLabel: UILabel!
    
    @IBOutlet weak var trackNameLabel: UILabel!
    
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    @IBOutlet weak var priceTitleLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var artworkImageView: UIImageView!
    
    var viewModel: DetailViewModel? {
        didSet {
            viewModel?.delegate = self
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func setUpUI() {
        artistNameLabel.text = viewModel?.artistName
        albumNameLabel.text = viewModel?.albumName
        trackNameLabel.text = viewModel?.trackName
        priceLabel.text = viewModel?.price
        releaseDateLabel.text = viewModel?.releaseDate
        priceTitleLabel.text = viewModel?.priceTitle
        
        artworkImageView.layer.cornerRadius = artworkImageView.frame.size.width / 2
        artworkImageView.clipsToBounds = true
    }
    
}


// MARK: - Extension of DetailViewController following the model protocal
extension DetailViewController: DetailViewModelDelegate {
    

    
    func imageDataDownloadDidFinished() {
        DispatchQueue.main.async {
            self.artworkImageView.image = UIImage(data: (self.viewModel?.imageData!)!)
        }
    }
    
    func lyricsDownloadDidFinished() {
        DispatchQueue.main.async {
            self.lyricsTextField.text =  self.viewModel?.lyrics
        }
    }

}
