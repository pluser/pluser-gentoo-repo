# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 git-r3

DESCRIPTION="Server for the Electrum thin Bitcoin client"
HOMEPAGE="http://electrum.org"
SRC_URI=""
EGIT_REPO_URI="https://github.com/spesmilo/${PN}.git"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-python/plyvel[${PYTHON_USEDEP}]
	dev-python/jsonrpclib[${PYTHON_USEDEP}]
	>=dev-python/irc-11.0.1[${PYTHON_USEDEP}]"
