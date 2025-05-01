resource "random_integer" "bucket_name_prefix" {
  min = 10000
  max = 9999999
}

module "gcs_buckets" {
  source        = "terraform-google-modules/cloud-storage/google"
  version       = "~> 10.0"
  project_id    = var.project_id
  names         = [var.bucket_name]
  prefix        = random_integer.bucket_name_prefix.result
  location      = "US"
  storage_class = "STANDARD"
  force_destroy = { var.bucket_name = true }
  website  ={
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}

# Make bucket public by granting allUsers storage.objectViewer access
resource "google_storage_bucket_iam_member" "public_rule" {
  bucket = module.gcs_buckets.bucket.id
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}
