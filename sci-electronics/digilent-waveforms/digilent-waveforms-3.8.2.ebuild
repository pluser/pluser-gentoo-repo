# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit eutils

DESCRIPTION="The virtual instrument suite for Electronics Explorer, Analog Discovery, Analog Discovery 2 and Analog Discovery 2 - NI Edition devices"
HOMEPAGE="https://reference.digilentinc.com/reference/software/waveforms/waveforms-3"
SRC_URI="amd64? ( https://reference.digilentinc.com/lib/exe/fetch.php?tok=00b86c&media=https%3A%2F%2Ffiles.digilent.com%2FSoftware%2FWaveforms2015%2F${PV}%2Fdigilent.waveforms_${PV}_amd64.deb )
x86? ( https://reference.digilentinc.com/lib/exe/fetch.php?tok=e15e71&media=https%3A%2F%2Ffiles.digilent.com%2FSoftware%2FWaveforms2015%2F3.8.2%2Fdigilent.waveforms_3.8.2_i386.deb )"

LICENSE="DIGILENT-WAVEFORMS-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="sci-electronics/digilent-adept-runtime"
DEPEND="${RDEPEND}"

RESTRICT="fetch"
IUSE="abi_x86_64 abi_x86_32"

S="${WORKDIR}"

src_unpack() {
	unpack "${A}"
	unpack "${S}/data.tar.gz"
}

src_install() {
	mkdir -p "${D}/usr"
	cp --recursive "${S}/usr/bin" --target "${D}/usr/"
	cp --recursive "${S}/usr/lib" --target "${D}/usr/"
	cp --recursive "${S}/usr/include" --target "${D}/usr/"
	cp --recursive "${S}/usr/share" --target "${D}/usr/"
}
