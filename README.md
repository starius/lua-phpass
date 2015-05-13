# lua-phpass, Lua implementation of the portable PHP password hashing framework

[![Travis build][travis-badge]][travis-page]
[![Coverage Status][coveralls-badge]][coveralls-page]
[![License][license-badge]][license-page]

[phpass][phpass] (pronounced "pH pass") is a portable public
domain password hashing framework for use in PHP applications.
phpass has been integrated into [WordPress 2.5+][wordpress],
[bbPress][bbPress], [Vanilla][Vanilla], [PivotX 2.1.0+][PivotX],
[Chyrp][Chyrp], [Textpattern 4.4.0+][Textpattern], and
[concrete5 5.6.3+][concrete5].

This Lua module implements a subset of phpass (iterated MD5).
It's sufficient to create and check a password hash compatible
with portable phpass hash, e.g. a password from wordpress
database. Blowfish-based bcrypt and BSDI-style extended
DES-based hashes are not supported.

## Installation

```bash
$ luarocks install phpass
```

## Dependencies

[LuaCrypto][luacrypto]

The code was tested against Lua 5.1, 5.2, 5.3 and LuaJIT 2.0,
2.1. LuaCrypto for Lua 5.3 requires [the following
patch][5.3-patch]:

```patch
diff --git a/src/lcrypto.c b/src/lcrypto.c
index 48364d1..e5a62c4 100644
--- a/src/lcrypto.c
+++ b/src/lcrypto.c
@@ -968,7 +968,7 @@ static int verify_fverify(lua_State *L)
 
 static int rand_do_bytes(lua_State *L, int (*bytes)(unsigned char *, int))
 {
-    size_t count = (size_t)luaL_checkint(L, 1);
+    size_t count = (size_t)luaL_checkinteger(L, 1);
     unsigned char tmp[256], *buf = tmp;
     if (count > sizeof tmp)
         buf = (unsigned char *)malloc(count);
```

I have applied this patch to [my fork of LuaCrypto][my-lcrypt].
There is also [the modified version][my-rockspec] of rockspec
for version 0.3.2, which installs modified LuaCrypto.

## Usage

```lua
phpass = require 'phpass'

password = 'test12345'

hash = phpass.hashPassword(password)
--> "$P$EYyDnrNHtS2MG5vTVkvXD6wMnd0C/N/"

phpass.checkPassword(password, hash) --> true
phpass.checkPassword('other password', hash) --> false
```

## Notes

[Python-phpass][python-phpass], python implementation of phpass
was used as a reference.

The algorithm used in `phpass.hashPassword` generates random
salt, so this function returns different hashes for a password.

`phpass.hashPassword` has second argument, `count_log2`,
which is `log2` of number of iterations. The algorithm of
hashing is as follows:

```
count = 2 ^ count_log2
salt = ...
hash = md5(salt .. password)
for i = 1, count do
    hash = md5(hash .. password)
end
```

## Author

Corresponding author: Boris Nagaev, email: bnagaev@gmail.com

Copyright (C) 2015 Boris Nagaev

See the [LICENSE][license-page] file for terms of use.

[phpass]: http://www.openwall.com/phpass/
[luacrypto]: https://github.com/mkottman/luacrypto
[5.3-patch]: http://lua.2524044.n2.nabble.com/ANN-phpass-password-hashing-for-Lua-tp7667347p7667348.html
[my-lcrypt]: https://github.com/starius/luacrypto
[my-rockspec]: https://gist.githubusercontent.com/starius/b20d3e63929ae678c857/raw/4b4499f442337b6f577422364358590bd00c9d48/luacrypto-0.3.2-2.rockspec
[wordpress]: http://ryan.boren.me/2007/12/17/secure-cookies-and-passwords/
[bbPress]: https://bbpress.org/
[Vanilla]: http://vanillaforums.org/
[PivotX]: http://forum.pivotx.net/viewtopic.php?p=7836#p7836
[Chyrp]: http://chyrp.net/
[Textpattern]: http://textpattern.com/
[concrete5]: http://www.concrete5.org/developers/bugs/5-6-2-1/more-secure-password-hashing/
[python-phpass]: https://github.com/exavolt/python-phpass
[travis-page]: https://travis-ci.org/starius/lua-phpass
[travis-badge]: https://travis-ci.org/starius/lua-phpass.png
[coveralls-page]: https://coveralls.io/r/starius/lua-phpass
[coveralls-badge]: https://coveralls.io/repos/starius/lua-phpass/badge.png
[license-page]: LICENSE
[license-badge]: http://img.shields.io/badge/License-MIT-brightgreen.png
