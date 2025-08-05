#!/bin/bash

# Показываем заголовок
echo "=== engvin vps bootstrap ==="
echo "Версия: 0.1"
echo "Дата релиза: 2025-08-05"
echo

# Загружаем вспомогательные функции
source <(curl -fsSL https://yourdomain.com/engvin-vps-bootstrap/modules/utils.sh)

# Главное меню
main_menu
