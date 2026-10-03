#!/bin/sh
export PATH="/run/wrappers/bin:/run/current-system/sw/bin"
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus
cd ~/dotfiles
git add -A
if ! git diff --cached --quiet; then
  git commit -m temp
  git push
fi

cd ~/dotfiles/nix-config
nix flake update

LOG="$(mktemp)"
if nixos-rebuild switch --flake ~/dotfiles/nix-config --sudo >"$LOG" 2>&1; then
  rm -f ~/FAILED_TO_UPDATE "$LOG"
else
  STATUS=$?
  git checkout -- flake.lock
  {
    echo "failed at $(date)"
    cat "$LOG"
  } >~/FAILED_TO_UPDATE
  notify-send "failed to update" || true
  rm -f "$LOG"
  exit "$STATUS"
fi
