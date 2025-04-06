terraform {  
  cloud {
    organization = "starcamp10_thegatekeepers"

    workspaces {
      name = "Workshop-Demo-IP-Whitelist-Infra"
    }
  }
}