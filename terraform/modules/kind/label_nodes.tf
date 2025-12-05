resource "null_resource" "label_workers" {
  depends_on = [kind_cluster.default]

  triggers = {
    worker_count = var.worker_count
    cluster_name = var.cluster_name
  }

  provisioner "local-exec" {
    command = <<EOF
      kubectl --kubeconfig ${pathexpand(var.kubeconfig_path)} wait --for=condition=Ready node -l node-role.kubernetes.io/control-plane --timeout=60s

      for i in {1..30}; do
        NODES=$(kubectl --kubeconfig ${pathexpand(var.kubeconfig_path)} get nodes --no-headers | grep -v "control-plane" | awk '{print $1}')
        if [ -n "$NODES" ]; then
          echo "$NODES" | xargs -I {} kubectl --kubeconfig ${pathexpand(var.kubeconfig_path)} label node {} node-role.kubernetes.io/worker=true --overwrite
          break
        fi
        sleep 2
      done
    EOF
  }
}
