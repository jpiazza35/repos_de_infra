resource "aws_iam_role" "workspaces" {
  name               = "workspaces_DefaultRole" ##Required name from AWS docs
  assume_role_policy = data.aws_iam_policy_document.workspaces.json

}

resource "aws_iam_role_policy_attachment" "workspaces-service-access" {
  role       = aws_iam_role.workspaces.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonWorkSpacesServiceAccess"

}

resource "aws_iam_role_policy_attachment" "workspaces-self-service-access" {
  role       = aws_iam_role.workspaces.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonWorkSpacesSelfServiceAccess"

}
