add_multiverse_repo:
  pkgrepo.managed:
    - name: deb http://archive.ubuntu.com/ubuntu {{ grains['oscodename'] }} multiverse
    - file: /etc/apt/sources.list.d/multiverse.list
    - refresh: true

add_i386_arch:
  cmd.run:
    - name: dpkg --add-architecture i386
    - unless: dpkg --print-foreign-architectures | grep i386

apt_update:
  cmd.run:
    - name: apt-get update
    - onchanges:
      - cmd: add_i386_arch

install_wine_stack:
  pkg.installed:
    - pkgs:
        - wine
        - wine64
        - wine32
        - libwine
        - libwine:i386
        - fonts-wine
        - xvfb