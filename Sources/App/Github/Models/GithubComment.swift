import Vapor

public struct GithubComment: Content {
    public let id: Int
    public let body: String
    //    "comment": {
    //        "url": "https://api.github.com/repos/twof/FlaskOnAWS/issues/comments/465772859",
    //        "html_url": "https://github.com/twof/FlaskOnAWS/pull/3#issuecomment-465772859",
    //        "issue_url": "https://api.github.com/repos/twof/FlaskOnAWS/issues/3",
    //        "id": 465772859,
    //        "node_id": "MDEyOklzc3VlQ29tbWVudDQ2NTc3Mjg1OQ==",
    //        "user": {
    //            "login": "twof",
    //            "id": 5561501,
    //            "node_id": "MDQ6VXNlcjU1NjE1MDE=",
    //            "avatar_url": "https://avatars2.githubusercontent.com/u/5561501?v=4",
    //            "gravatar_id": "",
    //            "url": "https://api.github.com/users/twof",
    //            "html_url": "https://github.com/twof",
    //            "followers_url": "https://api.github.com/users/twof/followers",
    //            "following_url": "https://api.github.com/users/twof/following{/other_user}",
    //            "gists_url": "https://api.github.com/users/twof/gists{/gist_id}",
    //            "starred_url": "https://api.github.com/users/twof/starred{/owner}{/repo}",
    //            "subscriptions_url": "https://api.github.com/users/twof/subscriptions",
    //            "organizations_url": "https://api.github.com/users/twof/orgs",
    //            "repos_url": "https://api.github.com/users/twof/repos",
    //            "events_url": "https://api.github.com/users/twof/events{/privacy}",
    //            "received_events_url": "https://api.github.com/users/twof/received_events",
    //            "type": "User",
    //            "site_admin": false
    //        },
    //        "created_at": "2019-02-20T22:02:25Z",
    //        "updated_at": "2019-02-20T22:02:25Z",
    //        "author_association": "OWNER",
    //        "body": "something"
    //    },
}
