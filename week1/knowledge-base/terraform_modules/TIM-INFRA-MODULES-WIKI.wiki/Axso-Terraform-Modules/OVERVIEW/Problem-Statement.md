# Problem Statement

We will show the Problem Statements and how our self service products are mitigating them.

## Products

- Self Service (DYOS)
- Application Hub
- Container Center of Excellence (CoE)
- Application Readiness

## What are the Problem Statements

1. Organisation Structure
2. Process to onboard Projects in Cloud
3. Team Structure
4. Common Tooling
5. Single Cloud principle
6. Lack of Hub and Spoke
7. Subscription Order
8. Network Address Space Request
9. Peering Request
10. Firewall Order
11. DNS Order
12. Configuration on Directory Objects
13. Build and Deployment
14. Cloud Resources
15. Silo Technologies around Applications
16. Security
17. Onboard to Cloud Services Provider
18. Operation Model based on use cases  

**Note:** Self Service is a collection of **Automation tools** but there's a lot of other processes and technologies surrounding it. If one of these are not working, Self Service will never be successful.  

## How we are mitigating Problem Statements with our Products

### 1. Security and Operation Functions

As you can see from the below diagram, we do not have a **`Security`** and **`Operation`** function in the DevOps Organisation Structure  

![image.png](/assets/Overview/Project_Structure.PNG)

Self Service (DYOS) fulfils the need for **`Security`** and **`Operation`** functions as they are natively built into the product.

- The **`Security`** function **enforces** and **validates** Infrastructure security in DYOS.  
- The **`Operation`** function alleviates the lack of resource capacity in development teams. (This can be due to lack of team members, technology, or passion for learning new technologies)

### 2. Process

There was never a process to onboard projects in cloud. With Self Service, we now have an interim process to be finalised shortly.

### 3. Team Structure

Due to The lack of a **Consistent Team Structure** in the DevOps Organisation, we have built Self Service to **automate** and **standardise** the process of onboarding projects in the cloud with a **consistent team structure** as follows:

- **`Business`** - Responsible for the **usecase** of the project.
- **`Architecture`** - Responsible for **validating** where the **usecase** fits in the organisation application landscape. Also responsible for providing high level **architecture** diagram.  
- **`Application`** - Responsible for **validating** the architecture diagram provided by the architecture team along with the **usecase** from the business.
- **`Cloud Ops`** - Responsible for **building** the cloud infrastructure using self service (DYOS).
- **`Cloud Platform`** - Making sure DYOS **fulfils** the requirement for cloud operations.

**Cloud Platfrom Team:**  

![image.png](/assets/Overview/Cloud-platform-team.png)

### 4. Common Tooling

With Self Service (DYOS) Modules, we are **standardising** the **tooling** in a way that the backend **Terraform modules** can be orchestrated by any CI/CD tool in a Self Service manner which will support the following CI/CD tools for consumption:  

- Azure Devops
- Octopus
- Github Actions
- Circle CI
- Jenkins

We are also developing a **low code** and **no code** solution in our Roadmap.

### 5. Single Cloud Principle

Because there is no multi-cloud strategy, we are recommending application teams more towards the use of **Containers** which is easy to migrate if needed. Hence we are building a **Container Center of Excellence Team** and **Framework**. Containerised applications can run in:  

- On Prem K8s
- Azure Kubernetes Service (Microsoft AKS)
- Google Kubernetes Service (Google GKS)
- Elastic Kubernetes Service (Amazon EKS)

### 6. Lack of Hub and Spoke

Earlier we had no "Hub and Spoke" but now we worked together with GIT to build a new Hub with Express Route.  

This is what the **legacy Hub** looked like that was using Site to Site VPN:  

![image.png](/assets/Overview/legacy-hub-and-spoke.png)

This is what the **new Hub** looks like that is using Express Route:  

![image.png](/assets/Overview/new-hub-and-spoke.png)  

### 7. Subscription Order


We have redefined the **Subscription Blueprint**, with a least default resource deployment principle, fulfilling Security requirements with SLA on delivery - https://mingle.axpo.com/x/6CPHDw  
This problem statement was missing from ITSM, order process delegated to Dev community with 4 eye principle.  

### 8. Network Address Space Requests

The problem with **Network Address Space** requests have been addressed by being included as part of the new **Subscription Blueprint**.  

### 9. VNet Peering

The problem with **VNet Peering** has been addressed by being included as part of the new **Subscription Blueprint**.  

### 10. Firewall Order

Firewall Orders have been simplified by including **Well Known Ports** implementation - https://mingle.axpo.com/x/r4OVEg  

### 11. DNS Order

DNS Orders have been solved by implementing Azure Private DNS Resolver - https://mingle.axpo.com/x/cjcVEQ  

### 12. Create/update Directory Object

**Create/update Directory Objects** are now included as part of Self Service. Also Application readiness will educate the Axpo Dev Community on how to use App Registrations and Enterprise applications in applications - https://mingle.axpo.com/x/7wtVDw  

### 13. Build and Deployment Process

Infrastructure **Build and Deploy** process has been greatly simplified with Self Service. The Cloud Team is no longer in the Critical Path or a Blocker as Dev Teams can build and Run their own infrastructure.  

### 14. Cloud Resources

With Self Service, there are two approaches:  

- Dev Teams can Build, Deploy andManage their own Cloud Infrastructure.  
- SRE Teams can deploy on behalf of Dev Team's (Current model) if there is a lack of knowledge, passion or capacity.  

With the new approach we can effectively scale in terms of cloud resources and capacity, due to the number of **Cloud Projects vs. the number of Cloud Engineers**.  

### 15. Silo Technologies around Applications

Dev Teams can now leverage **common Technologies** from the Application Hub. Each team does not have to deploy and manage in isolation.  

### 16. Security

Security requirements are mitigated with **Azure Policies** and Guardrails in Self Service Modules (DYOS).  

### 17. Onboard to Cloud Services Provider

We have a Master Data sheet (PFA) which will be converted to an internal tool, built as part of Application readiness.  

### 18. Operation Model based on use cases

Similar to Point 14, we have two approaches:

- Dev Teams can Build, Deploy andManage their own Cloud Infrastructure.  
- SRE Teams can deploy on behalf of Dev Team's (Current model) if there is a lack of knowledge, passion or capacity.  
