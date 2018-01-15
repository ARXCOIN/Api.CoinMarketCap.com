import UIKit

class GetWalletVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
	
	let cellReuseIdentifierFirst = "FirstCell"
	let cellReuseIdentifierSecond = "SecondCell"

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var backgroundView: UIView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		tableView.dataSource = self
		tableView.delegate = self
		backgroundView.roundedCorners(top:true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.row == 0 {
			let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifierFirst)!
			return cell
		} else {
			let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifierSecond)!
			return cell
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		print("You tapped cell number \(indexPath.row).")
	}
	
	@IBAction func didTapClose(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction func didTapGetWallet(_ sender: Any) {
		if let url = URL(string: "https://itunes.apple.com/app/id1325236833") {
			if UIApplication.shared.canOpenURL(url) {
				UIApplication.shared.open(url)
			} else {
				// TODO: Show error
			}
		}
	}
}
