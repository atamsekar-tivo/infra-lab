resource "null_resource" "label_workers" {
  depends_on = [kind_cluster.default]

  triggers = {
    worker_count = var.worker_count
    cluster_name = var.cluster_name
  }

  provisioner "local-exec" {
    command = <<EOF
      # Wait for nodes to be ready (optional but good practice)
      sleep 10
      
      # Label all worker nodes
      # Kind naming: clustername-worker, clustername-worker2, ...
      # We just label all nodes with role=worker (which Kind sets in labels usually? No, Kind sets node-role.kubernetes.io/control-plane on CP)
      # We will label any node that is not a control plane
      
      kubectl --kubeconfig ${pathexpand("~/.kube/config")} get nodes --no-headers | grep -v "control-plane" | awk '{print $1}' | xargs -I {} kubectl --kubeconfig ${pathexpand("~/.kube/config")} label node {} node-role.kubernetes.io/worker=true --overwrite
    EOF
  }
}
