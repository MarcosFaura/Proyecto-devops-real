# 1. Le pedimos a Oracle que nos diga el nombre de la zona física disponible en Madrid
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}

# 2. EL TRUCO: Le pedimos a Oracle que busque de forma automática el ID de la imagen de Ubuntu 22.04
data "oci_core_images" "ubuntu_image" {
  compartment_id           = var.compartment_id
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "22.04"
  shape                    = "VM.Standard.E2.1.Micro"
}

# 2. SERVIDOR 1: El Nodo Maestro de Kubernetes
resource "oci_core_instance" "k8s_master" {
  compartment_id      = var.compartment_id
  # Usamos la primera zona disponible que nos ha devuelto el bloque 'data' de arriba
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  display_name        = "k8s-master-node"

  # SHAPE GRATUITA: Procesador ARM Ampere (Ideal para K3s)
  shape = "VM.Standard.E2.1.Micro"

  # Conectamos la máquina a la subred que creamos en el archivo 'network.tf'
  create_vnic_details {
    subnet_id        = oci_core_subnet.devops_subnet.id
    assign_public_ip = true
    display_name     = "master-vnic"
  }

  # Instalamos Ubuntu como sistema operativo base
  source_details {
    source_type = "image"
    # Este es el ID estándar para la imagen de Ubuntu 22.04 ARM en la región de Madrid
    source_id   = "ocid1.image.oc1.eu-madrid-1.aaaaaaaaq567asbeoegbyb6qclqbeffo62f3xgn323is7n2lskxod6vbt3ga"
  }

  # PRÁCTICA DE SEGURIDAD: Le metemos tu llave pública de SSH para que luego puedas entrar al servidor desde tu terminal sin contraseña
  metadata = {
    ssh_authorized_keys = file("~/.ssh/id_rsa.pub")
  }
}
