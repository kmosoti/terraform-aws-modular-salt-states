steam_server_manager_user:
  user.present:
    - name: steam_server_manager
    - shell: /bin/bash
    - home: /home/steam_server_manager
    - createhome: true

xdg_runtime_dir:
  file.directory:
    - name: /run/user/{{ salt['user.info']('steam_server_manager')['uid'] }}
    - user: steam_server_manager
    - group: steam_server_manager
    - mode: 700
