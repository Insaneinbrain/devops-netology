provider "yandex" {
  service_account_key_file = "key.json"
  cloud_id  = "b1g8rg0fdagaiarag0i8"
  folder_id = "b1gbt81qq25o3itlo6de"
  zone      = "ru-central1-a"
}

resource "yandex_compute_instance" "vm" {
  name = "terraform"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd89ovh4ticpo40dkbvd"
      name        = "root-vm"
      type        = "network-nvme"
      size        = "40"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }
  
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.1.0/24"]
}

output "internal_ip_address_vm_1" {
  value = yandex_compute_instance.vm.network_interface.0.ip_address
}

output "external_ip_address_vm_1" {
  value = yandex_compute_instance.vm.network_interface.0.nat_ip_address
}
