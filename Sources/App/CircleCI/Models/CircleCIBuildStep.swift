import Vapor

public struct CircleCIBuildStepAction: Content {
    public let outputURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case outputURL = "output_url"
    }
}

public struct CircleCIBuildStep: Content {
    public let name: String
    public let actions: [CircleCIBuildStepAction]
    //{
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
    //    "end_time" : "2019-02-21T02:35:26.064Z",
    //    "type" : "test",
    //    "allocation_id" : "5c6e0e53ae715e0009d6561b-0-build/7F7CA9BE",
    //    "output_url" : "https://circle-production-action-output.s3.amazonaws.com/7623ba10009d1d5255e0e6c5-1394d284-04d3-4628-bbe2-da90b333e171-0-0?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20190221T033712Z&X-Amz-SignedHeaders=host&X-Amz-Expires=431999&X-Amz-Credential=AKIAIJNI6FA5RIAFFQ7Q%2F20190221%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Signature=c71c9d1fbc8f21b1610ddd395f0364cd157fabffc9d99b8f68eeec31c1468c0f",
    //    "start_time" : "2019-02-21T02:35:01.055Z",
    //    "background" : false,
    //    "exit_code" : null,
    //    "insignificant" : false,
    //    "canceled" : null,
    //    "step" : 0,
    //    "run_time_millis" : 25009,
    //    "has_output" : true
    //}

}

