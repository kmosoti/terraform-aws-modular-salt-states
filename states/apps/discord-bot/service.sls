# Clone or update the Discord bot repository
/opt/discord_bot:
  git.latest:
    - name: https://github.com/kmosoti/dave-discord-bot.git
    - target: /opt/discord_bot
    - force_reset: True
    - require:
      - pkg: git

# Manage the systemd service file using a Jinja template
/etc/systemd/system/discord-bot.service:
  file.managed:
    - source: salt://apps/discord-bot/files/discord-bot.service.jinja
    - template: jinja
    - context:
        discord_token: {{ pillar.get("discord", {}).get("token", "MISSING_TOKEN") }}
    - user: root
    - group: root
    - mode: '0644'
    - require:
      - git: /opt/discord_bot

# Ensure the Discord bot service is running and enabled
discord-bot-service:
  service.running:
    - name: discord-bot
    - enable: True
    - watch:
      - file: /etc/systemd/system/discord-bot.service
