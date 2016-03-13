# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

DESCRIPTION="A fast and feature-rich Python interface to LevelDB"
HOMEPAGE="https://github.com/wbolster/plyvel"
if [[ ${PV} == "9999" ]]; then
	inherit distutils-r1 git-r3
	EGIT_REPO_URI="https://github.com/wbolster/${PN}.git"
else
	inherit distutils-r1
	SRC_URI="https://github.com/wbolster/${PN}/archive/${PV}.tar.gz"
fi

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	virtual/bitcoin-leveldb
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/cython[${PYTHON_USEDEP}]"

#python_prepare() {
#       sed "s%plyvel/_plyvel.cpp%${S}/plyvel/_plyvel.cpp%g" setup.py
#       sed "s%plyvel/comparator.cpp%${S}/plyvel/comparator.cpp%g" setup.py
#}

python_compile() {
	make || die
	distutils-r1_python_install || die
}
