#Enter your project ID
project = "cellular-nuance-325307"

#Staging bucket, used used to stage files, such as Hadoop jars, between client machines and the cluster.
staging_bucket = "dataproc-terraform"

#Enter your region
region = "us-central1"

# Replace with e2-micro if you only want to test
# Machine Type "e2-micro" falls under Free Tier, 1 e2-micro Compute Instance Is Free For 1 Month
machine_types = {
  "master" = "e2-micro"
  "worker" = "e2-micro"
}

cidrs = [ "10.0.0.0/16", "10.1.0.0/16" ]

# replace with a service account you want to be used in the VMs to be created
# leave in blank if you want to use a new service account
service_account = "824365867350-compute@developer.gserviceaccount.com"
