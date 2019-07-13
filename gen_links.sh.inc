# Copyright 2017 Harald Welte
# Copyright 2018 sysmocom - s.f.m.c. GmbH
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

gen_link() {
	src="$1"
	dst="$2"
	f="$3"
	echo "Linking $f ($src -> $dst)"
	# HACK!
	ln -t "$dst" -sf "$f" "../$src/$f"
}

gen_links() {
	SRC_DIR=$1
	DST_DIR=$2
	shift 2
	FILES=$*

	for f in $FILES; do
		gen_link "$SRC_DIR" "$DST_DIR" "$f"
	done
}

ignore_pp_results() {
	for pp in *.ttcnpp; do
		ttcn_file="$(echo $pp | sed 's/pp$//')"
	done
}
