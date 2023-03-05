//
//  PersistanceManager.swift
//  Starwars-Messager
//
//  Created by Muhammed Emin Bardakcı on 3.03.2023.
//

import Foundation

class PersistanceManager {
    
    private static let defaults = UserDefaults.standard
    enum Keys: String { case messages = "messages" }
    
    static func addData(message: String, person: String, completed: @escaping(SMError?) -> Void) {
        takeData { result in
            switch result {
            case .success(var messages):
                messages.append(Message(message: message, person: person))
                completed(saveData(messages: messages))
            case .failure(let errorMessages):
                completed(errorMessages)
            }
        }
    }
    
//    static func deleteData() {
//
//    }
//
//    static func changeData() {
//
//    }
    
    static func deleteAllData() -> SMError? {
        do {
            let messages: [Message] = []
            let encoder = JSONEncoder()
            let data = try encoder.encode(messages)
            defaults.set(data, forKey: Keys.messages.rawValue)
            return nil
        } catch {
            return SMError.deleteError
        }
    }
    
    static func takeData(completed: @escaping(Result<[Message],SMError>) -> Void) {
        guard let messagesData = defaults.object(forKey: Keys.messages.rawValue) as? Data else {
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let messages = try decoder.decode([Message].self, from: messagesData)
            completed(.success(messages))
            return
        } catch {
            completed(.failure(.takeDataError))
            return
        }
    }
    
    static func saveData(messages: [Message]) -> SMError? {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(messages)
            defaults.set(data, forKey: Keys.messages.rawValue)
            return nil
        } catch {
            return SMError.saveError
        }
    }
}
