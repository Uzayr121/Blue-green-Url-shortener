resource "aws_dynamodb_table" "dynamodb_table" {
  name         = "blue-green-db"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"
  point_in_time_recovery {
    enabled = true
  }

  attribute {
    name = "id"
    type = "S"
  }

}