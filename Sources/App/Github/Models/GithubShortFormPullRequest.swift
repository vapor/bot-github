import Vapor

public struct GithubShortFormPullRequest: Content {
    public let url: URL
    //       "pull_request": {
    //            "url": "https://api.github.com/repos/twof/FlaskOnAWS/pulls/3",
    //            "html_url": "https://github.com/twof/FlaskOnAWS/pull/3",
    //            "diff_url": "https://github.com/twof/FlaskOnAWS/pull/3.diff",
    //            "patch_url": "https://github.com/twof/FlaskOnAWS/pull/3.patch"
    //        }
}
