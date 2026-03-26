Hierarchy:

1. Region
   └── 2. Availability Zones
         └── 3. Datacenters

Meaning:
A Region (e.g., Central India) contains multiple Availability Zones
Each Availability Zone = one or more datacenters (physically separate facilities)
Key clarification:
Zone ≠ single server rack
Zone ≈ physically isolated datacenter (or group of datacenters)
Zones are designed to survive datacenter-level failures


Availability Set
An Availability Set ensures your VMs are distributed across:
Fault Domains (FD) → protects from hardware failure
Update Domains (UD) → protects from planned maintenance
Works within a single Azure datacenter (region).

Key Characteristics:
Scope: Single datacenter in a region
Protects against:
•	Hardware failures (FD)
•	Planned maintenance (UD)
Used with: Availability Set’s (legacy but still valid)

Example:
3 VMs in an Availability Set:
•	VM1 → FD0, UD0
•	VM2 → FD1, UD1
•	VM3 → FD0, UD2

If one rack fails → only some VMs affected
If Azure updates → only one VM rebooted at a time

Availability Zone
An Availability Zone is a physically separate datacenter within a region.
Region contains Zone 1, Zone 2, and Zone 3
Each zone = separate datacenter
Apps are distributed across zones → higher fault tolerance

Each zone has:
Independent power
Independent cooling
Independent networking
Designed for high resilience against datacenter-level failures.

Key Characteristics:
Scope: Across multiple datacenters in a region
Protects against:
Entire datacenter failure
Requires:
Zone-supported resources (VMs, disks, load balancer)

Example:
Deploy:
•	VM1 → Zone 1
•	VM2 → Zone 2
•	VM3 → Zone 3

If Zone 1 goes down → other zones still serve traffic
Much higher SLA than Availability Sets


Feature	Availability Set	Availability Zone
Scope	Single datacenter	Multiple datacenters
Failure Protection	Rack / hardware failure	Entire datacenter failure
Latency	Very low (same DC)	Slightly higher (cross-zone)
Use Case	Basic HA	Mission-critical HA
SLA	Lower	Higher
Modern Usage	Older approach	Recommended now



How to Handle Region-Level Failure

You must design for Disaster Recovery (DR) across regions.

•	Option 1: Active-Passive (Most Common)

	Primary VM → Region A (e.g., Central India)
	Replica VM → Region B (e.g., South India)
	Use Azure Site Recovery

o	Flow:
	Normal → traffic goes to Region A
	Failure → failover to Region B

•	Option 2: Active-Active (High-end design)

	Deploy app in multiple regions simultaneously


o	Use:
	Azure Front Door or Azure Traffic Manager
	Users automatically routed to healthy region
	Near zero downtime

•	Option 3: Geo-redundant storage
	Data replicated automatically across paired regions
	Helps with data recovery, not full app failover



Final Takeaways

Correct hierarchy:

Region → Availability Zones → Datacenters
Zone = datacenter-level isolation
Region failure = zones won’t help
Solution = cross-region architecture
