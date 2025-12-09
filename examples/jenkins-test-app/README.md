# Jenkins Test Application

A simple Python calculator application to test Jenkins CI/CD pipeline.

## Files

- `app.py` - Main calculator application
- `test_app.py` - Unit tests for the calculator
- `Jenkinsfile` - Jenkins pipeline definition

## Local Testing

Run the application:
```bash
python3 app.py
```

Run the tests:
```bash
python3 test_app.py
```

## Setting Up Jenkins Pipeline

### Step 1: Access Jenkins

1. Get the Jenkins URL:
   ```bash
   kubectl get svc -n minikube-jenkins
   ```

2. Port-forward to access Jenkins locally:
   ```bash
   kubectl port-forward svc/jenkins -n minikube-jenkins 8080:8080
   ```

3. Open your browser and go to: `http://localhost:8080`

### Step 2: Get Admin Password

Get the initial admin password:
```bash
kubectl exec -n minikube-jenkins jenkins-0 -- cat /run/secrets/additional/chart-admin-password
```

Or if you set a custom password in your Terraform deployment, use that.

### Step 3: Initial Jenkins Setup

1. Enter the admin password
2. Click "Install suggested plugins"
3. Create your first admin user (or skip and continue as admin)
4. Confirm the Jenkins URL

### Step 4: Create a New Pipeline

1. Click "New Item" on the Jenkins dashboard
2. Enter a name: `calculator-test-pipeline`
3. Select "Pipeline" and click "OK"

### Step 5: Configure the Pipeline

#### Option A: Pipeline from SCM (Recommended)

1. In the pipeline configuration, scroll to "Pipeline" section
2. Select "Pipeline script from SCM"
3. Choose "Git" as SCM
4. Enter your repository URL: `https://github.com/atamsekar-tivo/infra-lab.git`
5. Set branch to: `*/master` (or your branch name)
6. Set "Script Path" to: `examples/jenkins-test-app/Jenkinsfile`
7. Click "Save"

#### Option B: Direct Pipeline Script

1. In the pipeline configuration, scroll to "Pipeline" section
2. Select "Pipeline script"
3. Copy and paste the contents of `Jenkinsfile` into the script box
4. Click "Save"

### Step 6: Run the Pipeline

1. Click "Build Now" on the left sidebar
2. Watch the build progress in the "Build History"
3. Click on the build number to see details
4. Click "Console Output" to see the full log

### Expected Output

The pipeline will:
1. ✅ Checkout the code
2. ✅ Verify Python is available
3. ✅ Run unit tests
4. ✅ Execute the calculator application
5. ✅ Display build summary

## Troubleshooting

### Jenkins Pod Not Running

Check pod status:
```bash
kubectl get pods -n minikube-jenkins
kubectl describe pod jenkins-0 -n minikube-jenkins
```

### Can't Access Jenkins UI

Verify port-forward is running:
```bash
kubectl port-forward svc/jenkins -n minikube-jenkins 8080:8080
```

### Pipeline Fails

Check the console output for errors. Common issues:
- Python not available in Jenkins agent
- Git repository not accessible
- Incorrect file paths

## Next Steps

Once this basic pipeline works, you can:
- Add more stages (linting, code coverage, deployment)
- Configure webhooks for automatic builds
- Add email notifications
- Integrate with other tools (Docker, Kubernetes, etc.)
