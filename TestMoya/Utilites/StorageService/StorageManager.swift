//
//  StorageManager.swift
//  TestMoya
//
//  Created by Maslov Sergey on 20.05.18.
//  Copyright © 2017 Maslov Sergey. All rights reserved.
//

import Foundation
import Signals

class StorageManager {
    static let shared = StorageManager()
    
    private init() {
        loadData()
    }
    
    private(set) var storage: StorageDefinition!
    
    var updateRepositorySignal = Signal<Repository>()
    var updateLastSearchQueurySignal = Signal<String>()
    
    func updateLastSearch(_ string: String) {
        storage.lastSearch = string
        updateLastSearchQueurySignal => string
        saveData()
    }
    
    func featureAction(repo: Repository) {
        let newRepo = repo
        newRepo.isFeatured = !newRepo.isFeatured
        
        if newRepo.isFeatured {
            storage.featuredRepos.insert(newRepo, at: 0)
        } else {
            if let index = storage.featuredRepos.index(where: { $0.id == repo.id} ) {
                storage.featuredRepos.remove(at: index)
            }
        }
        
        saveData()
        updateRepositorySignal => newRepo
    }
    
    func isRepoFeatured(_ repo: Repository) -> Bool {
        return storage.featuredRepos.contains(where: { $0.id == repo.id } )
    }
    
    
    // MARK: - File Read/Write Operations
    
    private let cacheFilename = "Storage.cache"
    
    private func loadData() {
        guard let storage = NSKeyedUnarchiver.unarchiveObject(withFile: storePathURL.path) as? StorageDefinition else {
            self.storage = StorageDefinition.defaultInstance()
            return
        }
        
        self.storage = storage
    }
    
    private func saveData() {
//        try? NSKeyedArchiver.archiveRootObject(storage, toFile: storePathURL.path)
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: storage)
        try? encodedData.write(to: storePathURL)
    }
    
    private var storePathURL: URL {
        let manager = FileManager.default
        let paths = manager.urls(for: .cachesDirectory, in:.userDomainMask)
        return paths.first!.appendingPathComponent(cacheFilename, isDirectory: false)
    }
}
