# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit eutils multilib-minimal

DESCRIPTION="Digilent Adept Runtime"
HOMEPAGE="https://reference.digilentinc.com/digilent_adept_2#software_downloads"
SRC_URI="abi_x86_64? ( https://reference.digilentinc.com/lib/exe/fetch.php?tok=329b1e&media=http%3A%2F%2Ffiles.digilent.com%2FSoftware%2FAdept2%2BRuntime%2F${PV}%2Fdigilent.adept.runtime_${PV}-x86_64.tar.gz )
	 abi_x86_32? ( https://reference.digilentinc.com/lib/exe/fetch.php?tok=cc65b4&media=http%3A%2F%2Ffiles.digilent.com%2FSoftware%2FAdept2%2BRuntime%2F${PV}%2Fdigilent.adept.runtime_${PV}-i686.tar.gz )"

LICENSE="DIGILENT-ADEPT2-RUNTIME-EULA ftdi-driver? ( EULA_FTDI )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="sys-fs/udev virtual/libusb !ftdi-driver? ( >=dev-embedded/libftd2xx-1.1.12-r1 )"
DEPEND="${RDEPEND}"

RESTRICT="fetch"
IUSE="abi_x86_64 abi_x86_32 ftdi-driver"

LIBFTD2XX_FTDI_VER="1.4.8"

S="${WORKDIR}"

multilib_src_install() {
	mkdir -p "${D}/usr/share/digilent/adept/data"
	mkdir -p "${D}/etc/ld.so.conf.d/"
	mkdir -p "${D}/usr/sbin/"

	einfo "Installing runtime..."

	if [[ "${MULTILIB_ABI_FLAG}" == "abi_x86_64" ]]; then
		mkdir -p "${D}/usr/lib64/digilent/adept/bin"
		cd "${S}/digilent.adept.runtime_${PV}-x86_64"

		if multilib_is_native_abi; then
			cp --recursive bin64/* --target "${D}/usr/sbin/"
		fi
		cp --recursive lib64/* --target "${D}/usr/lib64/digilent/adept/"
		if use ftdi-driver; then
			cp --recursive ftdi.drivers_${LIBFTD2XX_FTDI_VER}-x86_64/lib64/* --target "${D}/usr/lib64/"
		fi
	fi

	if [[ "${MULTILIB_ABI_FLAG}" == "abi_x86_32" ]]; then
		mkdir -p "${D}/usr/lib32/digilent/adept/bin"
		cd "${S}/digilent.adept.runtime_${PV}-i686"
		if multilib_is_native_abi; then
			cp --recursive bin/* --target "${D}/usr/sbin/"
		fi
		cp --recursive lib/* --target "${D}/usr/lib32/digilent/adept/"
		if use ftdi-driver; then
			cp --recursive ftdi.drivers_${LIBFTD2XX_FTDI_VER}-i686/lib32/* --target "${D}/usr/lib32/"
		fi
	fi

	cp "digilent-adept-libraries.conf" "${D}/etc/ld.so.conf.d/"
	cp --recursive data/* --target "${D}/usr/share/digilent/adept/data/"
	cp "digilent-adept.conf" "${D}/etc/"

	mkdir -p "${D}/lib/udev/rules.d"
	mv "52-digilent-usb.rules" "${D}/lib/udev/rules.d/"

	dodoc CHANGELOG README
}

pkg_postinst() {
	${ROOT}/sbin/ldconfig
	einfo "Reloading udev..."
	udevadm control --reload-rules
}
