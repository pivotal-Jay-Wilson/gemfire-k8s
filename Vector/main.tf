
resource "kubernetes_namespace" "namespace" {
  for_each = var.namespaces
  metadata {
    name = each.key
  }
}

resource "kubernetes_secret" "image-pull-secret" {
  for_each = var.namespaces
  metadata {
    name = "image-pull-secret"  
    namespace = each.key
  }
  
  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "registry.packages.broadcom.com" = {
          "username" = var.reguser
          "password" = var.regpassword
          "email"    = var.reguser
          "auth"     = base64encode("${var.reguser}:${var.regpassword}")
        }
      }
    })
  }
  depends_on = [ kubernetes_namespace.namespace ]
}

resource "helm_release" "gemfire-operator" {
  name       = "gemfire-operator"
  chart = "./helmcharts/gemfire-operator-${var.gemfire_op_version}.tgz"
  namespace =  "gemfire-operator"
  set {
    name  = "controllerImage"
    value = "${var.reg}/tanzu-gemfire-for-kubernetes/gemfire-controller:2.4.0"
  }
  depends_on = [helm_release.gemfire-crd]
}

resource "helm_release" "gemfire-crd" {
  name       = "gemfire-crd"
  chart = "./helmcharts/gemfire-crd-${var.gemfire_op_version}.tgz"
  namespace =  "gemfire-operator"

  set {
      name  = "operatorReleaseName"
      value = "gemfire-operator"
    }
    depends_on = [ kubernetes_secret.image-pull-secret]
}


data "kubectl_path_documents" "gmc" {
    pattern = "./gmc/*.yaml"
}

resource "kubectl_manifest" "gmcinstall" {
  for_each  = data.kubectl_path_documents.gmc.manifests
  yaml_body = each.value
  depends_on = [helm_release.gemfire-crd]
}

data "kubectl_path_documents" "wan" {
    pattern = "./wan/*.yaml"
}

resource "kubectl_manifest" "waninstall" {
  wait_for {
    field {
      key = "status.servers"
      value = "2/2"
    }
  }  
  for_each  = data.kubectl_path_documents.wan.manifests
  yaml_body = each.value
  depends_on = [helm_release.gemfire-crd, helm_release.gemfire-operator ]
}

data "kubectl_path_documents" "gfsh" {
    pattern = "./gfsh-job/*.yaml"
}

resource "kubectl_manifest" "gfshinstall" {
  for_each  = data.kubectl_path_documents.gfsh.manifests
  yaml_body = each.value
  depends_on = [kubectl_manifest.waninstall, kubectl_manifest.waninstall]
}


