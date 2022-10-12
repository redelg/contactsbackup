//
//  String.swift
//  Easy Contacts Backup
//
//  Created by Renzo Delgado on 22/09/22.
//

extension String {
    static var alphabet: [String] {
        var chars = [String]()
        for char in "abcdefghijklmnopqrstuvwxyz#".uppercased() {
            chars.append(String(char))
        }
        return chars
    }
}
