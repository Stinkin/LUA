--------------------------------------------------
-- SET LOGIC -- FINISHED
--
-- Pure mathematical verification for Set rules.
--
-- Public API
--
-- Queries
--   isSet(cardA, cardB, cardC)
--------------------------------------------------

local setlogic = {}

--------------------------------------------------
-- VALID ** PRIVATE FUNCTION **
--------------------------------------------------

local function valid(a, b, c)

    local sum = a + b + c
    return sum % 3 == 0

end

--------------------------------------------------
-- IS SET
--------------------------------------------------

function setlogic.isSet(cardA, cardB,cardC) 

    assert(cardA ~= nil)
    assert(cardB ~= nil)
    assert(cardC ~= nil)

    local a = cardA.signature
    local b = cardB.signature
    local c = cardC.signature

    assert(a ~= nil)
    assert(b ~= nil)
    assert(c ~= nil)

    for i = 1, 4 do
        if not valid( a[i], b[i], c[i]) then
            return false
        end
    end

    return true

end

return setlogic