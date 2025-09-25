SYMLINK_NAME="intel-igpu"
RULE_PATH="/etc/udev/rules.d/intel-igpu-dev-path.rules"
INTEL_IGPU_ID=$(lspci -d ::03xx | grep 'Intel' | cut -f1 -d' ')
UDEV_RULE="$(cat <<EOF
KERNEL=="card*", \
KERNELS=="0000:$INTEL_IGPU_ID", \
SUBSYSTEM=="drm", \
SUBSYSTEMS=="pci", \
SYMLINK+="dri/$SYMLINK_NAME"
EOF
)"

echo "$UDEV_RULE" | sudo tee "$RULE_PATH"
