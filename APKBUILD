# Maintainer: Natanael Copa <ncopa@alpinelinux.org>
pkgname=python
pkgver=2.7.6
_verbase=${pkgver%.*}
pkgrel=4
pkgdesc="A high-level scripting language"
url="http://www.python.org"
arch="all"
license="custom"
replaces="python-dev"
subpackages="$pkgname-dev $pkgname-doc $pkgname-tests
	py-gdbm:gdbm
	"
depends=""
makedepends="expat-dev openssl-dev zlib-dev ncurses-dev bzip2-dev
	gdbm-dev sqlite-dev libffi-dev readline-dev paxctl"
source="http://www.$pkgname.org/ftp/$pkgname/$pkgver/Python-$pkgver.tar.xz
	fix-posix-close-clash.patch
	find_library.patch
	unchecked-ioctl.patch
	"

prepare() {
	cd "$srcdir/Python-$pkgver"
	for i in $source; do
		case $i in
		*.patch) msg $i; patch -p1 -i "$srcdir"/$i || return 1
		esac
	done

	# Make sure we use system libs
	rm -r Modules/expat Modules/_ctypes/libffi* Modules/zlib || return 1

	# make sure our /dev/shm is world writeable
	if ! touch /dev/shm/$pkgname-$pkgver; then
		error "/dev/shm is not world writeable. this will cause a broken python build"
		return 1
	fi
	rm /dev/shm/$pkgname-$pkgver
}

build() {
	cd "$srcdir/Python-$pkgver"
	export OPT="$CFLAGS"
	./configure \
		--build=$CBUILD \
		--host=$CHOST \
		--prefix=/usr \
		--enable-shared \
		--with-threads \
		--enable-ipv6 \
		--with-system-ffi \
		--with-system-expat \
		--with-system-zlib \
		--enable-unicode=ucs4 \
		|| return 1
	make || return 1
}

package() {
	cd "$srcdir/Python-$pkgver"
	make -j1 DESTDIR="$pkgdir" install || return 1
	install -Dm644 LICENSE "$pkgdir"/usr/share/licenses/$pkgname/LICENSE
	rm "$pkgdir/usr/bin/2to3" || return 1
	# we need to enable emutramp - needed for virt-manager
	# disable mprotect - needed for cffi
	paxctl -czxm "$pkgdir"/usr/bin/python
}

_mv_files() {
	local i
	for i in "$@"; do
		mkdir -p "$subpkgdir"/${i%/*}
		mv "$pkgdir"/$i "$subpkgdir"/$i || return 1
	done
}

dev() {
	# pyconfig.h is needed runtime so we move it back
	default_dev
	mkdir -p "$pkgdir"/usr/include/python$_verbase
	mv "$subpkgdir"/usr/include/python$_verbase/pyconfig.h \
		"$pkgdir"/usr/include/python$_verbase/
}

tests() {
	pkgdesc="The test modules from the main python package"
	cd "$pkgdir"
	_mv_files usr/lib/python*/*/test \
		usr/lib/python*/test
}

gdbm() {
	pkgdesc="GNU dbm database support for Python"
	cd "$pkgdir"
	_mv_files $(find usr/lib -name '*gdbm*')
}

md5sums="bcf93efa8eaf383c98ed3ce40b763497  Python-2.7.6.tar.xz
10103fd4c0f5476aac7330c09e31b32e  fix-posix-close-clash.patch
22e32fddd3a973172f2fd570f8c5c416  find_library.patch
44ab30c0715f975d78e626729aaca265  unchecked-ioctl.patch"
sha256sums="1fd68e81f8bf7386ff239b7faee9ba387129d2cf34eab13350bd8503a0bff6a1  Python-2.7.6.tar.xz
08daec45cdd42d5bef137de5e569661ec0375ace1d0429fddd7a97d4d746aed2  fix-posix-close-clash.patch
452f9dc842316bcacfd7d6547ac5c1faaa286568cc782db1c0099464bc913946  find_library.patch
57cc9ba55e2e72be4042a466e21d956886635cda69e857de22fb24b8a0779d97  unchecked-ioctl.patch"
sha512sums="e56e6cdd96ff7bcb680d11ad606c00f4264e413fc43ba7605b2d2e4a743fd6e464cbedabf18b461f742102e936f45d840302a99665b5f988b1df08b25285c238  Python-2.7.6.tar.xz
95cff3d1e9f6e7f7d766f4e87cd199cae4f983f7274285dffa59a72bd684601d03da942f0c2f9b18e6f1955e2a975b75cb6950cbe7f4eda6e7b7d8c55efcc05e  fix-posix-close-clash.patch
a1ea61266bb56358158de4036f5be0ad579b44ae616fe0f8d5cef59610886daed73979308c26e56f944435167a6bb8cc6278e6f97f9a72b5f5786d3c31668fc2  find_library.patch
bd015fcc8abe96f999fed1f973364a724c33b6dc0e829d9a530a16718eefc403c3585f30410d22ca30793ca3109c8fe40b64a9a40f4987b8197431c336d4a3d1  unchecked-ioctl.patch"
