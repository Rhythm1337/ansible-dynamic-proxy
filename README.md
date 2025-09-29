# NGINX Ansible Proxy Automation

A lightweight Ansible playbook that automates the deployment and configuration of an NGINX reverse-proxy on Cloud. It fetches the current public IP, templates NGINX stream and HTTP configurations from Jinja2 templates, and reloads NGINX whenever settings change. A cron job on the proxy host reruns the playbook every ten minutes to handle dynamic IP updates.


## Quick Links

- Demo video (Playbook in action): https://www.youtube.com/watch?v=5_Wg7I3wnJA
- License: MIT

## Contents

- **playbook.yml**
Main playbook that:

1. Gathers the public IP from the local control machine.
2. Connects to the proxy host and installs required packages.
3. Copies the public IP into a text file and sets it for templating.
4. Renders Jinja2 templates into `/etc/nginx/nginx.conf` and site-specific files.
5. Reloads NGINX on change.
- **inventory**
Defines two host groups:
    - `[local]` for the control machine (localhost).
    - `[Proxy]` for the remote proxy server.
- **ansible.cfg**
Configures default inventory, remote user, and privilege escalation.
- **templates/**
    - `nginx-linode-main.conf.j2` – Global `stream { … }` block for TCP proxying (ports, protocols).
    - `nginx-linode-plan.conf.j2` – Example stream site configuration (identical structure, different use cases).
    - `nginx-linode-web1.conf.j2`, `nginx-linode-web2.conf.j2`, `nginx-linode-web3.conf.j2` – HTTP server blocks for containerized web services (SSL via Certbot).
- **run_playbook.sh**
Bash wrapper that logs each run with timestamps. To be executed by cron.


## Prerequisites

- Ansible installed on the control machine (version 2.9+).
- SSH key-based access configured between control and proxy hosts.
- Cloud server with root or sudo privileges.
- Certbot and NGINX repositories accessible from the proxy host.


## Usage

1. Clone the repository:

```bash
git clone https://github.com/your-username/ansible-nginx-dynamic-proxy.git
cd ansible-nginx-dynamic-proxy
```

2. Update `inventory` with your proxy host’s IP or DNS entry and control user names.
3. Adjust any variables in `playbook.yml` (e.g., `username` for file paths).
4. Populate the `templates/` directory with your domain names and proxy ports in the Jinja2 files.
5. Test the playbook manually:

```bash
ansible-playbook playbook.yml
```

6. Install the cron job on the proxy host (runs every 10 minutes):

```cron
*/10 * * * * /home/ansible/files/run_playbook.sh
```

***

This playbook ensures continuous, automated updates of your NGINX proxy configuration to handle dynamic IPs or service changes, providing a reliable, repeatable infrastructure-as-code solution.


