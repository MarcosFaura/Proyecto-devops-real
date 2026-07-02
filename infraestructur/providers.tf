# 1. Configuración de Terraform y descarga del plugin oficial de Oracle Cloud
terraform {
  required_version = ">= 1.5.0"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 5.0.0"
    }
  }
}

# 2. Conexión de Terraform con tus credenciales de Oracle Cloud
provider "oci" {
  tenancy_ocid     = "ocid1.tenancy.oc1..aaaaaaaaepvgxcbkaj5m5vsog5gybrk2oujz4rbh3kg6yvydexmmad6jxa2a"
  user_ocid        = "ocid1.user.oc1..aaaaaaaaui3smytccs5nbgysx6wpo7bxkdxhry5xsjwgj7w274tqavmiy2ta"
  fingerprint      = "5c:a6:8e:ed:d6:24:a2:7b:56:bd:2b:92:ce:2a:55:c2"
  private_key_path = "~/.oci/oci_api_key.pem"
  region           = "eu-madrid-1"
}
