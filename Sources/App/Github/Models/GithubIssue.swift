import Vapor

public struct GithubIssue: Content {
    public let id: Int
    public let number: Int
    public let user: GithubUser
    public let title: String
    public let body: String
    public let pullRequest: GithubShortFormPullRequest?
    
    enum CodingKeys: String, CodingKey {
        case id
        case number
        case user
        case title
        case body
        case pullRequest = "pull_request"
    }
    //    "issue": {
    //        "url": "https://api.github.com/repos/twof/FlaskOnAWS/issues/3",
    //        "repository_url": "https://api.github.com/repos/twof/FlaskOnAWS",
    //        "labels_url": "https://api.github.com/repos/twof/FlaskOnAWS/issues/3/labels{/name}",
    //        "comments_url": "https://api.github.com/repos/twof/FlaskOnAWS/issues/3/comments",
    //        "events_url": "https://api.github.com/repos/twof/FlaskOnAWS/issues/3/events",
    //        "html_url": "https://github.com/twof/FlaskOnAWS/pull/3",
    //        "id": 412620987,
    //        "node_id": "MDExOlB1bGxSZXF1ZXN0MjU0Nzg4NDg0",
    //        "number": 3,
    //        "title": "Update README.md",
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
    //        "labels": [],
    //        "state": "open",
    //        "locked": false,
    //        "assignee": null,
    //        "assignees": [],
    //        "milestone": null,
    //        "comments": 2,
    //        "created_at": "2019-02-20T20:47:52Z",
    //        "updated_at": "2019-02-20T22:02:25Z",
    //        "closed_at": null,
    //        "author_association": "OWNER",
    //        "pull_request": {
    //            "url": "https://api.github.com/repos/twof/FlaskOnAWS/pulls/3",
    //            "html_url": "https://github.com/twof/FlaskOnAWS/pull/3",
    //            "diff_url": "https://github.com/twof/FlaskOnAWS/pull/3.diff",
    //            "patch_url": "https://github.com/twof/FlaskOnAWS/pull/3.patch"
    //        },
    //        "body": ""
    //    },
}
