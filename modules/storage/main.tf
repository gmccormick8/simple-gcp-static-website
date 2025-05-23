resource "random_integer" "bucket_name_prefix" {
  min = 10000
  max = 9999999
}

module "gcs_buckets" {
  source        = "git::https://github.com/terraform-google-modules/terraform-google-cloud-storage.git?ref=66e472b56cd21b45a3939883a66ccfcf5ec1b9ed"
  project_id    = var.project_id
  names         = [var.bucket_name]
  prefix        = random_integer.bucket_name_prefix.result
  location      = "US"
  storage_class = "STANDARD"
  force_destroy = { (var.bucket_name) = true }
  website = {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}

# Make bucket public by granting allUsers storage.objectViewer access
resource "google_storage_bucket_iam_member" "public_rule" {
  bucket = module.gcs_buckets.bucket.id
  role   = "roles/storage.objectViewer"
  #checkov:skip=CKV_GCP_28:Skip public bucket access check, required for static website hosting
  member = "allUsers"
}
