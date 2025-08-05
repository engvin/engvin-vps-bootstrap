#!/bin/bash

echo "=== Установка софта ==="

declare -A SOFTWARE_OPTIONS=(
  [sudo]=1
  [curl]=1
  [wget]=1
  [git]=1
  [ncdu]=1
  [htop]=1
  [ufw]=1
  [openssh-server]=1
  [bash-completion]=1
  [mc]=1
  [locales]=1
  [nano]=1
  [fail2ban]=1
  [docker]=1
  [caddy]=1
)

while true; do
  echo
  echo "Выберите, что установить (введите номер для переключения):"
  i=1
  keys=()
  for pkg in "${!SOFTWARE_OPTIONS[@]}"; do
    keys+=("$pkg")
    status="${SOFTWARE_OPTIONS[$pkg]}"
    echo "$i. [$([ "$status" -eq 1 ] && echo 'X' || echo ' ')] $pkg"
    ((i++))
  done
  echo "$i. Продолжить"
  read -rp "Введите номер: " input

  if [[ "$input" -ge 1 && "$input" -lt $i ]]; then
    pkg="${keys[$((input-1))]}"
    SOFTWARE_OPTIONS[$pkg]=$((1 - SOFTWARE_OPTIONS[$pkg]))
  elif [[ "$input" -eq $i ]]; then
    break
  else
    echo "Неверный ввод."
  fi
done

echo
echo "⏳ Установка выбранного софта..."

apt update && apt upgrade -y

# Установим обычные пакеты одним блоком
REGULAR_PACKAGES=()

for pkg in "${!SOFTWARE_OPTIONS[@]}"; do
  if [[ "${SOFTWARE_OPTIONS[$pkg]}" -eq 1 ]]; then
    case $pkg in
      docker|caddy) continue ;;
      *) REGULAR_PACKAGES+=("$pkg") ;;
    esac
  fi
done

if [[ ${#REGULAR_PACKAGES[@]} -gt 0 ]]; then
  apt install -y "${REGULAR_PACKAGES[@]}"
fi

# Установка docker
if [[ "${SOFTWARE_OPTIONS[docker]}" -eq 1 ]]; then
  curl -fsSL https://get.docker.com | sh
fi

# Установка caddy
if [[ "${SOFTWARE_OPTIONS[caddy]}" -eq 1 ]]; then
  apt install -y debian-keyring debian-archive-keyring apt-transport-https curl
  curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' \
    | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
  curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' \
    | tee /etc/apt/sources.list.d/caddy-stable.list
  chmod o+r /usr/share/keyrings/caddy-stable-archive-keyring.gpg
  chmod o+r /etc/apt/sources.list.d/caddy-stable.list
  apt update
  apt install -y caddy
fi

echo "✅ Установка завершена. Возвращаемся в главное меню..."
read -rp "Нажмите Enter для возврата..."
