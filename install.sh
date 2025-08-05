#!/bin/bash

echo -e "\n=== engvin vps bootstrap ==="
echo "Версия: 0.1"
echo "Дата релиза: 2025-08-05"
echo

set -eu

if ! command -v curl >/dev/null 2>&1; then
  echo "❌ Не найден 'curl'. Установи его сначала: apt install curl -y"
  exit 1
fi

TMP_DIR="/tmp/engvin-vps-bootstrap"
REPO_BASE="https://raw.githubusercontent.com/engvin/engvin-vps-bootstrap/main"

mkdir -p "$TMP_DIR/modules"

echo "⬇️  Загрузка модулей..."
curl -fsSL "$REPO_BASE/utils.sh" -o "$TMP_DIR/utils.sh"
curl -fsSL "$REPO_BASE/modules/install-software.sh" -o "$TMP_DIR/modules/install-software.sh"
curl -fsSL "$REPO_BASE/modules/setup-locale.sh" -o "$TMP_DIR/modules/setup-locale.sh"

if [ ! -f "$TMP_DIR/utils.sh" ]; then
  echo "❌ Файл utils.sh не найден. Проверь подключение к интернету."
  exit 1
fi

chmod +x "$TMP_DIR/"*.sh
chmod +x "$TMP_DIR/modules/"*.sh

# Загружаем вспомогательные функции
source "$TMP_DIR/utils.sh"

# Главное меню
main_menu

CLEANUP=false # true, или false - если в режиме отладки

if [ "$CLEANUP" = true ]; then
  rm -rf "$TMP_DIR"
fi
