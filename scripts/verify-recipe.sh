#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
recipe_dir="${repo_root}/image"
source "${repo_root}/scripts/test-helpers.sh"
temp_dir="$(mktemp -d)"
trap 'rm -rf "${temp_dir}"' EXIT

bash -n "${recipe_dir}/build.sh"
bash -n "${recipe_dir}/build-common.sh"
bash -n "${repo_root}/scripts/check-selinux-avcs.sh"
bash -n "${repo_root}/scripts/write-sbom.sh"

bash "${repo_root}/scripts/check-selinux-avcs.sh" --help >/dev/null
grep -F 'FROM ${FEDORA_BOOTC_BASE_IMAGE}' "${recipe_dir}/Containerfile" >/dev/null
grep -F 'quay.io/fedora/fedora-bootc@sha256:e23805231218ecd1b98ee9ddf77a12661ceb44fcef74b4492fdb2e48d9d4d083' "${recipe_dir}/Containerfile" >/dev/null
! grep -F 'ostree container commit' "${recipe_dir}/Containerfile" >/dev/null
grep -F 'COPY nimbus /usr/local/bin/nimbus' "${recipe_dir}/Containerfile" >/dev/null
grep -F 'ln -fs /usr/local/bin/nimbus /usr/libexec/nimbus/nimbus-container-runner' "${recipe_dir}/Containerfile" >/dev/null
grep -F 'restorecon -v /usr/local/bin/nimbus /usr/libexec/nimbus/nimbus-container-runner' "${recipe_dir}/Containerfile" >/dev/null

