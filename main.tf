terraform {  
  cloud {
    organization = "starcamp10_thegatekeepers"

    workspaces {
      name = "Workshop-Demo-IP-Whitelist-Infra"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}