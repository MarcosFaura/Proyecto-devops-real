# 1. Definimos la variable del ID de tu cuenta (compartimento de Oracle)
# Reemplaza este valor con tu tenancy OCID si es diferente, pero usamos el tuyo por defecto.
variable "compartment_id" {
  type    = string
  default = "ocid1.tenancy.oc1..aaaaaaaaepvgxcbkaj5m5vsog5gybrk2oujz4rbh3kg6yvydexmmad6jxa2a"
}

# 2. Creamos la Red Virtual Principal (VCN)
resource "oci_core_vcn" "devops_vcn" {
  compartment_id = var.compartment_id
  cidr_block     = "10.0.0.0/16"
  display_name   = "devops-network"
  dns_label      = "devopsvcn"
}

# 3. Creamos una puerta de enlace a Internet (Internet Gateway)
# Sin esto, los servidores que metamos dentro no podrían hablar con el mundo exterior ni recibir tráfico.
resource "oci_core_internet_gateway" "devops_ig" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.devops_vcn.id
  display_name   = "devops-internet-gateway"
}

# 4. Creamos una Tabla de Enrutamiento (Route Table)
# Es el "mapa de carreteras" que le dice a la red: "Todo el tráfico que vaya hacia internet (0.0.0.0/0), envíalo a través del Internet Gateway".
resource "oci_core_route_table" "devops_rt" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.devops_vcn.id
  display_name   = "devops-route-table"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.devops_ig.id
  }
}

# 5. Creamos una Subred Pública (Subnet)
# Una porción de la red donde meteremos nuestras máquinas. Al ser pública, tendrá IPs accesibles desde internet.
resource "oci_core_subnet" "devops_subnet" {
  compartment_id    = var.compartment_id
  vcn_id            = oci_core_vcn.devops_vcn.id
  cidr_block        = "10.0.1.0/24"
  display_name      = "mi-primera-subred-automatica"
  dns_label         = "devopssubnet"
  route_table_id    = oci_core_route_table.devops_rt.id
}