grep -F 'u nimbus - "Nimbus machine administrator" /var/lib/nimbus /bin/bash' "${recipe_dir}/build-common.sh" >/dev/null
grep -F '/etc/systemd/system/local-fs.target.wants' "${recipe_dir}/build-common.sh" >/dev/null
grep -F '/etc/systemd/system/multi-user.target.wants' "${recipe_dir}/build-common.sh" >/dev/null
grep -F '/etc/systemd/system/sockets.target.wants' "${recipe_dir}/build-common.sh" >/dev/null
grep -F '/usr/lib/systemd/system/bootloader-update.service.d' "${recipe_dir}/build-common.sh" >/dev/null
grep -F '/usr/libexec/nimbus' "${recipe_dir}/build-common.sh" >/dev/null
grep -F '/usr/lib/systemd/system/nimbus.socket' "${recipe_dir}/build-common.sh" >/dev/null
grep -F '/usr/lib/systemd/system/nimbus.service' "${recipe_dir}/build-common.sh" >/dev/null
grep -F '/usr/share/selinux/packages' "${recipe_dir}/build-common.sh" >/dev/null
grep -F '/var/lib/nimbus/control/node-agent' "${recipe_dir}/build-common.sh" >/dev/null
grep -F '/var/lib/nimbus/control/service-sandboxes' "${recipe_dir}/build-common.sh" >/dev/null
grep -F '/usr/lib/systemd/system/run-nimbus\x2dmachine\x2dconfig.mount' "${recipe_dir}/build-common.sh" >/dev/null
grep -F '/usr/lib/systemd/system/nimbus-machine-config.service' "${recipe_dir}/build-common.sh" >/dev/null
grep -F '/usr/lib/systemd/system/nimbus-boot-restorecon.service' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'WantedBy=sockets.target' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'ExecStartPost=/usr/bin/chcon -t container_var_run_t /run/nimbus/nimbus.sock' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'Requires=nimbus.socket nimbus-machine-config.service' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'After=nimbus.socket nimbus-machine-config.service network-online.target local-fs.target dbus.socket' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'Wants=network-online.target dbus.socket' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'Before=nimbus.service sshd.service' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'WantedBy=multi-user.target' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'SELinuxContext=system_u:system_r:container_runtime_t:s0' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'ExecStart=/usr/local/bin/nimbus machine api --socket-activation --control-data-dir /var/lib/nimbus/control --guest-node-id machine-os-guest-node' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'What=nimbus-machine-config' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'Where=/run/nimbus-machine-config' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'Type=virtiofs' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'Options=ro,context="system_u:object_r:container_var_run_t:s0"' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'cat >/usr/libexec/nimbus/apply-machine-config.sh' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'mount -t virtiofs -o "${mount_options}" "${mount_tag}" "${mount_point}"' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'Wants=run-nimbus\x2dmachine\x2dconfig.mount' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'StandardOutput=journal+console' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'StandardError=journal+console' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'ExecStart=/usr/libexec/nimbus/apply-machine-config.sh' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'bootloader-update.service.d/10-nimbus-restorecon.conf' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'Wants=nimbus-boot-restorecon.service' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'After=nimbus-boot-restorecon.service' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'RequiresMountsFor=/boot' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'Before=bootloader-update.service' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'ConditionPathExists=/boot/bootupd-state.json' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'mount -o remount,rw /boot' "${recipe_dir}/build-common.sh" >/dev/null
grep -F "restorecon /boot/bootupd-state.json" "${recipe_dir}/build-common.sh" >/dev/null
! grep -F 'ConditionPathExists=/run/nimbus-machine-config/machine.json' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'helper_binaries_dir=["/usr/libexec/podman", {append=true}]' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'Delegate=memory pids cpu io' "${recipe_dir}/build-common.sh" >/dev/null
grep -F "echo 'nimbus:100000:65536' >>/etc/subuid" "${recipe_dir}/build-common.sh" >/dev/null
grep -F "echo 'nimbus:100000:65536' >>/etc/subgid" "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'readlink /usr/local' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'mkdir -p /var/usrlocal/bin' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'crun' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'conmon' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'buildah' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'containers-common' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'netavark' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'aardvark-dns' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'openssh-server' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'policycoreutils' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'socat' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'cat >/usr/share/selinux/packages/nimbus-machine-api.cil' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'allow sshd_session_t container_var_run_t' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'allow sshd_session_t container_runtime_t' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'nimbus-guest-node-agent.cil' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'allow container_runtime_t system_dbusd_var_run_t' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'allow container_runtime_t system_dbusd_t' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'allow container_runtime_t init_t (dbus (send_msg))' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'allow init_t container_runtime_t (dbus (send_msg))' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'nimbus-bootupd-fedora-base.cil' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'allow bootupd_t mount_var_run_t' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'allow bootupd_t passwd_file_t' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'allow bootupd_t systemd_userdbd_runtime_t' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'allow bootupd_t systemd_userdbd_t' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'allow bootupd_t systemd_homed_t' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'semodule -i /usr/share/selinux/packages/nimbus-machine-api.cil' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'semodule -i /usr/share/selinux/packages/nimbus-guest-node-agent.cil' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'semodule -i /usr/share/selinux/packages/nimbus-bootupd-fedora-base.cil' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'dnf remove -y moby-engine containerd runc toolbox docker-cli' "${recipe_dir}/build-common.sh" >/dev/null
grep -F 'quay.io/centos-bootc/bootc-image-builder@sha256:754fc17718f977313885379e2c779066aba7d15af88fe04b486baec74759f574' "${recipe_dir}/build.sh" >/dev/null
grep -F 'bootc_image_builder_rootfs=${rootfs}' "${recipe_dir}/build.sh" >/dev/null
grep -F 'provisioning_contract=bootc-native-no-ignition-primary' "${recipe_dir}/build.sh" >/dev/null
grep -F 'admin_user=nimbus' "${recipe_dir}/build.sh" >/dev/null
grep -F 'rootless_subid=nimbus:100000:65536' "${recipe_dir}/build.sh" >/dev/null
grep -F 'package_inventory=aardvark-dns,buildah,conmon,containers-common,containers-common-extra,cpp,crun,fuse-overlayfs,gvisor-tap-vsock-gvforwarder,git-core,iproute,netavark,openssh-server,policycoreutils,podman,procps-ng,socat' "${recipe_dir}/build.sh" >/dev/null
grep -F 'systemd_units=run-nimbus\x2dmachine\x2dconfig.mount,nimbus.socket,nimbus.service,nimbus-machine-config.service,nimbus-boot-restorecon.service,sshd.service' "${recipe_dir}/build.sh" >/dev/null
grep -F 'guest_node_agent_unit=nimbus.service' "${recipe_dir}/build.sh" >/dev/null
grep -F 'guest_node_agent_id=machine-os-guest-node' "${recipe_dir}/build.sh" >/dev/null
grep -F 'guest_node_agent_status_path=/var/lib/nimbus/control/node-agent/status.jsonl' "${recipe_dir}/build.sh" >/dev/null
grep -F 'service_workload_driver=guest-node-agent-systemd-transient-unit' "${recipe_dir}/build.sh" >/dev/null
grep -F 'service_workload_runner=/usr/libexec/nimbus/nimbus-container-runner' "${recipe_dir}/build.sh" >/dev/null
grep -F 'selinux_expectation=container-runtime-domain-container-socket-policy-plus-guest-node-systemd-dbus-policy-plus-fedora-bootupd-compat-plus-runtime-avc-gate' "${recipe_dir}/build.sh" >/dev/null
grep -F 'nimbus-machine-os.sbom.cdx.json' "${recipe_dir}/build.sh" >/dev/null
grep -F 'scripts/write-sbom.sh' "${repo_root}/scripts/write-sbom.sh" >/dev/null

