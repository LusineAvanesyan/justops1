locals {
  content_types = {
    ".html" : "text/html",
    ".css" : "text/css",
    ".js" : "text/javascript"
  }
  cluster_name = "eks-${random_string.suffix.result}"
  name         = "aca-project"
}
