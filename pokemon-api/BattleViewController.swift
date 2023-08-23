//
//  BattleViewController.swift
//  pokemon-api
//

import UIKit

class BattleViewController: UIViewController {

    // API取得用クラス
    let apiAc : GetPokemonAPIData = GetPokemonAPIData()
    
    // 相手のポケモンjsonデータ
    var enemyPokemonJson : [String : Any]!
    // 相手のjsonから取得したポケモンの画像
    var enemyPokemonImage : UIImage! = nil
    // 相手のポケモン
    @IBOutlet var enemyPokemonImageView : UIImageView!
    
    // 自分のポケモンjsonデータ
    var myPokemonJson : [String : Any]!
    // 自分のjsonから取得したポケモンの画像
    var myPokemonImage : UIImage! = nil
    // 自分のポケモン
    @IBOutlet var myPokemonImageView : UIImageView!
    
    
    /// 画面表示
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setBattlePokmonJsonData()
        
//        setBattlePokmonImage()
        setBattlePokemonImage()

    }
    
    @IBAction func buttonTapped(sender: UIButton) {
        
        UIView.animate(withDuration: 0.15, animations: {
            self.myPokemonImageView.transform = CGAffineTransform(translationX: 75, y: 0)
        }) { _ in
            UIView.animate(withDuration: 0.15, animations: {
                self.myPokemonImageView.transform = CGAffineTransform.identity
            })
        }
    }

}



extension BattleViewController {
    
    func setBattlePokmonJsonData(){
        // 自分のポケモン
        setPokemonJsonData(pokemonId: "1", myselfOrEnemy: true)
        
        // 相手のポケモン
        setPokemonJsonData(pokemonId: "7", myselfOrEnemy: false)
    }
    
    
    
    func setPokemonJsonData(pokemonId: String, myselfOrEnemy: Bool){
        let semaphore = DispatchSemaphore(value: 0)
        // ポケモン１体の分
        self.apiAc.getJson(id : pokemonId, completion: { (json : [String : Any]?)  in
            if let checkedJson = json {
                if (myselfOrEnemy) {
                    self.myPokemonJson = checkedJson
                } else {
                    self.enemyPokemonJson = checkedJson
                }
                print(checkedJson)
                semaphore.signal()
            }
        })
        semaphore.wait()
    }
    
    
    func setBattlePokemonImage(){
        // 処理の進行を管理
        let semaphore = DispatchSemaphore(value: 0)
        
        // 相手
        self.apiAc.getPokemonImage(self.enemyPokemonJson, frontBack: "front_default" ,completion:{(image: UIImage?) in
            if let checkImage = image {
                self.enemyPokemonImage = checkImage
                semaphore.signal()
            }
        })
        // 画像情報の取得が完了するまで待機
        semaphore.wait()
        self.enemyPokemonImageView.image = self.enemyPokemonImage
        
        // 自分
        self.apiAc.getPokemonImage(self.myPokemonJson, frontBack: "back_default" ,completion:{(image: UIImage?) in
            if let checkImage = image {
                self.myPokemonImage = checkImage
                semaphore.signal()
            }
        })
        // 画像情報の取得が完了するまで待機
        semaphore.wait()
        self.myPokemonImageView.image = self.myPokemonImage
    }

    
    
    
}
    
    
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let url: URL = URL(string: "https://pokeapi.co/api/v2/pokemon/1")!
//        // api通信をしてレスポンスが返って来た段階でこの関数が実行される
//        let task: URLSessionTask = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
//            do {
//                // jsonに変換
//                let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: Any] // [key:value]
//                let spritesJson = json["sprites"] as! [String: Any]
//                print(spritesJson)
//
//                // jsonから画像のURL取得
//                guard let frontUrl = spritesJson["front_default"] as? String else { return }
//                print(frontUrl)
//
//                // URL型へ
//                guard let url = URL(string: frontUrl) else {
//                    print("エラー")
//                    return
//                }
//
//                // URLから画像を取得
//                do {
//                    // データとして取得
//                    let data = try Data(contentsOf: url)
//                    // UIImageに変換
//                    guard let image = UIImage(data: data) else {
//                        print("エラー")
//                        return
//                    }
//                    // メインスレッドで実行
//                    DispatchQueue.main.async {
//                        self.pokemonImageInView.image = image
//                        self.pokemonImage = image
//                    }
//
//                } catch {
//                    print("エラー")
//                }
//
//            }
//            catch {
//                print(error)
//            }
//        })
//        // 実行する
//        task.resume()
//
//    }

