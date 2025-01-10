resource "minikube_cluster" "genmfire" {
  driver       = "docker"
  # driver =  "qemu"
  # network = "socket_vmnet"
  cpus = 4
  memory = "8gb"
  cluster_name = "gemfire"
  addons = [
    "default-storageclass",
    "storage-provisioner"
  ]
}