# Manage the systemd service file for the Discord bot.
/etc/systemd/system/discord-bot.service:
  file.managed:
    - source: salt://apps/discord-bot/files/discord-bot.service
    - user: root
    - group: root
    - mode: '0644'
    - require:
      - pkg: salt-minion  # Adjust if you want to ensure salt-minion is installed

# Ensure the discord-bot service is running and enabled.
discord-bot-service:
  service.running:
    - name: discord-bot
    - enable: True
    - watch:
      - file: /etc/systemd/system/discord-bot.service
