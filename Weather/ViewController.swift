//
//  ViewController.swift
//  Weather
//
//  Created by JUNO on 2022/04/30.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var citiNameTextField: UITextField!
    
    @IBOutlet weak var citiNameLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    
    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var weatherStackView: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapFetchWeatherBtn(_ sender: UIButton) {
        if let citiName = self.citiNameTextField.text {
            self.getCurrentWeather(CitiName: citiName)
            self.view.endEditing(true)
        }
    }
    
    func configView(weatherInfo: WeatherInfo){
        self.citiNameLabel.text = weatherInfo.name
        if let weather = weatherInfo.weather.first {
            self.weatherDescriptionLabel.text = weather.description
        }
        self.tempLabel.text = "\(Int(weatherInfo.temp.temp - 273.15))°C"
        self.minTempLabel.text = "최저 :\(Int(weatherInfo.temp.minTemp - 273.15))°C"
        self.maxTempLabel.text = "최고 :\(Int(weatherInfo.temp.maxTemp - 273.15))°C"
    }
    
    func showAlert(msg: String){
        let alert =  UIAlertController(title: "에러", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert
                     , animated: true, completion: nil)
    }
    
    func getCurrentWeather(CitiName: String){
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(CitiName)&appid=") else { return }
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { [weak self] data, response, error in
            
            let successRange = (200..<300)
            
            guard let data = data, error == nil else { return }
            let decoder = JSONDecoder()
            
            if let response = response as? HTTPURLResponse, successRange.contains(response.statusCode) {
                guard let weatherInfo = try? decoder.decode(WeatherInfo.self, from: data) else { return}
                
                DispatchQueue.main.async {
                    self?.weatherStackView.isHidden = false
                    self?.configView(weatherInfo: weatherInfo)
                }
            }
            else
            {
                guard let errorMsg = try? decoder.decode(ErrorMsg.self, from: data) else { return }
                DispatchQueue.main.async {
                    self?.showAlert(msg: errorMsg.msg)
                }
            }
        }.resume()
    }
    
}

