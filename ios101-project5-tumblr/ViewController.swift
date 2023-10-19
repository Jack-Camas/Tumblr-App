//
//  ViewController.swift
//  ios101-project5-tumbler
//

import UIKit
import Nuke

class ViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	private var post = [Post]()
	private let refreshControl = UIRefreshControl()
	private var canRefresh: Bool = true


    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.dataSource = self
		tableView.delegate = self
		tableView.refreshControl = refreshControl
		refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
		
        fetchPosts()
    }
	
	
	
	//Pull to refresh feed, refresh after short delay to prevetn spamming
	@objc func refreshData() {
		guard canRefresh else { return }
		canRefresh = false
		DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
			self.canRefresh = true
		}
		fetchPosts()
	}

    func fetchPosts() {
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork/posts/photo?api_key=1zT8CiXGXFcQDyMFG7RtcfGLwTdDjFUJnZzKJaWTmgyK4lKGYk")!
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                return
            }

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, (200...299).contains(statusCode) else {
                print("❌ Response error: \(String(describing: response))")
                return
            }

            guard let data = data else {
                print("❌ Data is NIL")
                return
            }

            do {
                let blog = try JSONDecoder().decode(Blog.self, from: data)

                DispatchQueue.main.async { [weak self] in

                    let posts = blog.response.posts


                    print("✅ We got \(posts.count) posts!")
                    for post in posts {
                        print("🍏 Summary: \(post.summary)")
                    }
					
					self?.post = posts.shuffled()
					self?.tableView.reloadData()
			
                }

            } catch {
                print("❌ Error decoding JSON: \(error.localizedDescription)")
            }
        }
        session.resume()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return post.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
		let post = post[indexPath.row]
		
		cell.summaryLabel.text = post.summary
		
		
		if let photoArray = post.photos.first {
			let photoUrl = photoArray.originalSize.url
			Nuke.loadImage(with: photoUrl, into: cell.postImageView )
		}
		
		return cell
	}
	
	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		if refreshControl.isRefreshing {
			refreshControl.endRefreshing()
		}
	}
	
}

