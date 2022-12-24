data "terraform_remote_state" "cluster" {
  backend = "s3"
  config = {
    bucket         = "israel-terraform"
    key            = "cluster.tfstate"
    region         = "us-east-1"
    dynamodb_table = "israel-dynamo-terraform"
  }
}
