# Copyright 2019 Vadim Yanitskiy <axilirator@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

default: deps all

.PHONY: deps
deps:
	# Fetch dependencies
	$(MAKE) -C deps
	# Generate links
	mkdir -p build/
	sh ./gen_links.sh
	# HACK: somehow S1APPort.hh is not handled by TITAN
	cp src/TitanExtensions/S1APPort.hh build/

build/Makefile:
	sh ./regen-makefile.sh -o build \
		build/*.ttcn build/*.cc src/S1AP_EncDec.cc \
		src/LibCommon/*.ttcn src/TitanExtensions/* \
		src/LibS1AP/*.ttcn src/asn1/*.asn src/*.ttcn
	# HACK: make build directory include directory
	sed -i -e 's/^CPPFLAGS = \(.*\)/& -I./' build/Makefile
	# TITAN does not support ASN.1 APER, so we use libfftranscode
	# TODO: it should be also possible to use patched version
	# of asn1c by Lev Walkin (https://github.com/vlm/asn1c)
	sed -i -e 's/^LINUX_LIBS = \(.*\)/& -lfftranscode/' build/Makefile

.PHONY: all
all: build/Makefile
	$(MAKE) -C build

.PHONY: clean
clean:
	rm -rf build/
