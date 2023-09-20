//
//  MessagesController.swift
//  TinderClone
//
//  Created by Lucas Cavalcante on 25/03/22.
//

import UIKit

private let reuseIdetifier = "cell"

class MessagesController: UITableViewController{
    
    // MARK: Properties
    
    private let user: User
    
    private var conversations = [Conversation]()
    private var conversationdDictionary = [String : Conversation]()
    
    private let headerView = MatchHeader()
    
    
    // MARK: Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        configureTableView()
        configureNavigationBar()
        fetchMatches()
        fetchConversations()
    }
    
    
    // MARK: Helpers
    
    func configureTableView() {
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView()
        tableView.register(ConversationCell.self, forCellReuseIdentifier: reuseIdetifier)
        
        headerView.delegate = self
        
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 180)
        tableView.tableHeaderView = headerView
    }
    
    func configureNavigationBar(){
        let leftButton = UIImageView()
        leftButton.setDimensions(height: 28, width: 28)
        leftButton.isUserInteractionEnabled = true
        leftButton.image = #imageLiteral(resourceName: "app_icon.png").withRenderingMode(.alwaysTemplate)
        leftButton.tintColor = .lightGray
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismissal))
        
        leftButton.addGestureRecognizer(tap)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        
        let icon = UIImageView(image: #imageLiteral(resourceName: "top_messages_icon.png").withRenderingMode(.alwaysTemplate))
        icon.tintColor = .systemPink
        navigationItem.titleView = icon
        
    }
    
    // MARK: Actions
    
    @objc func handleDismissal() {
        dismiss(animated: true)
    }
    
    // MARK: - API
    
    func fetchMatches(){
        Service.fetchMatches { matches in
            self.headerView.matches = matches
        }
    }
    
    func fetchConversations() {
        showLoader(true)
        
        Service.fetchConversations { conversations in
            
            conversations.forEach { conversation in
                let message = conversation.message
                self.conversationdDictionary[message.chatPartnerId] = conversation
            }
            self.showLoader(false)
            self.conversations = Array(self.conversationdDictionary.values)
            
            
            self.tableView.reloadData()
        }
        
    }
    func showChatController(forUser user: User){
        let controller = ChatController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
}

// MARK: - UITableViewDataSource

extension MessagesController{
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdetifier, for: indexPath) as! ConversationCell
        cell.conversation = conversations[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return conversations.count
    }
    
}

// MARK: UITableViewDelegate

extension MessagesController{
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = conversations[indexPath.row].user
        showChatController(forUser: user)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        label.text = "Messages"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        view.addSubview(label)
        label.centerY(inView: view, leftAnchor: view.leftAnchor, paddingLeft: 12)
        
        return view
    }
}



// MARK: - MatchHeaderDelegate


extension MessagesController:  MatchHeaderDelegate {
    func matchHeader(_ header: MatchHeader, wantToSendMessageTo uid: String) {
        Service.fetchUser(withUid: uid) { user in
            self.showChatController(forUser: user)
        }
    }
    
    
}
