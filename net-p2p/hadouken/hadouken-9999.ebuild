# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils cmake-utils git-r3

DESCRIPTION="Hadouken is a BitTorrent client."

HOMEPAGE="http://www.hdkn.net/"

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/hadouken/hadouken.git"
else
	SRC_URI="https://github.com/hadouken/hadouken/archive/v${PV}.tar.gz"
fi

LICENSE="MIT"

SLOT="0"

KEYWORDS="~amd64 ~x86"

IUSE=""

DEPEND="dev-libs/boost[static-libs]
	net-libs/rb_libtorrent[static-libs]
	app-arch/zip"

RDEPEND=""

src_prepare() {
	# CMakeLists="${S}/CMakeLists.txt"
	# sed -i -e 's/option(Boost_USE_STATIC_LIBS "Static linking to boost libraries" ON)/option(Boost_USE_STATIC_LIBS "Static linking to boost libraries" OFF)/g' ${CMakeLists}
	# sed -i -e 's/option(Boost_USE_STATIC_RUNTIME "Static runtime" ON)/option(Boost_USE_STATIC_RUNTIME "Static runtime" OFF)/g' ${CMakeLists}
	# sed -i -e 's#install(FILES ${CMAKE_SOURCE_DIR}/linux/build/bin/webui.zip DESTINATION share/hadouken)#install(FILES ${CMAKE_SOURCE_DIR}/linux/build/bin/webui.zip DESTINATION share/hadouken)#g' ${CMakeLists}
	sed -i -e 's#return fs::path(p).parent_path();#return "/usr/share/hadouken/";#g' "${S}/src/platform_unix.cpp" || die
	cmake-utils_src_prepare
}

src_compile() {
	mkdir -p "${S}/linux/build/bin"
	cp -R "${S}/js" "${S}/linux/build/bin/" || die
	zip -r "${S}/linux/build/bin/webui.zip" "${S}/webui/" || die
	cmake-utils_src_compile
}