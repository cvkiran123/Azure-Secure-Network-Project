This project demonstrates an enterprise-grade infrastructure deployment lifecycle. It uses **Terraform** to provision a secure Azure networking foundation while enforcing **Shift-Left Security** and **FinOps Governance** through a multi-tool CI/CD strategy.

## 🛠 Tech Stack
- **Cloud:** Azure (VNet, NSG, Public IP, Consumption Budget)
- **IaC:** Terraform
- **CI (Continuous Integration):** GitHub Actions (Checkov, Infracost)
- **CD (Continuous Deployment):** Azure Pipelines (Init, Apply, Destroy)
- **Security:** Checkov (Static Analysis)
- **FinOps:** Infracost (Monthly Cost Projections)

## 🏗 Architecture
1. **GitHub Actions:** Runs on every push to audit code for security flaws and cost impact.
2. **Azure Pipelines:** Orchestrates the deployment using an **Ephemeral Lifecycle** (Deploy -> Validate -> Destroy) to ensure zero cloud waste.
3. **Azure RBAC:** Implemented using Service Principals and Workload Identity Federation.

## 📈 Key Achievements
- **Security:** Automated blocking of insecure network rules (e.g., restricted SSH access).
- **Cost Control:** Integrated real-time pricing to maintain a strict ₹500/month budget footprint.