- Use Terraform to provision a EKS cluster and install ArgoCD into the cluster.
- Connect to the cluster
    - Make sure to switch to the IAM role used to create the cluster.
        To view your default AWS CLI identity run `aws sts get-caller-identity`
        To switch to a specified profile, use `export AWS_PROFILE=<profile_name>`
    - `aws eks list-cluster` to find the cluster name. By default, it's "eks-workshop" in this project.
        Note: this command would update the `~/.kube/config` file. 
        You can verify context setup successfully by running `kubectl config current-context` to see output being ARN of the EKS cluster. 
    - Verify the access to the EKS cluster `kubectl get nodes`
- Get ArgoCD UI URL and initial admin password to login
    - Run `kubectl get svc argocd-server -n argocd -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'` to get ArgoCD UI URL. 
    - Run `kubectl get secret argocd-initial-admin-secret -n argocd --template={{.data.password}} | base64 -d` to get initial admin password
    - Open URL and use initila admin password to login for user "admin"
- Create ArgoCD application.
    - Note: You might need to use ArgoCD CLI to login first before conducting this.
