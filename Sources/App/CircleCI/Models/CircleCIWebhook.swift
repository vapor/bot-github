import Vapor

fileprivate struct BuildParameters: Content {
    let circleJob: String
    
    enum CodingKeys: String, CodingKey {
        case circleJob = "CIRCLE_JOB"
    }
}

public struct CircleCIWebhookBackingPayload: Content {
    fileprivate let buildParams: BuildParameters
    
    let buildNumber: Int
    let reponame: String
    let username: String
    
    fileprivate enum CodingKeys: String, CodingKey {
        case buildNumber = "build_num"
        case reponame
        case username
        case buildParams = "build_parameters"
    }
}

public struct CircleCIWebhook: Content {
    public let payload: CircleCIWebhookBackingPayload
    
    public var buildNumber: Int {
        return payload.buildNumber
    }
    
    public var repoName: String {
        return payload.reponame
    }
    
    public var username: String {
        return payload.username
    }
    
    public var buildName: String {
        return payload.buildParams.circleJob
    }
}

//{
//    "payload": {
//        "compare": null,
//        "previous_successful_build": {
//            "build_num": 672,
//            "status": "success",
//            "build_time_millis": 34420
//        },
//        "build_parameters": {
//            "CIRCLE_JOB": "linux-performance"
//        },
//        "oss": true,
//        "all_commit_details_truncated": false,
//        "committer_date": "2019-02-24T00:36:33Z",
//        "steps": [
//        {
//        "name": "Spin up Environment",
//        "actions": [
//        {
//        "truncated": false,
//        "index": 0,
//        "parallel": true,
//        "failed": null,
//        "infrastructure_fail": null,
//        "name": "Spin up Environment",
//        "bash_command": null,
//        "status": "success",
//        "timedout": null,
//        "continue": null,
//        "end_time": "2019-02-25T09:46:03.680Z",
//        "type": "test",
//        "allocation_id": "5c73b93be6610100010050f6-0-build/4821011C",
//        "output_url": "https://circle-production-action-output.s3.amazonaws.com/eb16781000648411c39b37c5-1394d284-04d3-4628-bbe2-da90b333e171-0-0?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20190225T094614Z&X-Amz-SignedHeaders=host&X-Amz-Expires=431999&X-Amz-Credential=AKIAIQ65EYQDTMSJK2DQ%2F20190225%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Signature=2a983fdf90a705b3c766540299491ffa39aa70a3b87e21923e0935ffaeddd40b",
//        "start_time": "2019-02-25T09:45:32.801Z",
//        "background": false,
//        "exit_code": null,
//        "insignificant": false,
//        "canceled": null,
//        "step": 0,
//        "run_time_millis": 30879,
//        "has_output": true
//        }
//        ]
//        },
//        {
//        "name": "Checkout code",
//        "actions": [
//        {
//        "truncated": false,
//        "index": 0,
//        "parallel": true,
//        "failed": null,
//        "infrastructure_fail": null,
//        "name": "Checkout code",
//        "bash_command": "#!/bin/sh\nset -e\n\n# Workaround old docker images with incorrect $HOME\n# check https://github.com/docker/docker/issues/2968 for details\nif [ \"${HOME}\" = \"/\" ]\nthen\n  export HOME=$(getent passwd $(id -un) | cut -d: -f6)\nfi\n\nmkdir -p ~/.ssh\n\necho 'github.com ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==\nbitbucket.org ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAubiN81eDcafrgMeLzaFPsw2kNvEcqTKl/VqLat/MaB33pZy0y3rJZtnqwR2qOOvbwKZYKiEO1O6VqNEBxKvJJelCq0dTXWT5pbO2gDXC6h6QDXCaHo6pOHGPUy+YBaGQRGuSusMEASYiWunYN0vCAI8QaXnWMXNMdFP3jHAJH0eDsoiGnLPBlBp4TNm6rYI74nMzgz3B9IikW4WVK+dc8KZJZWYjAuORU3jc1c/NPskD2ASinf8v3xnfXeukU0sJ5N6m5E8VLjObPEO+mN2t/FZTMZLiFqPWc/ALSqnMnnhwrNi2rbfg/rd/IpL8Le3pSBne8+seeFVBoGqzHM9yXw==\n' >> ~/.ssh/known_hosts\n\n(umask 077; touch ~/.ssh/id_rsa)\nchmod 0600 ~/.ssh/id_rsa\n(cat <<EOF > ~/.ssh/id_rsa\n$CHECKOUT_KEY\nEOF\n)\n\n# use git+ssh instead of https\ngit config --global url.\"ssh://git@github.com\".insteadOf \"https://github.com\" || true\ngit config --global gc.auto 0 || true\n\nif [ -e /root/project/.git ]\nthen\n  cd /root/project\n  git remote set-url origin \"$CIRCLE_REPOSITORY_URL\" || true\nelse\n  mkdir -p /root/project\n  cd /root/project\n  git clone \"$CIRCLE_REPOSITORY_URL\" .\nfi\n\nif [ -n \"$CIRCLE_TAG\" ]\nthen\n  git fetch --force origin \"refs/tags/${CIRCLE_TAG}\"\nelse\n  git fetch --force origin \"botTesting:remotes/origin/botTesting\"\nfi\n\n\nif [ -n \"$CIRCLE_TAG\" ]\nthen\n  git reset --hard \"$CIRCLE_SHA1\"\n  git checkout -q \"$CIRCLE_TAG\"\nelif [ -n \"$CIRCLE_BRANCH\" ]\nthen\n  git reset --hard \"$CIRCLE_SHA1\"\n  git checkout -q -B \"$CIRCLE_BRANCH\"\nfi\n\ngit reset --hard \"$CIRCLE_SHA1\"",
//        "status": "success",
//        "timedout": null,
//        "continue": null,
//        "end_time": "2019-02-25T09:46:07.497Z",
//        "type": "test",
//        "allocation_id": "5c73b93be6610100010050f6-0-build/4821011C",
//        "output_url": "https://circle-production-action-output.s3.amazonaws.com/3326781000648411b59b37c5-1394d284-04d3-4628-bbe2-da90b333e171-101-0?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20190225T094614Z&X-Amz-SignedHeaders=host&X-Amz-Expires=431999&X-Amz-Credential=AKIAIQ65EYQDTMSJK2DQ%2F20190225%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Signature=d26730c88a8988d7c51ab09fb7ea9eebb8f3d24a4a0db917b76b9f2810544bca",
//        "start_time": "2019-02-25T09:46:03.770Z",
//        "background": false,
//        "exit_code": 0,
//        "insignificant": false,
//        "canceled": null,
//        "step": 101,
//        "run_time_millis": 3727,
//        "has_output": true
//        }
//        ]
//        },
//        {
//        "name": "swift test",
//        "actions": [
//        {
//        "truncated": false,
//        "index": 0,
//        "parallel": true,
//        "failed": null,
//        "infrastructure_fail": null,
//        "name": "swift test",
//        "bash_command": "#!/bin/bash -eo pipefail\nswift test -c release --filter \"RoutingKitTests.RouterPerformanceTests\"",
//        "status": "success",
//        "timedout": null,
//        "continue": null,
//        "end_time": "2019-02-25T09:46:14.517Z",
//        "type": "test",
//        "allocation_id": "5c73b93be6610100010050f6-0-build/4821011C",
//        "start_time": "2019-02-25T09:46:07.503Z",
//        "background": false,
//        "exit_code": 0,
//        "insignificant": false,
//        "canceled": null,
//        "step": 102,
//        "run_time_millis": 7014,
//        "has_output": true
//        }
//        ]
//        }
//        ],
//        "body": "",
//        "usage_queued_at": "2019-02-25T09:45:31.458Z",
//        "fail_reason": null,
//        "retry_of": null,
//        "reponame": "routing",
//        "ssh_users": [],
//        "build_url": "https://circleci.com/gh/vapor/routing/673",
//        "parallel": 1,
//        "failed": false,
//        "branch": "botTesting",
//        "username": "vapor",
//        "author_date": "2019-02-24T00:36:33Z",
//        "why": "api",
//        "user": {
//            "is_user": true,
//            "login": "twof",
//            "avatar_url": "https://avatars2.githubusercontent.com/u/5561501?v=4",
//            "name": "Alex Reilly",
//            "vcs_type": "github",
//            "id": 5561501
//        },
//        "vcs_revision": "01e3a1e6e0892f2d9de04f3f1fe0f869dd071cf8",
//        "owners": [
//        "twof"
//        ],
//        "vcs_tag": null,
//        "pull_requests": [
//        {
//        "head_sha": "01e3a1e6e0892f2d9de04f3f1fe0f869dd071cf8",
//        "url": "https://github.com/vapor/routing/pull/66"
//        }
//        ],
//        "build_num": 673,
//        "infrastructure_fail": false,
//        "committer_email": "fabiobean2@gmail.com",
//        "has_artifacts": true,
//        "previous": {
//            "build_num": 672,
//            "status": "success",
//            "build_time_millis": 34420
//        },
//        "status": "success",
//        "committer_name": "twof",
//        "retries": null,
//        "subject": "update with testing url",
//        "vcs_type": "github",
//        "timedout": false,
//        "dont_build": null,
//        "lifecycle": "finished",
//        "no_dependency_cache": false,
//        "stop_time": "2019-02-25T09:46:14.526Z",
//        "ssh_disabled": true,
//        "build_time_millis": 41764,
//        "picard": {
//            "build_agent": {
//                "image": "circleci/picard:1.0.7981-23afa854",
//                "properties": {
//                    "build_agent": "1.0.7981-23afa854",
//                    "executor": "docker"
//                }
//            },
//            "resource_class": {
//                "cpu": 2,
//                "ram": 4096,
//                "class": "medium"
//            },
//            "executor": "docker"
//        },
//        "circle_yml": {
//            "string": "version: 2\n\njobs:\n  linux:\n    docker:\n      - image: vapor/swift:5.0\n    steps:\n      - checkout\n      - run: swift build\n      - run:\n          name: swift test\n          command: swift test --filter \"RountingKitTests.RouterTests\"\n  linux-release:\n    docker:\n      - image: vapor/swift:5.0\n    steps:\n      - checkout\n      - run: swift build -c release\n  linux-performance:\n    docker:\n      - image: vapor/swift:5.0\n    steps:\n      - checkout\n      - run:\n          name: swift test\n          command: swift test -c release --filter \"RoutingKitTests.RouterPerformanceTests\"\n\nworkflows:\n  version: 2\n  tests:\n    jobs:\n      - linux\n      - linux-release\nnotify:\n  webhooks:\n    - url: https://6a4b8e77.ngrok.io/circle\n"
//        },
//        "messages": [],
//        "is_first_green_build": false,
//        "job_name": null,
//        "start_time": "2019-02-25T09:45:32.762Z",
//        "canceler": null,
//        "all_commit_details": [
//        {
//        "committer_date": "2019-02-24T00:36:33Z",
//        "body": "",
//        "author_date": "2019-02-24T00:36:33Z",
//        "committer_email": "fabiobean2@gmail.com",
//        "commit": "01e3a1e6e0892f2d9de04f3f1fe0f869dd071cf8",
//        "committer_login": "twof",
//        "committer_name": "twof",
//        "subject": "update with testing url",
//        "commit_url": "https://github.com/vapor/routing/commit/01e3a1e6e0892f2d9de04f3f1fe0f869dd071cf8",
//        "author_login": "twof",
//        "author_name": "twof",
//        "author_email": "fabiobean2@gmail.com"
//        }
//        ],
//        "platform": "2.0",
//        "outcome": "success",
//        "vcs_url": "https://github.com/vapor/routing",
//        "author_name": "twof",
//        "node": null,
//        "queued_at": "2019-02-25T09:45:31.490Z",
//        "canceled": false,
//        "author_email": "fabiobean2@gmail.com"
//    }
//}
