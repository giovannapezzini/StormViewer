//
//  ViewController.swift
//  StormViewer
//
//  Created by Giovanna Pezzini on 01/01/21.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Properties

    var collectionView: UICollectionView!
    var pictures = [String]()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureCollectionView()
        performSelector(inBackground: #selector(loadPictures), with: nil)
    }
    
    // MARK: - Layout UI
    
    func configureView() {
        title = "Storm Viewer ⛈"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    }
        
    func configureCollectionView() {
        let layout: UICollectionViewFlowLayout = LeftAlignedCollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView?.register(PictureCell.self, forCellWithReuseIdentifier: "Picture")
        collectionView?.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
    }
    
    // MARK: - Fetch Data
    
    @objc func loadPictures() {
        DispatchQueue.main.async {
            let fm = FileManager.default
            let path = Bundle.main.resourcePath!
            let items = try! fm.contentsOfDirectory(atPath: path)
            
            for item in items.sorted() {
                if item.hasPrefix("nssl") { self.pictures.append(item) }
            }
            
            DispatchQueue.main.async { self.collectionView.reloadData() }
        }
    }
    
    // MARK: - Button tapped
    
    @objc func shareTapped() {
        let shareLink = "Try it! https://github.com/giovannapezzini/StormViewer"
        
        let vc = UIActivityViewController(activityItems: [shareLink], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    // MARK: - CollectionView DataSource and Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Picture", for: indexPath) as! PictureCell
        let picture = pictures[indexPath.row]
        cell.label.text = picture
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
        detailVC.selectedImage = pictures[indexPath.row]
        detailVC.selectedPictureNumber = indexPath.row + 1
        detailVC.totalPictures = pictures.count

        navigationController?.pushViewController(detailVC, animated: true)
    }
}
