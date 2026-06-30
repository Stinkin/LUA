--------------------------------------------------
-- CARD -- FINISHED
--
-- Represents a single immutable game card with its properties,
-- unique ID representation, and indexed signature.
--
-- Public API
--
-- Lifecycle
--   create(color, shape, count, fill)
--------------------------------------------------

local card = {}

--------------------------------------------------
-- SIGNATURE ** PRIVATE FUNCTION **
--------------------------------------------------

local function produceSignature(

    color,
    shape,
    count,
    fill

)

    return {
        color,
        shape,
        count,
        fill
    }

end

--------------------------------------------------
-- ID ** PRIVATE FUNCTION **
--------------------------------------------------
local function produceId(

    color,
    shape,
    count,
    fill

)

    return 
        color +
        shape *3+
        count *9+
        fill *27
    

end

--------------------------------------------------
-- CREATE
--------------------------------------------------

function card.create(

    color,
    shape,
    count,
    fill

)

    local self = {}

    self.color = color
    self.shape = shape
    self.count = count
    self.fill = fill

    self.id =
    produceId(
            color, shape, count,fill
        )

    self.signature =
        produceSignature(

            color,
            shape,
            count,
            fill

        )

    return self

end

return card