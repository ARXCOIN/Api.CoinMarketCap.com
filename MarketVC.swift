import UIKit
import GoogleMobileAds


struct Market {
	var rank: String
	var symbol: String
	var price: Double
 
	var percentChange24h: String
}

class MarketVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

	var dataSource = [Market]()
	var filteredData = [Market]()
	let cellReuseIdentifier = "marketcell"
	var marketCap = 0
	let sharedDefaults = UserDefaults.init(suiteName: "group.no.kriise.CoincaseWidget")!
	var isSearching = false
	var bannerView: GADBannerView!
	
	var refreshControl: UIRefreshControl!
	@IBOutlet var backgroundView: UIView!
	@IBOutlet weak var marketTableView: UITableView!
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var headerView: UIView!
	@IBOutlet weak var marketCapLabel: UILabel!
	@IBOutlet weak var spinner: UIActivityIndicatorView!
	@IBOutlet weak var spinnerLabel: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
        //hide navigation bar
        
        self.navigationController?.isNavigationBarHidden = true
        //tabbar
        UITabBar.appearance().barTintColor = UIColor.black
       
        //end hide
        
        
		self.marketTableView.delegate = self
		self.marketTableView.dataSource = self
		self.searchBar.delegate = self
		headerView.roundedCorners(top:true)
		refreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action: #selector(didRefresh), for: .valueChanged)
		marketTableView.addSubview(refreshControl)
	//	backgroundView.backgroundColor = UIColor.black//aslix(red: 170.0/255.0, green: 121.0/255.0, blue: 255.0/255.0, alpha: 1.0)
		//bannerView = GADBannerView(adSize: kGADAdSizeBanner)
		//addBannerViewToView(bannerView)
	//	bannerView.adUnitID = "ca-app-pub-1322409251712247/1633874471" // <- Prod
		//bannerView.rootViewController = self
