//
//  FavouritesData.swift
//  Unsplash
//
//  Created by Аброрбек on 06.01.2023.
//

import UIKit
import RealmSwift

class PersistedFavouriteData: Object{
    @Persisted var id: String = ""
}

struct FavouritesData{
    static var favouritesData: [String] = []
}
