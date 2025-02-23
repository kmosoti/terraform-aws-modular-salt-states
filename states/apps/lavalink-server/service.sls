include:
  - common.java-install

# Create the Lavalink directory with the proper ownership.
/opt/lavalink:
  file.directory:
    - user: ubuntu
    - group: ubuntu
    - mode: 755
    - require:
      - pkg: openjdk-17-jdk  # or simply the java-install state if that's how it's defined

# Manage the Lavalink jar file.
# Assumes you have your lavalink.jar stored at:
# salt://apps/lavalink-server/files/lavalink.jar
/opt/lavalink/lavalink.jar:
  cmd.run:
    - name: wget -q -O /opt/lavalink/lavalink.jar https://github.com/lavalink-devs/Lavalink/releases/download/4.0.8/Lavalink.jar
    - unless: test -f /opt/lavalink/lavalink.jar
    - user: ubuntu
    - require:
      - file: /opt/lavalink

# Deploy the systemd service file using a Jinja template.
# This file will be rendered from:
# salt://apps/lavalink-server/files/lavalink.service.jinja
/etc/systemd/system/lavalink.service:
  file.managed:
    - source: salt://apps/lavalink-server/files/lavalink.service.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: /opt/lavalink/lavalink.jar
      - pkg: openjdk-17-jdk  # ensure Java is installed

# Reload systemd so that changes to the unit file take effect.
reload-systemd:
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - file: /etc/systemd/system/lavalink.service

# Ensure the Lavalink service is running and enabled.
lavalink-service:
  service.running:
    - name: lavalink
    - enable: True
    - require:
      - file: /etc/systemd/system/lavalink.service
