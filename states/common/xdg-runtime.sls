{% set user = pillar['vrising']['user'] %}
{% set uid = salt['user.info'](user).get('uid', 1001) %}

/run/user/{{ uid }}:
  file.directory:
    - user: {{ user }}
    - group: {{ user }}
    - mode: 700