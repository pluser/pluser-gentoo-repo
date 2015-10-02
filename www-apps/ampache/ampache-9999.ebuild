# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit webapp

DESCRIPTION="A web based audio/video streaming application and file manager"
HOMEPAGE="http://ampache.org"

COMPOSER="composer.phar"

if [[ ${PV} = "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ampache/ampache.git"
	SRC_URI=""
else
	SRC_URI="https://github.com/ampache/ampache/archive/${PV}.tar.gz -> ${PF}.tar.gz"
fi

SRC_URI="${SRC_URI} https://getcomposer.org/composer.phar -> ${COMPOSER}"

LICENSE="GPL-2"

KEYWORDS=""

IUSE="gd simplexml curl zlib ffmpeg libav"

RDEPEND=">=virtual/mysql-5.0
	>=virtual/httpd-php-5.4
	dev-lang/php[pdo,mysql,hash,session,json,iconv,gd?,simplexml?,curl?,zlib?]
	ffmpeg? ( media-video/ffmpeg:* )
	libav? ( media-video/libav:* )"
DEPEND="dev-lang/php[gmp]"

need_httpd_cgi

src_unpack() {
	if [[ -v _GIT_R3 ]]; then
		git-r3_src_unpack
	else
		unpack "${PF}.tar.gz"
	fi
	cp "${DISTDIR}/${COMPOSER}" "${T}/"
}

src_prepare() {
	cd "${WORKDIR}/${P}"
	php "${T}/${COMPOSER}" install --prefer-source --no-interaction
	find . -type f -name .htaccess.dist | while IFS= read -r path; do cp "${path}" "${path%.dist}"; done
}

src_install() {
	webapp_src_preinst

	doman docs/man/man1/ampache.1
	rm -r docs/man

	dodoc docs/*
	rm -r docs

	cp -R * "${D}/${MY_HTDOCSDIR}"

	webapp_serverowned -R "${MY_HTDOCSDIR}/config"

	webapp_src_install
}

pkg_postinst() {
	elog "Install and upgrade instructions can be found here:"
	elog "https://github.com/ampache/ampache/wiki/Installation"

	webapp_pkg_postinst
}