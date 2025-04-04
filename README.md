# Terraform AWS Modular Salt States

This repository contains the Salt state files used to configure and manage our AWS infrastructure. The states are organized following Salt best practices and are designed to work with our Terraform-provisioned infrastructure. Sensitive configuration is managed separately via our private secrets repository.

## Directory Structure

```
.
├── Bootstrap-StatesRepo.ps1   # PowerShell script to bootstrap the repo (Windows)
├── README.md                  # This README file
├── environments               # Environment-specific state overrides (if needed)
├── secrets                    # Optional folder for local secrets (not to be committed)
└── states
    ├── init.sls               # Global initialization (if needed)
    ├── top.sls                # Top file that maps minion targets to states
    ├── apps                   # Application-specific states
    │   ├── discord-bot
    │   │   ├── init.sls       # Entry point for Discord bot states
    │   │   ├── service.sls    # State to manage the Discord bot systemd service
    │   │   └── files
    │   │       └── discord-bot.service.jinja  # Jinja template for the systemd unit
    │   └── server-place
    │       └── init.sls       # States for the server-place application
    ├── common                 # Shared states used across the environment
    │   ├── git-install.sls    # Ensures Git is installed on minions
    │   ├── python-install.sls # Ensures Python3 and python3-venv are installed
    │   └── init.sls           # (Optional) Global common states
    └── roles                  # Role-based states for minion classification
        └── init.sls           # Defines role assignments
```

## How It Works

- **Top File (`top.sls`):**  
  The top file is the entry point for Salt’s state compiler. It maps minion IDs or grain data to specific state modules. For example, you might have:
  ```yaml
  base:
    '*':
      - common
    'discord-bot':
      - apps.discord-bot
  ```
  This ensures that all minions receive the common states, and minions with the ID `discord-bot` also run the Discord bot states.

- **Apps:**  
  Application-specific states are kept in the `apps` directory. For example, the Discord bot states are in `apps/discord-bot/` and include an `init.sls` file (to include and organize states) and a `service.sls` file to manage the systemd service. The `files` subdirectory holds templates like the systemd unit file.

- **Common:**  
  The common directory contains states that should be applied to all minions (or many of them), such as installing Git (`git-install.sls`) and ensuring Python is set up (`python-install.sls`).

- **Roles:**  
  The roles directory can be used to group states or configurations based on minion roles, making it easier to target configurations to specific groups of servers.

## Usage

1. **Bootstrap the Repository (Optional):**  
   On Windows, you can use the `Bootstrap-StatesRepo.ps1` script to initialize the repository.

2. **State Targeting:**  
   The top file (`top.sls`) determines which states run on which minions. Update this file as needed to match your infrastructure requirements.

3. **Applying States:**  
   Once your Salt Master is up and running, refresh the state tree:
   ```bash
   sudo salt '*' saltutil.sync_all
   sudo salt '*' state.apply -l debug
   ```
   Use these commands to debug and verify that the states are being applied correctly.

4. **Managing Secrets:**  
   Sensitive data (like the Discord bot token) is stored in a private pillars repository. For more details on pillars, refer to the official [Salt Pillars documentation](https://docs.saltproject.io/en/latest/topics/pillar/index.html).

## Additional Information

- **Version Control:**  
  This repository is version-controlled, and changes to states should be thoroughly tested before pushing to production.

- **Customization:**  
  States in the `environments` folder allow for environment-specific overrides, while the `roles` folder is intended for role-based configurations that might be shared across different environments.

- **Best Practices:**  
  Organizing states in this manner makes it easier to maintain and reuse configuration. The structure follows recommendations from the SaltStack documentation and community best practices.

For further guidance on state file organization, see the official [Salt Best Practices for State Files](https://docs.saltproject.io/en/latest/topics/best_practices/state_files.html).