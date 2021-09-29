terraform {
  backend "gcs" {
    bucket = "cellular-nuance-325307-tfstate"
    prefix = "env/dev"
  }
}
