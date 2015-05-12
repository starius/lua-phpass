-- lua-phpass, Lua implementation of the portable
-- PHP password hashing framework
-- Copyright (C) 2015 Boris Nagaev
-- See the LICENSE file for terms of use.

local phpass = {}

-- Encoding. Not base64!

local itoa64_ = './0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ' ..
    'abcdefghijklmnopqrstuvwxyz'

local function itoa64(index)
    return itoa64_:sub(index + 1, index + 1)
end

local function unItoa64(char)
    return itoa64_:find(char) - 1
end

local function encode64(data)
    local outp = ''
    local cur = 1
    while cur <= #data do
        local value = data:byte(cur)
        outp = outp .. itoa64(value % 64)
        cur = cur + 1
        if cur <= #data then
            value = value + data:byte(cur) * 256
        end
        outp = outp .. itoa64(math.floor(value / 2^6) % 2^6)
        if cur > #data then
            break
        end
        cur = cur + 1
        if cur <= #data then
            value = value + data:byte(cur) * 256^2
        end
        outp = outp .. itoa64(math.floor(value / 2^12) % 2^6)
        if cur > #data then
            break
        end
        cur = cur + 1
        outp = outp .. itoa64(math.floor(value / 2^18) % 2^6)
    end
    return outp
end

local function startsWith(str, prefix)
   return str:sub(1, prefix:len()) == prefix
end

local function md5(data)
    local md5object = require("crypto").digest.new('md5')
    local raw = true
    return md5object:final(data, raw)
end

local function randomBytes(number)
    return require("crypto").rand.bytes(number)
end

local function cryptPrivate(pw, setting)
    local outp = startsWith(setting, '*0')
        and '*1' or '*0'
    if not startsWith(setting, '$P$') and
            not startsWith(setting, '$H$') then
        return outp
    end
    local count_code = setting:sub(4, 4)
    local count_log2 = unItoa64(count_code)
    if count_log2 < 7 or count_log2 > 30 then
        return outp
    end
    local count = 2 ^ count_log2
    local salt = setting:sub(5, 12)
    if #salt ~= 8 then
        return outp
    end
    assert(type(pw) == 'string')
    local hx = md5(salt .. pw)
    for i = 1, count do
        hx = md5(hx .. pw)
    end
    return setting:sub(1, 12) .. encode64(hx)
end

function phpass.checkPassword(pw, stored_hash)
    local hx = cryptPrivate(pw, stored_hash)
    return hx == stored_hash
end

local function gensaltPrivate(count_log2)
    if not count_log2 then
        count_log2 = 8
    end
    local count_code = itoa64(math.min(count_log2 + 5, 30))
    local format = '$P$%s%s'
    local salt = encode64(randomBytes(6))
    return format:format(count_code, salt)
end

function phpass.hashPassword(pw, count_log2)
    local setting = gensaltPrivate(count_log2)
    return cryptPrivate(pw, setting)
end

return phpass
