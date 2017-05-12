resource "aws_lambda_function" "ProcessQueueManager" {
 //  s3_bucket        = "commerce-sox-tpn-aut"
 //  s3_key           = "tuppence-account-updater-process-sqs-manager.jar"
  filename         = "single-module/target/single-module-project.jar"
  function_name    = "AUProcessSqsManager"
  role             = "arn:aws:iam::808571453214:role/service-role/TestRole" 
  handler          = "com.ancestry.tuppence.account_updater.ProcessSQSMessage::handleRequest"
  runtime          = "java8"
  memory_size      = "256"
  timeout          = "60"
  environment {
    variables = {
      AU_PROCESS_REQUEST_URL = "some-arn"
      AU_PROCESS_MESSAGE_LAMBDA_LIMIT =  "1"
      AU_PROCESS_MESSAGE_ITERATIONS_COUNT = "1"
    }
  }
// kms_key_arn = "${aws_kms_key.AuLambdaKMS.arn}"
}
