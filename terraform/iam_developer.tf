resource "aws_iam_user" "dev_view" {
  name = "bedrock-dev-view"
}

resource "aws_iam_user_policy_attachment" "readonly" {
  user       = aws_iam_user.dev_view.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# Grant PutObject for the Capstone S3 Bucket
resource "aws_iam_user_policy" "s3_upload" {
  name = "S3UploadAssets"
  user = aws_iam_user.dev_view.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = "s3:PutObject"
      Resource = "${aws_s3_bucket.assets.arn}/*"
    }]
  })
}