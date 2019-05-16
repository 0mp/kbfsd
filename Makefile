# SPDX-License-Identifier: BSD-2-Clause
#
# Copyright 2018 Mateusz Piotrowski <0mp@FreeBSD.org>
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
# this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
# this list of conditions and the following disclaimer in the documentation
# and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

PREFIX = /usr/local
LOCALBASE = ${PREFIX}
ETCDIR = ${DESTDIR}${PREFIX}/etc
RCDIR = ${ETCDIR}/rc.d
MANDIR = ${DESTDIR}${PREFIX}/man
MAN5DIR = ${MANDIR}/man5

.PHONY: all
all: kbfsd

kbfsd: kbfsd.in
	awk -v lb="${LOCALBASE}" '{sub("%%LOCALBASE%%", lb); print}' kbfsd.in > kbfsd

.PHONY: install
install: kbfsd
	mkdir -p ${RCDIR}
	install -m 0755 kbfsd ${RCDIR}/kbfsd
	mkdir -p ${MAN5DIR}
	install -m 0555 kbfsd.5 ${MAN5DIR}/kbfsd.5

.PHONY: clean
clean:
	rm -f -- kbfsd

.PHONY: regenerate-readme
regenerate-readme:
	mandoc -Tmarkdown kbfsd.5 | awk 'NR > 2 {print}' | sed '$d;x' | sed '$d;x' > README.md
