//
//  UserViewModel.swift
//  Koko_Friends
//
//  Created by HowardHung on 2024/12/13.
//

import Foundation

class UserViewModel {
    private var user: User

    var name: String {
        return user.name
    }

    var kokoid: String {
        return user.kokoid
    }
    var isTop: String {
        return user.isTop
    }
    var status: Int {
        return user.status
    }

    init(user: User) {
        self.user = user
    }
}
