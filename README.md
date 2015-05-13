# lua-phpass, Lua implementation of the portable PHP password hashing framework

[![Travis build][travis-badge]][travis-page]
[![Coverage Status][coveralls-badge]][coveralls-page]
[![License][license-badge]][license-page]

[phpass][phpass] (pronounced "pH pass") is a portable public
domain password hashing framework for use in PHP applications.

This Lua module implements subset of phpass (MD5 with
iterations). Blowfish-based bcrypt and BSDI-style extended
DES-based hashes are not supported.

## Installation

```bash
$ luarocks install phpass
```

## Dependencies

[LuaCrypto][luacrypto]

The code was tested against Lua 5.1, 5.2 and LuaJIT 2.0, 2.1.
LuaCrypto [fails][53-fail] to build against Lua 5.3.

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
[53-fail]: https://travis-ci.org/starius/lua-phpass/jobs/62325591#L747
[travis-page]: https://travis-ci.org/starius/phpass
[travis-badge]: https://travis-ci.org/starius/phpass.png
[coveralls-page]: https://coveralls.io/r/starius/phpass
[coveralls-badge]: https://coveralls.io/repos/starius/phpass/badge.png
[license-page]: LICENSE
[license-badge]: http://img.shields.io/badge/License-MIT-brightgreen.png
