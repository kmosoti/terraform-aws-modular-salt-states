{% set vr = pillar['vrising'] %}

/opt/game_servers/vrising_server/start_vrising.sh:
  file.managed:
    - source: salt://apps/v_rising_server/files/start_vrising.sh.j2
    - template: jinja
    - user: {{ vr.user }}
    - group: {{ vr.user }}
    - mode: 755

/etc/systemd/system/{{ vr.service.name }}.service:
  file.managed:
    - source: salt://apps/v_rising_server/files/vrising.service.j2
    - template: jinja
    - mode: 644

systemctl-daemon-reload:
  cmd.run:
    - name: systemctl daemon-reload

{{ vr.service.name }}:
  service.running:
    - enable: true
    - watch:
      - file: /etc/systemd/system/{{ vr.service.name }}.service
      - file: /opt/game_servers/vrising_server/start_vrising.sh
