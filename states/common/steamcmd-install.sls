/opt/steamcmd:
  file.directory:
    - user: {{ pillar['vrising']['user'] }}
    - group: {{ pillar['vrising']['user'] }}
    - mode: 755

install_steamcmd:
  cmd.run:
    - name: |
        curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" \
        | tar zxvf - -C /opt/steamcmd
    - runas: {{ pillar['vrising']['user'] }}
    - creates: /opt/steamcmd/steamcmd.sh