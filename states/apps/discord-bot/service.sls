/opt/discord_bot:
  git.latest:
    - name: https://github.com/kmosoti/dave-discord-bot.git
    - target: /opt/discord_bot
    - force_reset: True
    - require:
      - pkg: git-install

/opt/discord_bot/data/config.json:
  file.managed:
    - source: salt://apps/discord-bot/files/config.json.jinja
    - template: jinja
    - user: ubuntu
    - group: ubuntu
    - mode: '0644'
    - require:
      - git: /opt/discord_bot

/opt/discord_bot/venv:
  cmd.run:
    - name: python3 -m venv /opt/discord_bot/venv
    - unless: test -d /opt/discord_bot/venv
    - require:
      - git: /opt/discord_bot

install_requirements:
  cmd.run:
    - name: |
        /opt/discord_bot/venv/bin/python -m ensurepip --upgrade &&
        /opt/discord_bot/venv/bin/python -m pip install --upgrade pip &&
        /opt/discord_bot/venv/bin/python -m pip install -r /opt/discord_bot/requirements.txt &&
        /opt/discord_bot/venv/bin/python -m pip install wavelink==3.4.1 --no-deps
    - require:
      - cmd: /opt/discord_bot/venv


/etc/systemd/system/discord-bot.service:
  file.managed:
    - source: salt://apps/discord-bot/files/discord-bot.service.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: '0644'
    - require: 
        - cmd: /opt/discord_bot/venv
        - service: lavalink-service  # This ensures the Lavalink server is running before deploying the Discord service file

discord-bot-service:
  service.running:
    - name: discord-bot
    - enable: True
    - watch:
      - file: /etc/systemd/system/discord-bot.service
    - require:
      - service: lavalink-service  # Dependency on Lavalink server state
