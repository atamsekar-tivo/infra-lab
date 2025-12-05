resource "null_resource" "label_workers" {
  depends_on = [kind_cluster.cluster]

  triggers = {
    worker_count = var.worker_count
    cluster_name = var.cluster_name
  }

  provisioner "local-exec" {
    environment = {
      KUBECONFIG = pathexpand(var.kubeconfig_path)
    }
    command = <<EOF
      kubectl --kubeconfig "$KUBECONFIG" wait --for=condition=Ready node -l node-role.kubernetes.io/control-plane --timeout=60s

      for _ in {1..30}; do
        NODES=$(kubectl --kubeconfig "$KUBECONFIG" get nodes --no-headers | grep -v "control-plane" | awk '{print $1}')
        if [ -n "$NODES" ]; then
          echo "$NODES" | xargs -I {} kubectl --kubeconfig "$KUBECONFIG" label node {} node-role.kubernetes.io/worker=true --overwrite
          exit 0
        fi
        sleep 2
      done
      echo "ERROR: Failed to find worker nodes after 30 attempts"
      exit 1
    EOF
  }
}
