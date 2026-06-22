Step <-> Problem encountered	How I resolved it
1. Setting up Terraform locally <->	Downloaded Terraform binary, added it to the System Environment Variables (PATH) so it runs in the terminal.
2. Git initialization <-> Ran git init to start version control for tracking infrastructure changes.
3. Subscription limits/account exhaustion <-> Pivoted to a Static Analysis & Shift-Left Security workflow. Focused on validating infrastructure through terraform validate, Checkov (Security), and Infracost (FinOps) to ensure code is production-ready regardless of cloud access.
4. (checkov)Security Vulnerability Detection <-> Integrated Checkov to perform static analysis on IaC. The scan correctly identified a high-severity issue: CKV_AZURE_10 (SSH open to the internet).
5. (infracost)Cost-Impact Simulation <->	Added a Static Public IP to the configuration to test Infracost's ability to pull real-time pricing from the Azure Retail Rates API. Validated the monthly cost increased from 0$ to 3.50$ .
6. "Zombie Resource" Costs <->	Engineered an Ephemeral Lifecycle using a sleep-timer followed by an automated destroy command.
7. Budget Overruns <->	Implemented FinOps-as-Code via Azure Consumption Budgets with 80% threshold alerts.
8. Cross-Platform YAML Syntax <->	Resolved schema errors by mapping Azure's displayName to GitHub's name property.
9. "Orphan" Infrastructure <->	Used condition: always() in the pipeline to ensure cleanup even if the deployment stage failed.
10. Identity Over-Privileging	Replaced account-level keys with User Assigned Managed Identities for resource-to-resource auth.
11. Least Privilege (PoLP)	<-> Enforced strict RBAC by assigning the Reader role to identities instead of Contributor/Owner.