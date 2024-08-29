resource "nexus_blobstore_file" "efs_blob_1" {
  name = "blobstore-efs_1"
  path = "efs-blobs"
}


## S3 Blobstore

resource "nexus_blobstore_s3" "s3_blobstore_1" {
  name = "S3-blobs-1"

  bucket_configuration {
    bucket {
      name       = "cn-nexus-s3-blobs-1"
      region     = "us-east-1"
      expiration = -1
      prefix     = "nexus-blobs"
    }

  }

}
