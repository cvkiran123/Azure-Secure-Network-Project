Step <-> Problem encountered	How I resolved it
1. Setting up Terraform locally <->	Downloaded Terraform binary, added it to the System Environment Variables (PATH) so it runs in the terminal.
2. Git initialization <-> Ran git init to start version control for tracking infrastructure changes.
3. Subscription limits/account exhaustion <-> Pivoted to a Static Analysis & Shift-Left Security workflow. Focused on validating infrastructure through terraform validate, Checkov (Security), and Infracost (FinOps) to ensure code is production-ready regardless of cloud access.
4. (checkov)Security Vulnerability Detection <-> Integrated Checkov to perform static analysis on IaC. The scan correctly identified a high-severity issue: CKV_AZURE_10 (SSH open to the internet).
5. (infracost)Cost-Impact Simulation	Added a Static Public IP to the configuration to test Infracost's ability to pull real-time pricing from the Azure Retail Rates API. Validated the monthly cost increased from 0$ to 3.50$ .
6. Azure trying to force subscription for azure pipelines(Had exahusted the free limits) <-> Since this is a demo project used  github.com/marketplace/azure-pipelines to access azure devops pipelines free plan without subscription. 


