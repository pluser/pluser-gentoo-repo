# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-mod

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/gnif/vendor-reset.git"
	EGIT_BRANCH="master"
	inherit git-r3
else
	KEYWORDS="~amd64"
	SRC_URI="https://github.com/gnif/vendor-reset/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="Linux kernel vendor specific hardware reset module"
HOMEPAGE="https://github.com/gnif/vendor-reset"
LICENSE="GPL-2"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}"

CONFIG_CHECK="FTRACE KPROBES PCI_QUIRKS KALLSYMS FUNCTION_TRACER"
MODULE_NAMES="vendor-reset(extra:)"
BUILD_TARGETS="all"

pkg_setup() {
	linux-mod_pkg_setup
	export KERNELRELEASE="${KV_FULL}"
}

src_prepare() {
	default
	eautoreconf
}

src_compile() {
	set_arch_to_kernel
	export KDIR="/usr/src/linux"
	linux-mod_src_compile
}

src_install() {
	set_arch_to_kernel
	linux-mod_src_install
	insinto /etc/modules-load.d/
	newins "${FILESDIR}"/modload.conf vendor-reset.conf
}
