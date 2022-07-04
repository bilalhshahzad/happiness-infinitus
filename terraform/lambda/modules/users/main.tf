data "local_file" "this" {
  filename = "${path.module}/pgp/public-key.gpg"
}

resource "aws_iam_user" "this" {
    name = var.user_name
    path = "/usr${var.namespace}"
}

resource "aws_iam_user_login_profile" "this" {
  user                    = aws_iam_user.this.name
  pgp_key                 = data.local_file.this.content_base64
  password_reset_required = true
}

resource "aws_iam_group" "this" {
    name = "${var.random_pet_id}-s3-${var.policy}-group"
    path = "/group${var.namespace}"
}

resource "aws_iam_group_membership" "this" {
    name = "${var.random_pet_id}-s3-${var.policy}-membership"
    users = [
        aws_iam_user.this.name,
    ]
    group = aws_iam_group.this.name
}

resource "aws_iam_group_policy" "this" {
    name = "${var.random_pet_id}-s3-${var.policy}-policy"
    group = aws_iam_group.this.id
    policy = templatefile("${path.module}/policy/${var.policy}.json.tpl", {
      bucekt_name = var.bucekt_name
    })
}