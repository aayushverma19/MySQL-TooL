 terraform {
   backend "s3" {
     bucket         = "final-tool-ninja-batch28"
     key            = "east.tfstate"
     region         = "us-east-1"
     dynamodb_table = "terraform-lock"
     encrypt        = true
   }
}
