#!/bin/bash

TMP_DIR="${TMP_DIR:-/tmp/engvin-vps-bootstrap}" # перепроверяем, что tmp_dir не отвалилась

run_software_menu() {
  bash "$TMP_DIR/modules/install-software.sh"
}

main_menu() {
  while true; do
    echo
    echo "=== Сценарии ==="
    echo "1.1 Установка Remnanode (в разработке)"
    echo
    echo "=== Операции ==="
    echo "2.1 Установка софта"
    echo "2.2 Локаль и таймзона (в разработке)"
    echo "2.3 Смена root пароля (в разработке)"
    echo "0. Выход"
    echo
    read -rp "Выберите пункт: " choice

    case $choice in
      2.1) run_software_menu ;;
      0) exit ;;
      *) echo "Неверный ввод." ;;
    esac
  done
}
