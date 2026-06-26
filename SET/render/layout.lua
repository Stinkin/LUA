local config = require("core.config")

local layout = {}

layout.slotPositions = {}

--------------------------------------------------
-- BUILD
--------------------------------------------------

local function build()

    local visualIndex = 1

    for row = 1,
        config.VISUAL_ROWS
    do

        for column = 1,
            config.VISUAL_COLUMNS
        do

            --------------------------------------------------
            -- SLOT ID
            --------------------------------------------------

            local slotId =

                config.SLOT_VISUAL_MAP[
                    visualIndex
                ]

            --------------------------------------------------
            -- POSITION
            --------------------------------------------------

            local x =

                config.BOARD_OFFSET_X +

                (column - 1) *

                (

                    config.CARD_WIDTH +
                    config.GAP_X

                )

            local y =

                config.BOARD_OFFSET_Y +

                (row - 1) *

                (

                    config.CARD_HEIGHT +
                    config.GAP_Y

                )

            --------------------------------------------------
            -- STORE
            --------------------------------------------------

            layout.slotPositions[
                slotId
            ] = {

                x = x,
                y = y

            }

            visualIndex =
                visualIndex + 1

        end

    end

end

build()

--------------------------------------------------
-- GET SLOT POSITION
--------------------------------------------------

function layout.getSlotPosition(slotId)

    local position =

        layout.slotPositions[
            slotId
        ]

    if not position then
        return 0, 0
    end

    return
        position.x,
        position.y

end

--------------------------------------------------
-- GET SLOT AT
--------------------------------------------------

function layout.getSlotAtPosition(mx, my)

    for slotId, position in pairs(
        layout.slotPositions
    ) do

        --------------------------------------------------
        -- X
        --------------------------------------------------

        local insideX =

            mx >= position.x and

            mx <=

            position.x +
            config.CARD_WIDTH

        --------------------------------------------------
        -- Y
        --------------------------------------------------

        local insideY =

            my >= position.y and

            my <=

            position.y +
            config.CARD_HEIGHT

        --------------------------------------------------
        -- HIT
        --------------------------------------------------

        if insideX
        and insideY
        then

            return slotId

        end

    end

    return nil

end

return layout