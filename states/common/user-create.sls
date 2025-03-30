{% set user = pillar['vrising']['user'] %}

{{ user }}:
  user.present:
    - shell: /bin/bash
    - createhome: true
    - home: /home/{{ user }}