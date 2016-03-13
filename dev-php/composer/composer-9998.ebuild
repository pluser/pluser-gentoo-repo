# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit versionator

DESCRIPTION="A dependancy manager for PHP"
HOMEPAGE="https://getcomposer.org"
if [[ "${PV}" == "9998" ]]; then
SRC_URI="https://getcomposer.org/composer.phar -> ${PF}.phar"
else
MY_PV=$(replace_version_separator _ -)
SRC_URI="http://getcomposer.org/download/${MY_PV}/composer.phar -> ${PN}-${MY_PV}.phar"
fi

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/php-5.3.4"
RDEPEND="dev-lang/php[zip]"

src_unpack() {
cp "${DISTDIR}/${A}" "${WORKDIR}"
S=${WORKDIR}
}

src_install() {
mv "${WORKDIR}/${A}" "${WORKDIR}/composer"
dobin composer
}
