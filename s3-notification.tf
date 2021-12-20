

resource "aws_s3_bucket" "altais-s3-bucket" {
  bucket = "altais-s3-bucket"
  acl    = "private"

  tags = {
    Name        = "altais-s3-bucket"
    Environment = "Dev"
  }
}


resource "aws_sqs_queue" "this" {
  name = "altais-s3-event-queue"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "arn:aws:sqs:*:*:altais-s3-event-queue",
      "Condition": {
        "ArnEquals": { "aws:SourceArn": "${aws_s3_bucket.altais-s3-bucket.arn}" }
      }
    }
  ]
}
POLICY
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.altais-s3-bucket.id

  queue {
    queue_arn     = aws_sqs_queue.this.arn
    events        = ["s3:ObjectCreated:*"]
  }
}


#Upload one file to s3
resource "aws_s3_bucket_object" "object" {
  bucket = aws_s3_bucket.altais-s3-bucket.id
  key    = "altias-test-file.txt"
  source = "s3file/altias-test-file.txt"
  etag = filemd5("s3file/altias-test-file.txt")
}
