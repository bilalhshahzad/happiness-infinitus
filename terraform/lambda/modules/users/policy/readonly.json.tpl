${jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:ListBucket",
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::${bucekt_name}",
        "arn:aws:s3:::${bucekt_name}/*"
      ]
    }
  ]
})}