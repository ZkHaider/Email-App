//
//  Email.Read.View.swift
//  EmailClient
//
//  Created by Haider Khan on 7/8/18.
//  Copyright © 2018 com.zkhaider. All rights reserved.
//

import Foundation
import UIKit
import Cartography

public final class ReadView: BaseView {
    
    // MARK: - Attributes
    
    var readEmails: [EmailModel] = [] {
        didSet {
            guard readEmails != oldValue else { return }
            update(withModels: readEmails)
        }
    }
    
    // MARK: - Views
    
    let readCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 150.0)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear 
        return view
    }()
    
    // MARK: - Init
    
    public required init() {
        super.init()
        initialize()
    }
    
    // MARK: - Lifecycle
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - Update
    
    private func update(withModels models: [EmailModel]) {
        
        // Update our tableview
        readCollectionView.reloadData()
    }
    
}

extension ReadView {
    
    fileprivate func initialize() {
        func addSubviews() {
            self.addSubview(readCollectionView)
        }
        func setupConstraints() {
            constrain(readCollectionView) {
                $0.edges == $0.superview!.edges
            }
        }
        func prepareViews() {
            readCollectionView.register(ReadCollectionViewCell.self, forCellWithReuseIdentifier: ReadCollectionViewCell.name)
            readCollectionView.delegate = self
            readCollectionView.dataSource = self
        }
        addSubviews()
        setupConstraints()
        prepareViews()
    }
    
}

extension ReadView: UICollectionViewDelegate {
    
    
    
}

extension ReadView: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return readEmails.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let readCell = collectionView.dequeueReusableCell(withReuseIdentifier: ReadCollectionViewCell.name, for: indexPath) as! ReadCollectionViewCell
        readCell.model = readEmails[indexPath.row]
        return readCell
    }
    
}
