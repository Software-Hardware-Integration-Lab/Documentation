# Network Traffic Inspection

Network traffic inspection is the process of monitoring, capturing, and analyzing data packets that flow through a computer network. It is the cornerstone of modern cybersecurity, enabling organizations to detect threats, optimize performance, and maintain compliance.

!!! note
    If you need to disable network traffic inspection for SHIELD, reach out to your networking team, security team, or the person in charge of information technology at your organization. Each organization manages its own inspection tools and policies, and there is no universal method.


## Purpose

Gain visibility into network activity, detect anomalies, enforce security policies, and troubleshoot performance issues. Cloud services such as Microsoft Azure, Google, Amazon, and Apple do not allow network traffic to be inspected, decrypted, or changed. Doing so can cause authentication failures and may be treated as a security risk, like a man-in-the-middle attack.

- **Example**: Microsoft will drop any traffic that has been inspected or repackaged, preventing applications, such as SHIELD, from functioning properly. 

## How it Works

- **Data Collection**: Traffic inspection tools intercept and record packets or flows of strategic points in the network. This can be done in the perimeter (edge), within core segments, or in cloud environments. 
- **Analysis**: Captured data is analyzed for patterns, threats, and performance bottlenecks. Deep packet inspection (DPI) may be used by tools to examine the contents of packets, or flow monitoring to summarize communication between endpoints. 
- **Enforcement**: Based on the analysis, organizations can block malicious traffic, optimize bandwidth, or enforce compliance requirements. 

## Importance

- **Security**: Detects threats like malware, unauthorized access, and data exfiltration. Helps identify suspicious patterns and block attacks. 
- **Performance**: Diagnoses network bottlenecks, latency, and downtime.
- **Compliance**: Supports auditing and regulatory requirements by logging and analyzing network activity. 

## What is Supported

- Monitoring traffic for performance and security at endpoints you control such as servers and internal segments.
- Using tools for visibility and troubleshooting within your own infrastructure. 

## What is Not Supported

- Inspecting, decrypting, or altering traffic destined for major cloud providers such as Microsoft, Google, Amazon, and Apple.
- Attempting to inspect traffic to Microsoft domains (e.g., security.microsoft.com, azurewebsites.net, etc.) will result in dropped connections and failed authentication. 

## Types of Inspection 

- **Layer 4 (L4) Inspection** - Examines basic headers (IP addresses, ports, protocol type) for fast, efficient filtering and routing. Limited visibility into content.
- **Layer 7 (L7) Inspection** - Analyzes application-layer content (HTTP headers, cookies, payloads) for deeper security and content-based routing. More granular but resource intensive.
