# Ensure the Lavalink directory exists
/opt/lavalink:
  file.directory:
    - user: ubuntu
    - group: ubuntu
    - mode: 755
    - require:
      - service: java-install  # Ensure Java is installed

# Download the Lavalink JAR if it's not already present
download-lavalink-jar:
  cmd.wait:
    - name: wget -q -O /opt/lavalink/lavalink.jar https://github.com/lavalink-devs/Lavalink/releases/download/4.0.8/Lavalink.jar
    - watch:
      - file: /opt/lavalink

# Deploy the systemd service file using a Jinja template
/etc/systemd/system/lavalink.service:
  file.managed:
    - source: salt://apps/lavalink-server/files/lavalink.service.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - cmd: download-lavalink-jar

# Reload systemd to apply changes
reload-systemd:
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - file: /etc/systemd/system/lavalink.service

# Ensure the Lavalink service is running and enabled
lavalink-service:
  service.running:
    - name: lavalink
    - enable: True
    - require:
      - cmd: reload-systemd
