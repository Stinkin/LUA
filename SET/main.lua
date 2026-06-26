local config = require("core.config")

local board = require("game.board")
local controller = require("game.controller")

local renderer = require("render.renderer")
local animations = require("render.animations")

local gameplay = require("game.gameplay")
local state = require("game.state")

--------------------------------------------------
-- LOAD
--------------------------------------------------

function love.load()

    love.window.setTitle("SET")

    love.window.setMode(

        config.WINDOW_WIDTH,
        config.WINDOW_HEIGHT

    )

    board.initialize()

end

--------------------------------------------------
-- UPDATE
--------------------------------------------------

function love.update(dt)

    gameplay.update(board)
    state.updateAnimations(dt)
    state.update(board)

end
--------------------------------------------------
-- INPUT
--------------------------------------------------

function love.mousepressed(x, y, button)

    controller.mousepressed(
        x,
        y,
        button
    )

end

function love.keypressed(key)

    controller.keypressed(key)

end

--------------------------------------------------
-- DRAW
--------------------------------------------------

function love.draw()

    renderer.draw(board)

end
