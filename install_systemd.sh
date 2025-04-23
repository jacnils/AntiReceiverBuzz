#!/bin/sh

[ "$(uname)" != "Linux" ] && printf "%s\n" "Linux isn't running, cannot proceed." && exit 1

: "${GLOBAL_PREFIX:=/usr/local}"
: "${LOCAL_PREFIX:=$HOME/.local}"
: "${GLOBAL_SYSTEMD_DIR:=/etc/systemd/system}"
: "${LOCAL_SYSTEMD_DIR:=$HOME/.config/systemd/user}"
: "${BIN:=AntiReceiverBuzz.sh}"

if ! command -v systemctl >/dev/null 2>&1; then
	printf "%s\n" "systemd not found. Other init systems not supported."
	exit 1
fi

install_script_global() {
	cp -f $BIN "$GLOBAL_PREFIX/bin"
	chmod 0755 "$GLOBAL_PREFIX/bin/$BIN"
}

install_service_global() {
	cp -f AntiReceiverBuzz.service "$GLOBAL_SYSTEMD_DIR"
	chmod 0644 "$GLOBAL_SYSTEMD_DIR/AntiReceiverBuzz.service"
	systemctl daemon-reload
	systemctl enable --now AntiReceiverBuzz.service
}

install_script_local() {
	mkdir -p "$LOCAL_PREFIX/bin"
	cp -f $BIN "$LOCAL_PREFIX/bin"
	chmod 0755 "$LOCAL_PREFIX/bin/$BIN"
}

install_service_local() {
	mkdir -p "$LOCAL_SYSTEMD_DIR"
	cp -f AntiReceiverBuzz_user.service "$LOCAL_SYSTEMD_DIR/AntiReceiverBuzz.service"
	chmod 0644 "$LOCAL_SYSTEMD_DIR/AntiReceiverBuzz.service"
	systemctl --user daemon-reload
	systemctl --user enable --now AntiReceiverBuzz.service
}

remove_script_global() {
	pkill -f AntiReceiverBuzz 2>/dev/null
	rm -f "$GLOBAL_PREFIX/bin/$BIN"
}

remove_service_global() {
	systemctl disable --now AntiReceiverBuzz.service
	rm -f "$GLOBAL_SYSTEMD_DIR/AntiReceiverBuzz.service"
}

remove_script_local() {
	pkill -f AntiReceiverBuzz 2>/dev/null
	rm -f "$LOCAL_PREFIX/bin/$BIN"
}

remove_service_local() {
	systemctl --user disable --now AntiReceiverBuzz.service
	rm -f "$LOCAL_SYSTEMD_DIR/AntiReceiverBuzz.service"
}

print_help() {
	cat <<EOF
Usage: $0 [OPTION]
Options:
  -g, --global          Install globally (requires root)
  -l, --local           Install for current user
  -rg, --remove-global  Remove global installation (requires root)
  -rl, --remove-local   Remove local installation
  -h, --help            Show this help message
EOF
}

case "$1" in
	-g|--global)
		if [ "$(id -u)" != "0" ]; then
			printf "%s\n" "Not running as root, cannot proceed."
			exit 1
		fi
		install_script_global
		install_service_global
		;;
	-l|--local)
		install_script_local
		install_service_local
		;;
	-rg|--remove-global)
		if [ "$(id -u)" != "0" ]; then
			printf "%s\n" "Not running as root, cannot proceed."
			exit 1
		fi
		remove_script_global
		remove_service_global
		;;
	-rl|--remove-local)
		remove_script_local
		remove_service_local
		;;
	-h|--help)
		print_help
		;;
	*)
		print_help
		exit 1
		;;
esac

