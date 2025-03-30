{% set user = pillar['vrising']['user'] %}

/opt/game_servers/vrising_server/logs:
  file.directory:
    - user: {{ user }}
    - group: {{ user }}

/opt/game_servers/vrising_server/config_data:
  file.directory:
    - user: {{ user }}
    - group: {{ user }}

install_vrising:
  cmd.run:
    - name: >
        /opt/steamcmd/steamcmd.sh
        +@sSteamCmdForcePlatformType windows
        +force_install_dir /opt/game_servers/vrising_server
        +login anonymous
        +app_update 1829350 validate
        +quit
    - runas: {{ user }}
    - require:
      - file: /opt/game_servers/vrising_server/config_data