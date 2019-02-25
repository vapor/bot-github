import Vapor

public struct CircleCIRunJobResult: Content {
    public let buildNumber: Int
    
    enum CodingKeys: String, CodingKey {
        case buildNumber = "build_num"
    }
    //{
    //    "compare" : null,
    //    "previous_successful_build" : {
    //        "build_num" : 625,
    //        "status" : "success",
    //        "build_time_millis" : 71403
    //    },
    //    "build_parameters" : {
    //        "CIRCLE_JOB" : "linux-performance"
    //    },
    //    "oss" : true,
    //    "all_commit_details_truncated" : false,
    //    "committer_date" : "2019-02-21T23:09:32Z",
    //    "body" : "",
    //    "usage_queued_at" : "2019-02-22T03:25:48.212Z",
    //    "fail_reason" : null,
    //    "retry_of" : null,
    //    "reponame" : "routing",
    //    "ssh_users" : [ ],
    //    "build_url" : "https://circleci.com/gh/vapor/routing/626",
    //    "parallel" : 1,
    //    "failed" : null,
    //    "branch" : "circleWebhook",
    //    "username" : "vapor",
    //    "author_date" : "2019-02-21T23:09:32Z",
    //    "why" : "api",
    //    "user" : {
    //        "is_user" : true,
    //        "login" : "twof",
    //        "avatar_url" : "https://avatars2.githubusercontent.com/u/5561501?v=4",
    //        "name" : "Alex Reilly",
    //        "vcs_type" : "github",
    //        "id" : 5561501
    //    },
    //    "vcs_revision" : "af183d9278874861d3b82f437a8d4d2eabb061e2",
    //    "vcs_tag" : null,
    //    "build_num" : 626,
    //    "infrastructure_fail" : false,
    //    "committer_email" : "fabiobean2@gmail.com",
    //    "previous" : {
    //        "build_num" : 625,
    //        "status" : "success",
    //        "build_time_millis" : 71403
    //    },
    //    "status" : "not_running",
    //    "committer_name" : "twof",
    //    "retries" : null,
    //    "subject" : "cleanup",
    //    "vcs_type" : "github",
    //    "timedout" : false,
    //    "dont_build" : null,
    //    "lifecycle" : "not_running",
    //    "no_dependency_cache" : false,
    //    "stop_time" : null,
    //    "ssh_disabled" : true,
    //    "build_time_millis" : null,
    //    "picard" : null,
    //    "circle_yml" : {
    //        "string" : "version: 2\n\njobs:\n  linux:\n    docker:\n      - image: vapor/swift:5.0\n    steps:\n      - checkout\n      - run: swift build\n      - run:\n          name: swift test\n          command: swift test --filter \"RountingKitTests.RouterTests\"\n  linux-release:\n    docker:\n      - image: vapor/swift:5.0\n    steps:\n      - checkout\n      - run: swift build -c release\n  linux-performance:\n    docker:\n      - image: vapor/swift:5.0\n    steps:\n      - checkout\n      - run:\n          name: swift test\n          command: swift test -c release --filter \"RoutingKitTests.RouterPerformanceTests\"\n\nworkflows:\n  version: 2\n  tests:\n    jobs:\n      - linux\n      - linux-release\n      - linux-performance\nnotify:\n  webhooks:\n    - url: https://6a4b8e77.ngrok.io/circle\n"
    //    },
    //    "messages" : [ ],
    //    "is_first_green_build" : false,
    //    "job_name" : null,
    //    "start_time" : null,
    //    "canceler" : null,
    //    "all_commit_details" : [ {
    //    "committer_date" : "2019-02-21T23:09:32Z",
    //    "body" : "",
    //    "author_date" : "2019-02-21T23:09:32Z",
    //    "committer_email" : "fabiobean2@gmail.com",
    //    "commit" : "af183d9278874861d3b82f437a8d4d2eabb061e2",
    //    "committer_login" : "twof",
    //    "committer_name" : "twof",
    //    "subject" : "cleanup",
    //    "commit_url" : "https://github.com/vapor/routing/commit/af183d9278874861d3b82f437a8d4d2eabb061e2",
    //    "author_login" : "twof",
    //    "author_name" : "twof",
    //    "author_email" : "fabiobean2@gmail.com"
    //    } ],
    //    "platform" : "2.0",
    //    "outcome" : null,
    //    "vcs_url" : "https://github.com/vapor/routing",
    //    "author_name" : "twof",
    //    "node" : null,
    //    "canceled" : false,
    //    "author_email" : "fabiobean2@gmail.com"
    //}

}