test -f "${recipe_dir}/bootc-image-builder.toml"
grep -F 'ostree.prepare-root.composefs=0' "${recipe_dir}/bootc-image-builder.toml" >/dev/null
! grep -F 'customizations.filesystem' "${recipe_dir}/bootc-image-builder.toml" >/dev/null
grep -F -- '--security-opt label=type:unconfined_t' "${recipe_dir}/build.sh" >/dev/null

fake_bin="${temp_dir}/bin"
context_dir="${temp_dir}/context"
output_dir="${temp_dir}/out"
mkdir -p "${fake_bin}" "${context_dir}" "${output_dir}"

write_executable_stub "${fake_bin}/podman" <<'FAKEOF'
#!/usr/bin/env bash
set -euo pipefail
printf '%s\n' "$*" >>"${TMPDIR}/podman.log"
# Handle `podman save --format oci-archive -o <path> <image>`
if [[ "${1:-}" == "save" ]]; then
  for i in "$@"; do
    case "${prev:-}" in
      -o) mkdir -p "$(dirname "$i")"; : >"$i" ;;
    esac
    prev="$i"
  done
fi
# Handle `podman run ... bootc-image-builder ... --type raw`
if [[ "${1:-}" == "run" ]]; then
  for i in "$@"; do
    if [[ "${prev:-}" == "-v" && "$i" == *:/output ]]; then
      bib_out="${i%%:*}"
      mkdir -p "${bib_out}/image"
      : >"${bib_out}/image/disk.raw"
    fi
    prev="$i"
  done
fi
exit 0
FAKEOF

nimbus_binary="${temp_dir}/nimbus"
write_noop_executable "${nimbus_binary}"

TMPDIR="${temp_dir}" \
PATH="${fake_bin}:${PATH}" \
NIMBUS_MACHINE_OS_BUILD_TEST_UNAME=Linux \
NIMBUS_MACHINE_OS_BUILD_TEST_UID=0 \
bash "${recipe_dir}/build.sh" \
  --nimbus-binary "${nimbus_binary}" \
  --nimbus-version v1.2.3 \
  --source-revision abc123def456 \
  --output-dir "${output_dir}" \
  --context-dir "${context_dir}" \
  --no-cache

