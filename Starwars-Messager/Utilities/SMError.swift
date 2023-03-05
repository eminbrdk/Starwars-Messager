//
//  SMError.swift
//  Starwars-Messager
//
//  Created by Muhammed Emin Bardakcı on 3.03.2023.
//

import Foundation

enum SMError: String, Error {
    case hata = "lan hata çıktı çabuk düzelt."
    case deleteError = "Could not delete data."
    case takeDataError = "Can not reach the data."
    case saveError = "Can not save data."
}
