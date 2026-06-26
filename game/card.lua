local card = {}

--------------------------------------------------
-- SIGNATURE
--------------------------------------------------

function card.produceSignature(

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
-- ID
--------------------------------------------------
function card.produceId(

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

    self.signature =
        card.produceSignature(

            color,
            shape,
            count,
            fill

        )
    self.id =
        card.produceId(
            color, shape, count,fill
        )
    return self

end

return card