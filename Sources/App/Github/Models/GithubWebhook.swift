import Vapor
//{
//    "action": "created",
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
//    "repository": {
//        "id": 158474926,
//        "node_id": "MDEwOlJlcG9zaXRvcnkxNTg0NzQ5MjY=",
//        "name": "FlaskOnAWS",
//        "full_name": "twof/FlaskOnAWS",
//        "private": false,
//        "owner": {
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
//        "html_url": "https://github.com/twof/FlaskOnAWS",
//        "description": null,
//        "fork": false,
//        "url": "https://api.github.com/repos/twof/FlaskOnAWS",
//        "forks_url": "https://api.github.com/repos/twof/FlaskOnAWS/forks",
//        "keys_url": "https://api.github.com/repos/twof/FlaskOnAWS/keys{/key_id}",
//        "collaborators_url": "https://api.github.com/repos/twof/FlaskOnAWS/collaborators{/collaborator}",
//        "teams_url": "https://api.github.com/repos/twof/FlaskOnAWS/teams",
//        "hooks_url": "https://api.github.com/repos/twof/FlaskOnAWS/hooks",
//        "issue_events_url": "https://api.github.com/repos/twof/FlaskOnAWS/issues/events{/number}",
//        "events_url": "https://api.github.com/repos/twof/FlaskOnAWS/events",
//        "assignees_url": "https://api.github.com/repos/twof/FlaskOnAWS/assignees{/user}",
//        "branches_url": "https://api.github.com/repos/twof/FlaskOnAWS/branches{/branch}",
//        "tags_url": "https://api.github.com/repos/twof/FlaskOnAWS/tags",
//        "blobs_url": "https://api.github.com/repos/twof/FlaskOnAWS/git/blobs{/sha}",
//        "git_tags_url": "https://api.github.com/repos/twof/FlaskOnAWS/git/tags{/sha}",
//        "git_refs_url": "https://api.github.com/repos/twof/FlaskOnAWS/git/refs{/sha}",
//        "trees_url": "https://api.github.com/repos/twof/FlaskOnAWS/git/trees{/sha}",
//        "statuses_url": "https://api.github.com/repos/twof/FlaskOnAWS/statuses/{sha}",
//        "languages_url": "https://api.github.com/repos/twof/FlaskOnAWS/languages",
//        "stargazers_url": "https://api.github.com/repos/twof/FlaskOnAWS/stargazers",
//        "contributors_url": "https://api.github.com/repos/twof/FlaskOnAWS/contributors",
//        "subscribers_url": "https://api.github.com/repos/twof/FlaskOnAWS/subscribers",
//        "subscription_url": "https://api.github.com/repos/twof/FlaskOnAWS/subscription",
//        "commits_url": "https://api.github.com/repos/twof/FlaskOnAWS/commits{/sha}",
//        "git_commits_url": "https://api.github.com/repos/twof/FlaskOnAWS/git/commits{/sha}",
//        "comments_url": "https://api.github.com/repos/twof/FlaskOnAWS/comments{/number}",
//        "issue_comment_url": "https://api.github.com/repos/twof/FlaskOnAWS/issues/comments{/number}",
//        "contents_url": "https://api.github.com/repos/twof/FlaskOnAWS/contents/{+path}",
//        "compare_url": "https://api.github.com/repos/twof/FlaskOnAWS/compare/{base}...{head}",
//        "merges_url": "https://api.github.com/repos/twof/FlaskOnAWS/merges",
//        "archive_url": "https://api.github.com/repos/twof/FlaskOnAWS/{archive_format}{/ref}",
//        "downloads_url": "https://api.github.com/repos/twof/FlaskOnAWS/downloads",
//        "issues_url": "https://api.github.com/repos/twof/FlaskOnAWS/issues{/number}",
//        "pulls_url": "https://api.github.com/repos/twof/FlaskOnAWS/pulls{/number}",
//        "milestones_url": "https://api.github.com/repos/twof/FlaskOnAWS/milestones{/number}",
//        "notifications_url": "https://api.github.com/repos/twof/FlaskOnAWS/notifications{?since,all,participating}",
//        "labels_url": "https://api.github.com/repos/twof/FlaskOnAWS/labels{/name}",
//        "releases_url": "https://api.github.com/repos/twof/FlaskOnAWS/releases{/id}",
//        "deployments_url": "https://api.github.com/repos/twof/FlaskOnAWS/deployments",
//        "created_at": "2018-11-21T01:45:01Z",
//        "updated_at": "2018-11-24T04:48:57Z",
//        "pushed_at": "2019-02-20T20:47:53Z",
//        "git_url": "git://github.com/twof/FlaskOnAWS.git",
//        "ssh_url": "git@github.com:twof/FlaskOnAWS.git",
//        "clone_url": "https://github.com/twof/FlaskOnAWS.git",
//        "svn_url": "https://github.com/twof/FlaskOnAWS",
//        "homepage": null,
//        "size": 10038,
//        "stargazers_count": 0,
//        "watchers_count": 0,
//        "language": "Python",
//        "has_issues": true,
//        "has_projects": true,
//        "has_downloads": true,
//        "has_wiki": true,
//        "has_pages": false,
//        "forks_count": 1,
//        "mirror_url": null,
//        "archived": false,
//        "open_issues_count": 1,
//        "license": null,
//        "forks": 1,
//        "open_issues": 1,
//        "watchers": 0,
//        "default_branch": "master"
//    },
//    "sender": {
//        "login": "twof",
//        "id": 5561501,
//        "node_id": "MDQ6VXNlcjU1NjE1MDE=",
//        "avatar_url": "https://avatars2.githubusercontent.com/u/5561501?v=4",
//        "gravatar_id": "",
//        "url": "https://api.github.com/users/twof",
//        "html_url": "https://github.com/twof",
//        "followers_url": "https://api.github.com/users/twof/followers",
//        "following_url": "https://api.github.com/users/twof/following{/other_user}",
//        "gists_url": "https://api.github.com/users/twof/gists{/gist_id}",
//        "starred_url": "https://api.github.com/users/twof/starred{/owner}{/repo}",
//        "subscriptions_url": "https://api.github.com/users/twof/subscriptions",
//        "organizations_url": "https://api.github.com/users/twof/orgs",
//        "repos_url": "https://api.github.com/users/twof/repos",
//        "events_url": "https://api.github.com/users/twof/events{/privacy}",
//        "received_events_url": "https://api.github.com/users/twof/received_events",
//        "type": "User",
//        "site_admin": false
//    }
//}

struct GithubWebhook: Content {
    let comment: GithubComment?
    let repository: GithubRepository
    let issue: GithubIssue
    
    
    enum CodingKeys: String, CodingKey {
        case comment
        case repository
        case issue
    }
}
