-- lua-phpass, Lua implementation of the portable
-- PHP password hashing framework
-- Copyright (C) 2015 Boris Nagaev
-- See the LICENSE file for terms of use.

describe("phpass", function()
    it("checks phpass hash of password test12345", function()
        local phpass = require('phpass')
        assert.truthy(phpass.checkPassword('test12345',
            '$P$9IQRaTwmfeRo7ud9Fh4E2PdI0S3r.L0'))
        assert.falsy(phpass.checkPassword('test12346',
            '$P$9IQRaTwmfeRo7ud9Fh4E2PdI0S3r.L0'))
        assert.falsy(phpass.checkPassword('test12345',
            '$P$9IQRaTwmfeRo7ud9Fh4E2PdI0S3r.L1'))
    end)

    it("returns false for malformed hashes", function()
        local phpass = require('phpass')
        -- $Q
        assert.falsy(phpass.checkPassword('test12345',
            '$Q$9IQRaTwmfeRo7ud9Fh4E2PdI0S3r.L0'))
        -- $1 (count_log2 too low)
        assert.falsy(phpass.checkPassword('test12345',
            '$P$1IQRaTwmfeRo7ud9Fh4E2PdI0S3r.L0'))
        -- $a (count_log2 too high)
        assert.falsy(phpass.checkPassword('test12345',
            '$P$aIQRaTwmfeRo7ud9Fh4E2PdI0S3r.L0'))
        -- short salt
        assert.falsy(phpass.checkPassword('test12345',
            '$P$9IQR'))
    end)

    it("generates hash for password test12345", function()
        local phpass = require('phpass')
        local hash = phpass.hashPassword('test12345')
        assert.truthy(phpass.checkPassword('test12345', hash))
    end)

    it("respects count_log2 argument", function()
        local phpass = require('phpass')
        local hash = phpass.hashPassword('test12345', 11)
        assert.equal('9', hash:sub(4, 4))
        local hash = phpass.hashPassword('test12345', 12)
        assert.equal('A', hash:sub(4, 4))
    end)
end)
