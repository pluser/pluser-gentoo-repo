# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit multilib-minimal

DESCRIPTION="Proprietary library that allows a direct access to a USB device"
HOMEPAGE="http://www.ftdichip.com/Drivers/D2XX.htm"
SRC_URI="
abi_x86_64? ( http://www.ftdichip.com/Drivers/D2XX/Linux/${PN}-x86_64-${PV}.tgz )
abi_x86_32? ( http://www.ftdichip.com/Drivers/D2XX/Linux/${PN}-i386-${PV}.tgz )"

LICENSE="FTDI LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="abi_x86_64 abi_x86_32"

RDEPEND="virtual/libusb"
DEPEND="${RDEPEND}"

S="${WORKDIR}"


src_unpack() {
	if use abi_x86_64; then
		mkdir "${S}/${PN}-x86_64-${PV}"
		cd "${S}/${PN}-x86_64-${PV}"
		unpack "${PN}-x86_64-${PV}.tgz"
	fi

	if use abi_x86_32; then
		mkdir "${S}/${PN}-i386-${PV}"
		cd "${S}/${PN}-i386-${PV}"
		unpack "${PN}-i386-${PV}.tgz"
	fi
}

multilib_src_install() {
	if [[ "${MULTILIB_ABI_FLAG}" == "abi_x86_64" ]]; then
		cd "${S}/${PN}-x86_64-${PV}"
		dosym "${PN}.so.${PV}" "/usr/lib64/${PN}.so.1"
		dosym "${PN}.so.${PV}" "/usr/lib64/${PN}.so"
		dolib.so "release/build/${PN}.so.${PV}"
	fi

	if [[ "${MULTILIB_ABI_FLAG}" == "abi_x86_32" ]]; then
		cd "${S}/${PN}-i386-${PV}"
		dosym "${PN}.so.${PV}" "/usr/lib32/${PN}.so.1"
		dosym "${PN}.so.${PV}" "/usr/lib32/${PN}.so"
		dolib.so "release/build/${PN}.so.${PV}"
	fi

	dodoc "release/build/${PN}.txt" "release/ReadMe.txt" "release/release-notes.txt"
	insinto "/usr/include"
	doins "release/ftd2xx.h" "release/WinTypes.h"
}
