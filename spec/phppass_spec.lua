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

    it("generates hash for password test12345", function()
        local phpass = require('phpass')
        local hash = phpass.hashPassword('test12345')
        assert.truthy(phpass.checkPassword('test12345', hash))
    end)
end)
