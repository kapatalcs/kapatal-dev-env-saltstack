create_user:
  user.present:
    - name: kapatal
    - uid: 1000
    - home: /home/kapatal
    - createhome: True

sudo_permission:
  file.managed:
    - name: /etc/sudoers.d/kapatal
    - source: salt://kapatalfiles/kapatal-sudo
    - mode: 0640

install_packages:
  pkg.installed:
    - pkgs:
      - curl
      - wget
      - git
      - htop
      - build-essential

install_flatpak:
  pkg.installed:
    - pkgs:
      - flatpak
      - flatpak-builder

flatpak-flathub:
  cmd.run:
    - name: flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    - onchanges:
      - pkg: install_flatpak

snapd:
  pkg.installed

snapd-service:
  service.running:
    - name: snapd
    - enable: True
    - require:
      - pkg: snapd

snapd-socket-link:
  cmd.run:
    - name: ln -s /var/lib/snapd/snap /snap
    - unless: test -e /snap
    - require:
      - pkg: snapd

system-upgrade:
  pkg.uptodate:
    - refresh: True

install_zsh:
  pkg.installed:
    - name: zsh

install_oh_my_zsh:
  cmd.run:
    - name: sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    - unless: test -d /root/.oh-my-zsh

configure_zshrc:
  file.managed:
    - name: /home/kapatal/.zshrc
    - source: salt://kapatalfiles/.zshrc
    - user: kapatal
    - mode: 0640

install_python_tools:
  pkg.installed:
    - pkgs:
      - python3
      - python3-pip
      - python3-venv

create_venv:
  cmd.run:
    - name: python3 -m venv /home/kapatal/venvs/myenv
    - creates: /home/kapatal/venvs/myenv/bin/activate

install_virtualenvwrapper:
  cmd.run:
    - name: /home/kapatal/venvs/myenv/bin/pip install virtualenvwrapper
    - require:
      - cmd: create_venv

install_libraries:
  pip.installed:
    - pkgs:
      - requests
      - flask
      - pylint

install_nvm:
  cmd.run:
    - name: curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
    - creates: /home/kapatal/.nvm
    - runas: kapatal

setup_nvm_env:
  file.append:
    - name: /home/kapatal/.bashrc
    - text: |
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    - runas: kapatal
    - require:
      - cmd: install_nvm

install_node:
  cmd.run:
    - name: bash -c "source /home/kapatal/.nvm/nvm.sh && nvm install 18 && nvm alias default 18"
    - runas: kapatal
    - env:
      - HOME: /home/kapatal
    - require:
      - file: setup_nvm_env

install_yarn:
  cmd.run:
    - name: bash -c "source /home/kapatal/.nvm/nvm.sh && npm install -g yarn"
    - runas: kapatal
    - env:
      - HOME: /home/kapatal
    - require:
      - cmd: install_node

install_terminal_editors:
  pkg.installed:
    - pkgs:
      - vim
      - micro
      - neovim

add_microsoft_gpg_key:
  cmd.run:
    - name: |
        curl -fsSL https://packages.microsoft.com/keys/microsoft.asc |
        gpg --dearmor -o /usr/share/keyrings/microsoft.gpg
    - unless: test -f /usr/share/keyrings/microsoft.gpg

add_microsoft_repo:
  file.managed:
    - name: /etc/apt/sources.list.d/vscode.list
    - contents: |
        deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/code stable main
    - require:
      - cmd: add_microsoft_gpg_key

apt_update:
  cmd.run:
    - name: apt-get update
    - require:
      - file: add_microsoft_repo

install_vscode:
  pkg.installed:
    - name: code
    - require:
      - cmd: apt_update
