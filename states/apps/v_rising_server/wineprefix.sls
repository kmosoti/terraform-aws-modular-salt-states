{% set user = pillar['vrising']['user'] %}
{% set uid = salt['user.info'](user).get('uid', 1001) %}

initialize_wine:
  cmd.run:
    - name: wineboot -u
    - runas: {{ user }}
    - env:
        XDG_RUNTIME_DIR: "/run/user/{{ uid }}"
    - unless: test -d "/home/{{ user }}/.wine"