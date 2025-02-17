/opt/discord_bot:
  git.latest:
    - name: https://github.com/kmosoti/dave-discord-bot.git
    - target: /opt/discord_bot
    - force_reset: True
    - require:
      - pkg: git-install

/opt/discord_bot/venv:
  cmd.run:
    - name: |
        python3 -m venv /opt/discord_bot/venv &&
        /opt/discord_bot/venv/bin/python -m ensurepip --upgrade &&
        /opt/discord_bot/venv/bin/pip install -r /opt/discord_bot/requirements.txt
    - unless: test -f /opt/discord_bot/venv/bin/python
    - require:
      - git: /opt/discord_bot

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
        - cmd: /opt/discord_bot/venv


discord-bot-service:
  service.running:
    - name: discord-bot
    - enable: True
    - watch:
      - file: /etc/systemd/system/discord-bot.service
