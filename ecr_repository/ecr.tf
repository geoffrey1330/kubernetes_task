resource "aws_ecr_repository" "main_ecr" {
  name                 = "${var.env_code}-main-ecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
