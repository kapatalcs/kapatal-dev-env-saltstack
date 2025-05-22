# Kapatal SaltStack State
This SaltStack state file automates the configuration of a standard development environment for the `kapatal` user.
This feature enables users to swiftly execute a range of tasks, including package installations, configuration of user and permission settings, management of environment variables, and software installation.

---

## Content
- User creation and sudo authorization settings  
- Installation of basic packages (curl, git, htop, etc.)  
- Flatpak and Snap installations and configuration  
- Zsh and Oh-My-Zsh setup and settings  
- Python tools and virtual environment setup  
- Node.js (with NVM) and Yarn setup  
- Microsoft VSCode setup

---

## Requirements
- SaltStack Master and Minion must be installed and communicating.
- User and file permissions must be set appropriately.
- Internet connection required (for package downloads and scripts)

---

## Notes
- In oh-my-zsh installation, root user specific directory control is done. For user-based installation, changes may be required on state.
- NVM installation and Node.js settings are done under the `kapatal` user.
- For sudo authorization, the contents of `/etc/sudoers.d/kapatal` file should be in `kapatalfiles/kapatal-sudo`.

---

## Installation and Use
1. Place this state file in the appropriate location (`/srv/salt/kapatal-saltstack.sls`) on the SaltStack Master.  
2. Make sure that the `kapatalfiles/` directory contains supporting files such as sudoers file and `.zshrc`.  
3. You can change the values in the state file such as username (`kapatal`), user home directory, UID, etc. according to your environment and preferences.  
4. If necessary, you can update the state file and run it again.
5. You can start the state application with the following command:  
   ```bash
   salt '*' state.apply kapatal-saltstack

---

Feel free to send pull request for any suggestions or contributions!
© 2025 Kapatal
