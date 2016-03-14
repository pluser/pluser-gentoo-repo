# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit webapp

DESCRIPTION="The personal, minimalist, super-fast, no-database delicious clone"
HOMEPAGE="https://github.com/shaarli/Shaarli"

if [[ ${PV} = "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/shaarli/Shaarli.git"
	SRC_URI=""
else
	SRC_URI="https://github.com/shaarli/Shaarli/archive/v${PV}.tar.gz -> ${PF}.tar.gz"
fi

LICENSE="GPL-2"

KEYWORDS=""

IUSE="gd unicode intl"

RDEPEND=">=virtual/httpd-php-5.4
	>=dev-lang/php-5.3[ssl,gd?,unicode?,intl?]"

need_httpd_cgi

src_unpack() {
	if [[ -v _GIT_R3 ]]; then
		git-r3_src_unpack
	else
		unpack ${A}
	fi
}

src_compile() {
	:
}

src_install() {
	webapp_src_preinst

	dohtml doc/*.html doc/images/*
	dodoc doc/*.md doc/images/* CONTRIBUTING.md
	rm Doxyfile CONTRIBUTING.md COPYING README.md || die

	rm -r docker tests || die

	insinto "${MY_HTDOCSDIR}"
	doins -r .

	webapp_serverowned "${MY_HTDOCSDIR}/cache/"\
					   "${MY_HTDOCSDIR}/data/"\
					   "${MY_HTDOCSDIR}/pagecache/"\
					   "${MY_HTDOCSDIR}/tmp/"

	webapp_src_install
}

pkg_postinst() {
	elog "Install and upgrade instructions can be found here:"
	elog "https://github.com/shaarli/Shaarli/wiki"

	webapp_pkg_postinst
}
