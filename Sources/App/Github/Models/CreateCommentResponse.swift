import Vapor

public struct CreateCommentResponse: Content {
    public let id: Int
    public let body: String
    public let user: GithubUser
    //{
    //    "url": "https://api.github.com/repos/twof/FlaskOnAWS/issues/comments/465787737",
    //    "html_url": "https://github.com/twof/FlaskOnAWS/pull/3#issuecomment-465787737",
    //    "issue_url": "https://api.github.com/repos/twof/FlaskOnAWS/issues/3",
    //    "id": 465787737,
    //    "node_id": "MDEyOklzc3VlQ29tbWVudDQ2NTc4NzczNw==",
    //    "user": {
    //        "login": "vapor-bot",
    //        "id": 47831817,
    //        "node_id": "MDQ6VXNlcjQ3ODMxODE3",
    //        "avatar_url": "https://avatars1.githubusercontent.com/u/47831817?v=4",
    //        "gravatar_id": "",
    //        "url": "https://api.github.com/users/vapor-bot",
    //        "html_url": "https://github.com/vapor-bot",
    //        "followers_url": "https://api.github.com/users/vapor-bot/followers",
    //        "following_url": "https://api.github.com/users/vapor-bot/following{/other_user}",
    //        "gists_url": "https://api.github.com/users/vapor-bot/gists{/gist_id}",
    //        "starred_url": "https://api.github.com/users/vapor-bot/starred{/owner}{/repo}",
    //        "subscriptions_url": "https://api.github.com/users/vapor-bot/subscriptions",
    //        "organizations_url": "https://api.github.com/users/vapor-bot/orgs",
    //        "repos_url": "https://api.github.com/users/vapor-bot/repos",
    //        "events_url": "https://api.github.com/users/vapor-bot/events{/privacy}",
    //        "received_events_url": "https://api.github.com/users/vapor-bot/received_events",
    //        "type": "User",
    //        "site_admin": false
    //    },
    //    "created_at": "2019-02-20T22:51:19Z",
    //    "updated_at": "2019-02-20T22:51:19Z",
    //    "author_association": "NONE",
    //    "body": "Me too"
    //}
}
