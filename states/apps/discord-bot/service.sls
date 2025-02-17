/opt/discord_bot:
  git.latest:
    - name: https://github.com/kmosoti/dave-discord-bot.git
    - target: /opt/discord_bot
    - force_reset: True
    - require:
      - pkg: git  # This will look for the state defined in common/git.sls

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
      - pkg: git

discord-bot-service:
  service.running:
    - name: discord-bot
    - enable: True
    - watch:
      - file: /etc/systemd/system/discord-bot.service