test -f "${output_dir}/nimbus-machine-os.ociarchive"
test -f "${output_dir}/nimbus-machine-os.raw"
test -f "${output_dir}/nimbus-machine-os.raw.gz"
test -f "${output_dir}/nimbus-machine-os.sbom.cdx.json"
test -f "${output_dir}/summary.txt"
grep -F -- '--build-arg FEDORA_BOOTC_BASE_IMAGE=' "${temp_dir}/podman.log" >/dev/null
grep -F -- '--no-cache' "${temp_dir}/podman.log" >/dev/null
grep -F -- 'quay.io/fedora/fedora-bootc@sha256:e23805231218ecd1b98ee9ddf77a12661ceb44fcef74b4492fdb2e48d9d4d083' "${temp_dir}/podman.log" >/dev/null
grep -F -- 'quay.io/centos-bootc/bootc-image-builder@sha256:754fc17718f977313885379e2c779066aba7d15af88fe04b486baec74759f574' "${temp_dir}/podman.log" >/dev/null
grep -F -- 'save --format oci-archive' "${temp_dir}/podman.log" >/dev/null
grep -F -- 'bootc-image-builder' "${temp_dir}/podman.log" >/dev/null
grep -F -- '--type raw' "${temp_dir}/podman.log" >/dev/null
grep -F -- '--rootfs ext4' "${temp_dir}/podman.log" >/dev/null
grep -F -- '--output /output' "${temp_dir}/podman.log" >/dev/null
! grep -F -- '--store /store' "${temp_dir}/podman.log" >/dev/null
! grep -F -- ':/var/tmp' "${temp_dir}/podman.log" >/dev/null
grep -F 'candidate=direct-fedora-bootc' "${output_dir}/summary.txt" >/dev/null
grep -E '^nimbus_binary_sha256=[0-9a-f]{64}$' "${output_dir}/summary.txt" >/dev/null
grep -F 'nimbus_version=v1.2.3' "${output_dir}/summary.txt" >/dev/null
grep -F 'source_revision=abc123def456' "${output_dir}/summary.txt" >/dev/null
grep -F 'no_cache=1' "${output_dir}/summary.txt" >/dev/null
grep -F 'fedora_bootc_base_image=quay.io/fedora/fedora-bootc@sha256:e23805231218ecd1b98ee9ddf77a12661ceb44fcef74b4492fdb2e48d9d4d083' "${output_dir}/summary.txt" >/dev/null
grep -F 'bib_image=quay.io/centos-bootc/bootc-image-builder@sha256:754fc17718f977313885379e2c779066aba7d15af88fe04b486baec74759f574' "${output_dir}/summary.txt" >/dev/null
grep -F 'bootc_image_builder_rootfs=ext4' "${output_dir}/summary.txt" >/dev/null
grep -F 'provisioning_contract=bootc-native-no-ignition-primary' "${output_dir}/summary.txt" >/dev/null
grep -F 'admin_user=nimbus' "${output_dir}/summary.txt" >/dev/null
grep -F 'rootless_subid=nimbus:100000:65536' "${output_dir}/summary.txt" >/dev/null
grep -F 'package_inventory=aardvark-dns,buildah,conmon,containers-common,containers-common-extra,cpp,crun,fuse-overlayfs,gvisor-tap-vsock-gvforwarder,git-core,iproute,netavark,openssh-server,policycoreutils,podman,procps-ng,socat' "${output_dir}/summary.txt" >/dev/null
grep -F 'systemd_units=run-nimbus\x2dmachine\x2dconfig.mount,nimbus.socket,nimbus.service,nimbus-machine-config.service,nimbus-boot-restorecon.service,sshd.service' "${output_dir}/summary.txt" >/dev/null
grep -F 'guest_node_agent_unit=nimbus.service' "${output_dir}/summary.txt" >/dev/null
grep -F 'guest_node_agent_id=machine-os-guest-node' "${output_dir}/summary.txt" >/dev/null
grep -F 'guest_node_agent_status_path=/var/lib/nimbus/control/node-agent/status.jsonl' "${output_dir}/summary.txt" >/dev/null
grep -F 'service_workload_driver=guest-node-agent-systemd-transient-unit' "${output_dir}/summary.txt" >/dev/null
grep -F 'service_workload_runner=/usr/libexec/nimbus/nimbus-container-runner' "${output_dir}/summary.txt" >/dev/null
grep -F 'selinux_expectation=container-runtime-domain-container-socket-policy-plus-guest-node-systemd-dbus-policy-plus-fedora-bootupd-compat-plus-runtime-avc-gate' "${output_dir}/summary.txt" >/dev/null
grep -E '^containerfile_sha256=[0-9a-f]{64}$' "${output_dir}/summary.txt" >/dev/null
grep -E '^build_common_sha256=[0-9a-f]{64}$' "${output_dir}/summary.txt" >/dev/null
grep -E '^oci_archive_sha256=[0-9a-f]{64}$' "${output_dir}/summary.txt" >/dev/null
grep -E '^raw_disk_sha256=[0-9a-f]{64}$' "${output_dir}/summary.txt" >/dev/null
grep -E '^compressed_raw_disk_sha256=[0-9a-f]{64}$' "${output_dir}/summary.txt" >/dev/null
grep -F "sbom_path=${output_dir}/nimbus-machine-os.sbom.cdx.json" "${output_dir}/summary.txt" >/dev/null
grep -E '^sbom_sha256=[0-9a-f]{64}$' "${output_dir}/summary.txt" >/dev/null
grep -F "raw_disk_path=${output_dir}/nimbus-machine-os.raw" "${output_dir}/summary.txt" >/dev/null
grep -F 'compressed_raw_disk_path=' "${output_dir}/summary.txt" >/dev/null
gzip -dc "${output_dir}/nimbus-machine-os.raw.gz" >/dev/null
test -f "${context_dir}/nimbus"
grep -F '"bomFormat": "CycloneDX"' "${output_dir}/nimbus-machine-os.sbom.cdx.json" >/dev/null
grep -F '"name": "nimbus-machine-os"' "${output_dir}/nimbus-machine-os.sbom.cdx.json" >/dev/null
grep -F '"name": "nimbus"' "${output_dir}/nimbus-machine-os.sbom.cdx.json" >/dev/null
grep -F '"name": "podman"' "${output_dir}/nimbus-machine-os.sbom.cdx.json" >/dev/null
grep -F 'sha256:e23805231218ecd1b98ee9ddf77a12661ceb44fcef74b4492fdb2e48d9d4d083' "${output_dir}/nimbus-machine-os.sbom.cdx.json" >/dev/null

printf 'verified nimbus machine-os recipe\n'
