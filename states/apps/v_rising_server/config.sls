{% set vr = pillar['vrising'] %}

/opt/game_servers/vrising_server/config_data/Settings:
  file.directory:
    - user: {{ vr.user }}
    - group: {{ vr.user }}
    - makedirs: True

/opt/game_servers/vrising_server/config_data/Settings/ServerHostSettings.json:
  file.managed:
    - source: salt://apps/v_rising_server/files/ServerHostSettings.json.j2
    - template: jinja
    - user: {{ vr.user }}
    - group: {{ vr.user }}
    - mode: 644

/opt/game_servers/vrising_server/config_data/Settings/ServerGameSettings.json:
  file.managed:
    - source: salt://apps/v_rising_server/files/ServerGameSettings.json.j2
    - template: jinja
    - user: {{ vr.user }}
    - group: {{ vr.user }}
    - mode: 644