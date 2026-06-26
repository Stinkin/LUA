local setlogic = {}

--------------------------------------------------
-- PROPERTY
--------------------------------------------------

local function valid(a, b, c)

    local sum =
        a + b + c

    return sum % 3 == 0

end

--------------------------------------------------
-- IS SET
--------------------------------------------------

function setlogic.isSet(

    cardA,
    cardB,
    cardC

)

    if not cardA
    or not cardB
    or not cardC then
        return false
    end

    local a = cardA.signature
    local b = cardB.signature
    local c = cardC.signature

    for i = 1, 4 do

        if not valid(
            a[i],
            b[i],
            c[i]
        ) then

            return false

        end

    end

    return true

end

return setlogic
