//
//  GetJson.swift
//  pokemon-api
//

import Foundation
import UIKit

class GetPokemonAPIData {
    
    /// JSONデータの取得
    /// 
    /// PokemonAPIからポケモンIDをもとに、JSONデータを取得する。
    /// 
    /// 改行できた？
    ///
    /// - Returns: Jsonデータ
    func getJson(id: String, completion: @escaping ([String: Any]?) -> Void) {
        let url: URL = URL(string: "https://pokeapi.co/api/v2/pokemon/" + id)!

        // api通信をしてレスポンスが返って来た段階でこの関数が実行される
        let task: URLSessionTask = URLSession.shared.dataTask(
            with: url,
            completionHandler: {(data, response, error) in
                do {
                    // jsonに変換
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] {
                        // コールバックで結果を返す
                        completion(json)
                    } else {
                        throw NSError(domain: "JSONSerialization Error", code: -1, userInfo: nil)
                    }
                } catch {
                    print(error)
                }
            }
        )
        // 実行する
        task.resume()
    }
    
    /// ポケモンの画像データ取得
    /// - Parameter json: ポケモンのJsonデータ
    /// - Returns: ポケモンの画像
    func getPokemonImage(_ json:[String: Any], frontBack: String, completion: @escaping (UIImage?) -> Void)  {

        let spritesJson = json["sprites"] as! [String: Any]
        print(spritesJson)

        // jsonから画像のURL取得
        guard let frontUrl = spritesJson[frontBack] as? String else { return }
        print(frontUrl)

        // URL型へ
        guard let url = URL(string: frontUrl) else {
            print("エラー")
            return
        }
        
        // URLから画像を取得
        do {
            // データとして取得
            let data = try Data(contentsOf: url)
            // UIImageに変換
            guard let image = UIImage(data: data) else {
                print("エラー")
                return 
            }
            completion(image)
        } catch {
            print("エラー")
        }
    }
    
    

    func getTrainerImage(completion: @escaping (UIImage?) -> Void){
        let url: URL = URL(string: "https://dic.nicovideo.jp/oekaki/115942.png")

        // URLから画像を取得
        do {
            // データとして取得
            let data = try Data(contentsOf: url)
            // UIImageに変換
            guard let image = UIImage(data: data) else {
                print("エラー")
                return
            }
            completion(image)
        } catch {
            print("エラー")
        }
    }
}
