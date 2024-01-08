
resource "archive_file" "lambda_gen_pages" {
  output_path      = "/tmp/lambda_gen_pages.zip"
  output_file_mode = "0666"
  type             = "zip"
  source_dir       = "${path.module}/src/lambda_gen_pages"
}