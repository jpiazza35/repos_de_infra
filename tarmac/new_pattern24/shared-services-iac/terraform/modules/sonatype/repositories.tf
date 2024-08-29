## CES - Ruby Integration

resource "nexus_repository_rubygems_hosted" "ruby_hosted" {
  name   = "cn_ruby"
  online = true

  storage {
    blob_store_name                = "S3-blobs-1"
    strict_content_type_validation = true
    write_policy                   = "ALLOW"
  }
  depends_on = [nexus_blobstore_s3.s3_blobstore_1]
}

## NPM

resource "nexus_repository_npm_hosted" "npm_hosted" {
  name   = "cn_npm"
  online = true


  storage {
    blob_store_name                = "S3-blobs-1"
    strict_content_type_validation = true
    write_policy                   = "ALLOW"
  }

  depends_on = [nexus_blobstore_s3.s3_blobstore_1]

}

resource "nexus_repository_npm_proxy" "npmjs_proxy" {
  name   = "cn_npm_proxy"
  online = true

  storage {
    blob_store_name                = "S3-blobs-1"
    strict_content_type_validation = true
  }

  proxy {
    remote_url       = "https://npmjs.org/"
    content_max_age  = 1440
    metadata_max_age = 1440
  }

  negative_cache {
    enabled = true
    ttl     = 1440
  }

  http_client {
    blocked    = false
    auto_block = true
  }

  depends_on = [nexus_blobstore_s3.s3_blobstore_1]

}


## Nuget

resource "nexus_repository_nuget_hosted" "nuget_hosted" {
  name   = "cn_nuget"
  online = true


  storage {
    blob_store_name                = "S3-blobs-1"
    strict_content_type_validation = true
    write_policy                   = "DENY"
  }

  depends_on = [nexus_blobstore_s3.s3_blobstore_1]

}

resource "nexus_repository_nuget_proxy" "nuget_org" {
  name   = "cn_nuget_proxy"
  online = true

  nuget_version            = "V3"
  query_cache_item_max_age = 3600

  storage {
    blob_store_name                = "S3-blobs-1"
    strict_content_type_validation = true
  }

  proxy {
    remote_url       = "https://api.nuget.org/v3/index.json"
    content_max_age  = 1440
    metadata_max_age = 1440
  }

  negative_cache {
    enabled = true
    ttl     = 1440
  }

  http_client {
    blocked    = false
    auto_block = true
  }

  depends_on = [nexus_blobstore_s3.s3_blobstore_1]

}


## PYPI

resource "nexus_repository_pypi_hosted" "pypi_hosted" {
  name   = "cn_pypi"
  online = true


  storage {
    blob_store_name                = "S3-blobs-1"
    strict_content_type_validation = true
    write_policy                   = "ALLOW_ONCE"
  }

  depends_on = [nexus_blobstore_s3.s3_blobstore_1]

}


resource "nexus_repository_pypi_proxy" "pypi_org" {
  name   = "cn_pypi_proxy"
  online = true

  storage {
    blob_store_name                = "S3-blobs-1"
    strict_content_type_validation = true
  }

  proxy {
    remote_url       = "https://pypi.org"
    content_max_age  = 1440
    metadata_max_age = 1440
  }

  negative_cache {
    enabled = true
    ttl     = 1440
  }

  http_client {
    blocked    = false
    auto_block = true
  }

  depends_on = [nexus_blobstore_s3.s3_blobstore_1]

}