//		let request: GADRequest = GADRequest()
//		request.testDevices = ["5b90aff35346df381715c325c0f722a2e679e819", kGADSimulatorID]
//		bannerView.load(request)
//		bannerView.load(GADRequest())
        //test2
        
   
	}
    
	
	override func viewWillAppear(_ animated: Bool) {
		didRefresh()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		UIView.animate(withDuration: 0.5, animations: { () -> Void in
		//	self.backgroundView.backgroundColor = UIColor.magenta//aslix(red: 2.0/255.0, green: 169.0/255.0, blue: 151.0/255.0, alpha: 1.0)
		})
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		//backgroundView.backgroundColor = UIColor(red: 170.0/255.0, green: 121.0/255.0, blue: 255.0/255.0, alpha: 1.0)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
/*	func addBannerViewToView(_ bannerView: GADBannerView) {
		bannerView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(bannerView)
		view.addConstraints(
			[NSLayoutConstraint(item: bannerView,
								attribute: .bottom,
								relatedBy: .equal,
								toItem: bottomLayoutGuide,
								attribute: .top,
								multiplier: 1,
								constant: 0),
			 NSLayoutConstraint(item: bannerView,
								attribute: .centerX,
								relatedBy: .equal,
								toItem: view,
								attribute: .centerX,
								multiplier: 1,
								constant: 0)
			])
	}*/
	
	@objc func didRefresh() {
		fetchTokens()
		fetchMarketCap()
		reloadTableView()
	}
	
//	func requestReview() {
//		DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
//			NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RequestReview"), object: nil)
//		})
//	}
	//auto update
    
    func update() {
        
     marketTableView.reloadData()
        
    }
    
    
    //
	func updateMarketCap() {
		let marketCapDouble = Double(marketCap)
	//asli
        let converted = convertToCurrency(amount: marketCapDouble)
		
        let valueString = converted.replacingOccurrences(of: ",", with: " ", options: .literal, range: nil)
		
        marketCapLabel.text = valueString
	}
	
	
     func convertToCurrency(amount: Double) -> String {
		var multiplier = 1.0
		var currency = "$"
		let value = sharedDefaults.integer(forKey: "currency")
		switch value {
		case 0:
			multiplier = 1.0//8.3
			currency = "$"
			break
		case 1:
			multiplier = 1.0
			currency = "$"
			break
		default:
			break
		}

		let formattedTotalConverted = formatCurrency(value: amount * multiplier, decimals: 0)
		let currencyString = formattedTotalConverted.replacingOccurrences(of: ",", with: " ", options: .literal, range: nil)
		let response = "\(currency) \(currencyString)"
		return response
	}
	
	func formatCurrency(value: Double, decimals: Int) -> String {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		formatter.maximumFractionDigits = decimals
		formatter.locale = Locale(identifier: Locale.current.identifier)
		let result = formatter.string(from: value as NSNumber)
		return result!
	}
	
	@objc func fetchMarketCap() {
		let urlString = "https://api.coinmarketcap.com/v1/global";
		let url = URL(string: urlString)
		URLSession.shared.dataTask(with: url!) { (data, response, error) in
			guard let data = data, error == nil else {
				print("Error: \(String(describing: error))")
				return
			}
			do {
				if let parsedData = try JSONSerialization.jsonObject(with: data) as? [String:Any] {
					let value = parsedData["total_market_cap_usd"] as! Int
					self.marketCap = value
					DispatchQueue.main.async {
						self.updateMarketCap()
						self.stopSpinner()
					}
				}
			} catch let error as NSError {
				print("Error: \(error)")
			}
			}
			.resume()
	}
	//https://api.coinmarketcap.com/v1/ticker/?start=0&limit=200
    
    @objc func fetchTokens() {
		let urlString = "https://api.coinmarketcap.com/v1/ticker/?limit=400";
       
        
		let url = URL(string: urlString)
		URLSession.shared.dataTask(with: url!) { (data, response, error) in
			guard let data = data, error == nil else {
				print("Error: \(String(describing: error))")
				return
			}
			do {
				if let parsedData = try JSONSerialization.jsonObject(with: data) as? [[String:Any]] {
					for item in parsedData {
						let rank = item["rank"] as! String
						let symbol = item["symbol"] as! String
						let tempPrice = item["price_usd"] as! String
						let tempChange = item["percent_change_24h"] as! String
						let priceDouble = Double(tempPrice)!
						if let index = self.dataSource.index(where: { $0.symbol == symbol }) {
							// Already exists in Struct
							self.dataSource[index].symbol = symbol
							self.dataSource[index].price = priceDouble
							self.dataSource[index].percentChange24h = tempChange
						} else {
							// New addition to Struct
							self.dataSource.append(Market(rank: rank, symbol: symbol, price: priceDouble, percentChange24h: tempChange))
						}
					}
					DispatchQueue.main.async {
						self.marketTableView.reloadData()
					}
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
						self.refreshControl.endRefreshing()
					})
				}
			} catch let error as NSError {
				print("Error: \(error)")
			}
			}
			.resume()
	}
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if searchBar.text == nil || searchBar.text == "" {
			isSearching = false
			marketTableView.reloadData()
		} else {
			isSearching = true
			filteredData = dataSource.filter({$0.rank.localizedCaseInsensitiveContains(searchBar.text!) || $0.symbol.localizedCaseInsensitiveContains(searchBar.text!)})
			marketTableView.reloadData()
		}
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		view.endEditing(true)
	}
	
	func startSpinner() {
		spinner.startAnimating()
		spinner.isHidden = false
		spinnerLabel.isHidden = false
	}
	
	func stopSpinner() {
		spinner.stopAnimating()
		spinner.isHidden = true
		spinnerLabel.isHidden = true
	}
	
	func reloadTableView() {
		self.marketTableView.reloadData()
		self.updateMarketCap()
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if isSearching {
			return filteredData.count
		} else {
			return dataSource.count
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell:MarketCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! MarketCell
		guard dataSource.count > indexPath.row else {
			return cell
		}
		var data = dataSource[indexPath.row]
		if isSearching {
			data = filteredData[indexPath.row]
		}
		cell.rankLabel.text = "#\(data.rank)"
		if let _ = UserDefaults.standard.value(forKey: data.symbol) {
		
		} else {
	
		}
		cell.percentageView.layer.cornerRadius = 4.0
		cell.symbolLabel.text = data.symbol
		let formattedPrice = formatCurrency(value: data.price, decimals: 5)
		let a = "$ \(formattedPrice)"
		let priceString = a.replacingOccurrences(of: ",", with: ".", options: .literal, range: nil)
		cell.priceLabel.text = priceString
		if data.percentChange24h.range(of:"-") == nil {
			// Positive change
			cell.percentageLabel.text = "+\(data.percentChange24h)%"
			cell.percentageView.backgroundColor = UIColor.green//(red: 32.0/255.0, green: 255.0/255.0, blue: 57.0/255.0, alpha: 1.0)
            
		} else {
			// Negative change
			cell.percentageLabel.text = "\(data.percentChange24h)%"
			cell.percentageView.backgroundColor = UIColor(red: 254.0/255.0, green: 59.0/255.0, blue: 48.0/255.0, alpha: 1.0)
		}
		return cell
	}
	
//aslix	//func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		//print("You tapped cell number \(indexPath.row).")
//	}
	//
    
    
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")

    
       // performSegue(withIdentifier: "Detailes", sender: self)
   }
    
    
    //
    
    
    
	@IBAction func didTapWalletButton(_ sender: Any) {
		if let url = URL(string: "coincase://") {
			if UIApplication.shared.canOpenURL(url) {
				UIApplication.shared.open(url)
			} else {
				self.performSegue(withIdentifier: "getwallet", sender: self)
			}
		}
	}
}
