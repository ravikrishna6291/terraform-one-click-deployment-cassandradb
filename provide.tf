terraform {
  
    required_providers {
    google = {
      source = "hashicorp/google"
      version = "~>4.16.0"
    }
    
    tls = {
      source  = "hashicorp/tls"
      version = "3.1.0"
    }

    google-beta ={
      source = "hashicorp/google-beta"
      version = "~> 3.0"
    }
  }
}

provider "tls" {
  // no config needed
}


provider "google" {
  project = "terraform-349213"
  region  = "us-central1"
  zone    = "us-central1-c"
  credentials = "keys.json"
}
 

provider "google-beta" {

  project = "terraform-349213"
  region  = "us-central1"
 
}