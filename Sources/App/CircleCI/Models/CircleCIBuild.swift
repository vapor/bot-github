import Vapor

fileprivate struct BuildParameters: Content {
    let circleJob: String
    
    enum CodingKeys: String, CodingKey {
        case circleJob = "CIRCLE_JOB"
    }
}

public struct CircleCIBuild: Content {
    private let buildParams: BuildParameters
    
    public let steps: [CircleCIBuildStep]
    public let pullRequests: [CircleCIPullRequest]
    public var job: String {
        return self.buildParams.circleJob
    }
    
    
    enum CodingKeys: String, CodingKey {
        case buildParams = "build_parameters"
        case steps
        case pullRequests = "pull_requests"
    }
    //{
    //    "compare" : null,
    //    "previous_successful_build" : {
    //        "build_num" : 14,
    //        "status" : "success",
    //        "build_time_millis" : 6370
    //    },
    //    "build_parameters" : {
    //        "CIRCLE_JOB" : "build"
    //    },
    //    "oss" : true,
    //    "all_commit_details_truncated" : false,
    //    "committer_date" : "2019-02-20T21:00:10-08:00",
    //    "steps" : [ {
    //    "name" : "Spin up Environment",
    //    "actions" : [ {
    //    "truncated" : false,
    //    "index" : 0,
    //    "parallel" : true,
    //    "failed" : null,
    //    "infrastructure_fail" : null,
    //    "name" : "Spin up Environment",
    //    "bash_command" : null,
    //    "status" : "success",
    //    "timedout" : null,
    //    "continue" : null,
    //    "end_time" : "2019-02-21T05:00:24.850Z",
    //    "type" : "test",
    //    "allocation_id" : "5c6e3066ef85e30008129e7b-0-build/6A2BBF41",
    //    "output_url" : "https://circle-production-action-output.s3.amazonaws.com/ad3b581000291b6d7603e6c5-9d696e9c-958f-40a3-9ce4-b75c5a7b1768-0-0?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20190221T050149Z&X-Amz-SignedHeaders=host&X-Amz-Expires=431999&X-Amz-Credential=AKIAIJNI6FA5RIAFFQ7Q%2F20190221%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Signature=01c9c6f1a664935dab24b37375bc936f81d02683a7092d0f17a5059941832615",
    //    "start_time" : "2019-02-21T05:00:23.688Z",
    //    "background" : false,
    //    "exit_code" : null,
    //    "insignificant" : false,
    //    "canceled" : null,
    //    "step" : 0,
    //    "run_time_millis" : 1162,
    //    "has_output" : true
    //    } ]
    //    }, {
    //    "name" : "Checkout code",
    //    "actions" : [ {
    //    "truncated" : false,
    //    "index" : 0,
    //    "parallel" : true,
    //    "failed" : null,
    //    "infrastructure_fail" : null,
    //    "name" : "Checkout code",
    //    "bash_command" : "#!/bin/sh\nset -e\n\n# Workaround old docker images with incorrect $HOME\n# check https://github.com/docker/docker/issues/2968 for details\nif [ \"${HOME}\" = \"/\" ]\nthen\n  export HOME=$(getent passwd $(id -un) | cut -d: -f6)\nfi\n\nmkdir -p ~/.ssh\n\necho 'github.com ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==\nbitbucket.org ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAubiN81eDcafrgMeLzaFPsw2kNvEcqTKl/VqLat/MaB33pZy0y3rJZtnqwR2qOOvbwKZYKiEO1O6VqNEBxKvJJelCq0dTXWT5pbO2gDXC6h6QDXCaHo6pOHGPUy+YBaGQRGuSusMEASYiWunYN0vCAI8QaXnWMXNMdFP3jHAJH0eDsoiGnLPBlBp4TNm6rYI74nMzgz3B9IikW4WVK+dc8KZJZWYjAuORU3jc1c/NPskD2ASinf8v3xnfXeukU0sJ5N6m5E8VLjObPEO+mN2t/FZTMZLiFqPWc/ALSqnMnnhwrNi2rbfg/rd/IpL8Le3pSBne8+seeFVBoGqzHM9yXw==\n' >> ~/.ssh/known_hosts\n\n(umask 077; touch ~/.ssh/id_rsa)\nchmod 0600 ~/.ssh/id_rsa\n(cat <<EOF > ~/.ssh/id_rsa\n$CHECKOUT_KEY\nEOF\n)\n\n# use git+ssh instead of https\ngit config --global url.\"ssh://git@github.com\".insteadOf \"https://github.com\" || true\ngit config --global gc.auto 0 || true\n\nif [ -e /home/circleci/repo/.git ]\nthen\n  cd /home/circleci/repo\n  git remote set-url origin \"$CIRCLE_REPOSITORY_URL\" || true\nelse\n  mkdir -p /home/circleci/repo\n  cd /home/circleci/repo\n  git clone \"$CIRCLE_REPOSITORY_URL\" .\nfi\n\nif [ -n \"$CIRCLE_TAG\" ]\nthen\n  git fetch --force origin \"refs/tags/${CIRCLE_TAG}\"\nelse\n  git fetch --force origin \"twof-patch-1:remotes/origin/twof-patch-1\"\nfi\n\n\nif [ -n \"$CIRCLE_TAG\" ]\nthen\n  git reset --hard \"$CIRCLE_SHA1\"\n  git checkout -q \"$CIRCLE_TAG\"\nelif [ -n \"$CIRCLE_BRANCH\" ]\nthen\n  git reset --hard \"$CIRCLE_SHA1\"\n  git checkout -q -B \"$CIRCLE_BRANCH\"\nfi\n\ngit reset --hard \"$CIRCLE_SHA1\"",
    //    "status" : "success",
    //    "timedout" : null,
    //    "continue" : null,
    //    "end_time" : "2019-02-21T05:00:25.727Z",
    //    "type" : "test",
    //    "allocation_id" : "5c6e3066ef85e30008129e7b-0-build/6A2BBF41",
    //    "output_url" : "https://circle-production-action-output.s3.amazonaws.com/0e3b581000291b6d8603e6c5-9d696e9c-958f-40a3-9ce4-b75c5a7b1768-101-0?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20190221T050149Z&X-Amz-SignedHeaders=host&X-Amz-Expires=431999&X-Amz-Credential=AKIAIJNI6FA5RIAFFQ7Q%2F20190221%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Signature=16b90aabd4bf4f88ae57134a17e451b05fcf23c724f650eff0e245516d8ef7ff",
    //    "start_time" : "2019-02-21T05:00:24.907Z",
    //    "background" : false,
    //    "exit_code" : 0,
    //    "insignificant" : false,
    //    "canceled" : null,
    //    "step" : 101,
    //    "run_time_millis" : 820,
    //    "has_output" : true
    //    } ]
    //    }, {
    //    "name" : "Restoring Cache",
    //    "actions" : [ {
    //    "truncated" : false,
    //    "index" : 0,
    //    "parallel" : true,
    //    "failed" : null,
    //    "infrastructure_fail" : null,
    //    "name" : "Restoring Cache",
    //    "bash_command" : null,
    //    "status" : "success",
    //    "timedout" : null,
    //    "continue" : null,
    //    "end_time" : "2019-02-21T05:00:26.716Z",
    //    "type" : "test",
    //    "allocation_id" : "5c6e3066ef85e30008129e7b-0-build/6A2BBF41",
    //    "output_url" : "https://circle-production-action-output.s3.amazonaws.com/1e3b581000291b6d9603e6c5-9d696e9c-958f-40a3-9ce4-b75c5a7b1768-102-0?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20190221T050149Z&X-Amz-SignedHeaders=host&X-Amz-Expires=431999&X-Amz-Credential=AKIAIJNI6FA5RIAFFQ7Q%2F20190221%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Signature=bce3a4b4bee2820a68a4df18cb0ea0d997001efbb2325d8149a7903ff1f7989a",
    //    "start_time" : "2019-02-21T05:00:25.732Z",
    //    "background" : false,
    //    "exit_code" : null,
    //    "insignificant" : false,
    //    "canceled" : null,
    //    "step" : 102,
    //    "run_time_millis" : 984,
    //    "has_output" : true
    //    } ]
    //    }, {
    //    "name" : "install dependencies",
    //    "actions" : [ {
    //    "truncated" : false,
    //    "index" : 0,
    //    "parallel" : true,
    //    "failed" : null,
    //    "infrastructure_fail" : null,
    //    "name" : "install dependencies",
    //    "bash_command" : "#!/bin/bash -eo pipefail\npython3 -m venv venv\n. venv/bin/activate\npip install -r requirements.txt\n",
    //    "status" : "success",
    //    "timedout" : null,
    //    "continue" : null,
    //    "end_time" : "2019-02-21T05:00:28.645Z",
    //    "type" : "test",
    //    "allocation_id" : "5c6e3066ef85e30008129e7b-0-build/6A2BBF41",
    //    "output_url" : "https://circle-production-action-output.s3.amazonaws.com/4e3b581000291b6da603e6c5-9d696e9c-958f-40a3-9ce4-b75c5a7b1768-103-0?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20190221T050149Z&X-Amz-SignedHeaders=host&X-Amz-Expires=431999&X-Amz-Credential=AKIAIJNI6FA5RIAFFQ7Q%2F20190221%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Signature=e376ff966653e71b16157cd6a8635259a58f52d7ee89f890e4dafa105da52d1c",
    //    "start_time" : "2019-02-21T05:00:26.721Z",
    //    "background" : false,
    //    "exit_code" : 0,
    //    "insignificant" : false,
    //    "canceled" : null,
    //    "step" : 103,
    //    "run_time_millis" : 1924,
    //    "has_output" : true
    //    } ]
    //    }, {
    //    "name" : "Saving Cache",
    //    "actions" : [ {
    //    "truncated" : false,
    //    "index" : 0,
    //    "parallel" : true,
    //    "failed" : null,
    //    "infrastructure_fail" : null,
    //    "name" : "Saving Cache",
    //    "bash_command" : null,
    //    "status" : "success",
    //    "timedout" : null,
    //    "continue" : null,
    //    "end_time" : "2019-02-21T05:00:28.665Z",
    //    "type" : "test",
    //    "allocation_id" : "5c6e3066ef85e30008129e7b-0-build/6A2BBF41",
    //    "output_url" : "https://circle-production-action-output.s3.amazonaws.com/9e3b581000291b6dc603e6c5-9d696e9c-958f-40a3-9ce4-b75c5a7b1768-104-0?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20190221T050149Z&X-Amz-SignedHeaders=host&X-Amz-Expires=431999&X-Amz-Credential=AKIAIJNI6FA5RIAFFQ7Q%2F20190221%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Signature=1490dd6d87f54935abce912ac1c370676d343d40f77300f6c3af0909e9d2330e",
    //    "start_time" : "2019-02-21T05:00:28.649Z",
    //    "background" : false,
    //    "exit_code" : null,
    //    "insignificant" : false,
    //    "canceled" : null,
    //    "step" : 104,
    //    "run_time_millis" : 16,
    //    "has_output" : true
    //    } ]
    //    }, {
    //    "name" : "run tests",
    //    "actions" : [ {
    //    "truncated" : false,
    //    "index" : 0,
    //    "parallel" : true,
    //    "failed" : null,
    //    "infrastructure_fail" : null,
    //    "name" : "run tests",
    //    "bash_command" : "#!/bin/bash -eo pipefail\n. venv/bin/activate\npython manage.py test\n",
    //    "status" : "success",
    //    "timedout" : null,
    //    "continue" : null,
    //    "end_time" : "2019-02-21T05:00:29.297Z",
    //    "type" : "test",
    //    "allocation_id" : "5c6e3066ef85e30008129e7b-0-build/6A2BBF41",
    //    "start_time" : "2019-02-21T05:00:28.669Z",
    //    "background" : false,
    //    "exit_code" : 0,
    //    "insignificant" : false,
    //    "canceled" : null,
    //    "step" : 105,
    //    "run_time_millis" : 628,
    //    "has_output" : false
    //    } ]
    //    }, {
    //    "name" : "Uploading artifacts",
    //    "actions" : [ {
    //    "truncated" : false,
    //    "index" : 0,
    //    "parallel" : true,
    //    "failed" : null,
    //    "infrastructure_fail" : null,
    //    "name" : "Uploading artifacts",
    //    "bash_command" : null,
    //    "status" : "success",
    //    "timedout" : null,
    //    "continue" : null,
    //    "end_time" : "2019-02-21T05:00:29.318Z",
    //    "type" : "test",
    //    "allocation_id" : "5c6e3066ef85e30008129e7b-0-build/6A2BBF41",
    //    "output_url" : "https://circle-production-action-output.s3.amazonaws.com/fe3b581000291b6dd603e6c5-9d696e9c-958f-40a3-9ce4-b75c5a7b1768-106-0?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20190221T050149Z&X-Amz-SignedHeaders=host&X-Amz-Expires=431999&X-Amz-Credential=AKIAIJNI6FA5RIAFFQ7Q%2F20190221%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Signature=619081678229a69fb4f67f372030ffa21f7071a445e40b18d104f29072c4ef22",
    //    "start_time" : "2019-02-21T05:00:29.305Z",
    //    "background" : false,
    //    "exit_code" : null,
    //    "insignificant" : false,
    //    "canceled" : null,
    //    "step" : 106,
    //    "run_time_millis" : 13,
    //    "has_output" : true
    //    } ]
    //    } ],
    //    "body" : "",
    //    "usage_queued_at" : "2019-02-21T05:00:22.612Z",
    //    "context_ids" : [ ],
    //    "fail_reason" : null,
    //    "retry_of" : null,
    //    "reponame" : "FlaskOnAWS",
    //    "ssh_users" : [ ],
    //    "build_url" : "https://circleci.com/gh/twof/FlaskOnAWS/15",
    //    "parallel" : 1,
    //    "failed" : false,
    //    "branch" : "twof-patch-1",
    //    "username" : "twof",
    //    "author_date" : "2019-02-20T21:00:10-08:00",
    //    "why" : "github",
    //    "user" : {
    //        "is_user" : true,
    //        "login" : "twof",
    //        "avatar_url" : "https://avatars2.githubusercontent.com/u/5561501?v=4",
    //        "name" : "Alex Reilly",
    //        "vcs_type" : "github",
    //        "id" : 5561501
    //    },
    //    "vcs_revision" : "7315fde145deb78c44c588399fa806c5b8a32eb7",
    //    "workflows" : {
    //        "job_name" : "build",
    //        "job_id" : "c493c92b-e55e-4350-87fa-e6a6877fe910",
    //        "workflow_id" : "c29de484-a2fa-48e7-88f1-29d0f7292daa",
    //        "workspace_id" : "c29de484-a2fa-48e7-88f1-29d0f7292daa",
    //        "upstream_job_ids" : [ ],
    //        "upstream_concurrency_map" : { },
    //        "workflow_name" : "workflow"
    //    },
    //    "owners" : [ "twof" ],
    //    "vcs_tag" : null,
    //    "pull_requests" : [ {
    //    "head_sha" : "7315fde145deb78c44c588399fa806c5b8a32eb7",
    //    "url" : "https://github.com/twof/FlaskOnAWS/pull/3"
    //    } ],
    //    "build_num" : 15,
    //    "infrastructure_fail" : false,
    //    "committer_email" : "fabiobean2@gmail.com",
    //    "has_artifacts" : true,
    //    "previous" : {
    //        "build_num" : 14,
    //        "status" : "success",
    //        "build_time_millis" : 6370
    //    },
    //    "status" : "success",
    //    "committer_name" : "twof",
    //    "retries" : null,
    //    "subject" : "Merge branch 'twof-patch-1' of https://github.com/twof/FlaskOnAWS into twof-patch-1",
    //    "vcs_type" : "github",
    //    "timedout" : false,
    //    "dont_build" : null,
    //    "lifecycle" : "finished",
    //    "no_dependency_cache" : false,
    //    "stop_time" : "2019-02-21T05:00:29.326Z",
    //    "ssh_disabled" : true,
    //    "build_time_millis" : 5672,
    //    "picard" : {
    //        "build_agent" : {
    //            "image" : "circleci/picard:1.0.7981-23afa854",
    //            "properties" : {
    //                "build_agent" : "1.0.7981-23afa854",
    //                "executor" : "docker"
    //            }
    //        },
    //        "resource_class" : {
    //            "cpu" : 2.0,
    //            "ram" : 4096,
    //            "class" : "medium"
    //        },
    //        "executor" : "docker"
    //    },
    //    "circle_yml" : {
    //        "string" : "version: 2\njobs:\n  build:\n    docker:\n    - image: circleci/python:3.6.1\n    working_directory: ~/repo\n    steps:\n    - checkout\n    - restore_cache:\n        keys:\n        - v1-dependencies-{{ checksum \"requirements.txt\" }}\n        - v1-dependencies-\n    - run:\n        name: install dependencies\n        command: |\n          python3 -m venv venv\n          . venv/bin/activate\n          pip install -r requirements.txt\n    - save_cache:\n        paths:\n        - ./venv\n        key: v1-dependencies-{{ checksum \"requirements.txt\" }}\n    - run:\n        name: run tests\n        command: |\n          . venv/bin/activate\n          python manage.py test\n    - store_artifacts:\n        path: test-reports\n        destination: test-reports\nnotify:\n  webhooks:\n  - url: https://6a4b8e77.ngrok.io/circle\nworkflows:\n  version: 2\n  workflow:\n    jobs:\n    - build\n"
    //    },
    //    "messages" : [ ],
    //    "is_first_green_build" : false,
    //    "job_name" : null,
    //    "start_time" : "2019-02-21T05:00:23.654Z",
    //    "canceler" : null,
    //    "all_commit_details" : [ {
    //    "committer_date" : "2019-02-20T21:00:00-08:00",
    //    "body" : "",
    //    "branch" : "twof-patch-1",
    //    "author_date" : "2019-02-20T21:00:00-08:00",
    //    "committer_email" : "fabiobean2@gmail.com",
    //    "commit" : "e81f62951a8bbfd73ecb1302d57346c84767a08a",
    //    "committer_login" : "twof",
    //    "committer_name" : "twof",
    //    "subject" : "merged master",
    //    "commit_url" : "https://github.com/twof/FlaskOnAWS/commit/e81f62951a8bbfd73ecb1302d57346c84767a08a",
    //    "author_login" : "twof",
    //    "author_name" : "twof",
    //    "author_email" : "fabiobean2@gmail.com"
    //    }, {
    //    "committer_date" : "2019-02-20T21:00:10-08:00",
    //    "body" : "",
    //    "branch" : "twof-patch-1",
    //    "author_date" : "2019-02-20T21:00:10-08:00",
    //    "committer_email" : "fabiobean2@gmail.com",
    //    "commit" : "7315fde145deb78c44c588399fa806c5b8a32eb7",
    //    "committer_login" : "twof",
    //    "committer_name" : "twof",
    //    "subject" : "Merge branch 'twof-patch-1' of https://github.com/twof/FlaskOnAWS into twof-patch-1",
    //    "commit_url" : "https://github.com/twof/FlaskOnAWS/commit/7315fde145deb78c44c588399fa806c5b8a32eb7",
    //    "author_login" : "twof",
    //    "author_name" : "twof",
    //    "author_email" : "fabiobean2@gmail.com"
    //    } ],
    //    "platform" : "2.0",
    //    "outcome" : "success",
    //    "vcs_url" : "https://github.com/twof/FlaskOnAWS",
    //    "author_name" : "twof",
    //    "node" : null,
    //    "queued_at" : "2019-02-21T05:00:22.728Z",
    //    "canceled" : false,
    //    "author_email" : "fabiobean2@gmail.com"
    //}

}


