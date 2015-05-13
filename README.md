# lua-phpass, Lua implementation of the portable PHP password hashing framework

[phpass][phpass] (pronounced "pH pass") is a portable public
domain password hashing framework for use in PHP applications.

This Lua module implements subset of phpass (MD5 with
iterations). Blowfish-based bcrypt and BSDI-style extended
DES-based hashes are not supported.

## Installation

```bash
$ luarocks install phpass
```

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

The algorithm uses salt, that is why `phpass.hashPassword`
is not deterministic.

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

See the [LICENSE][LICENSE] file for terms of use.

[phpass]: http://www.openwall.com/phpass/
[LICENSE]: LICENSE
