--[[
    Countdown State
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Counts down visually on the screen (3,2,1) so that the player knows the
    game is about to begin. Transitions to the PlayState as soon as the
    countdown is complete.
]]

PauseState = Class{__includes = BaseState}

-- takes 1 second to count down each time
COUNTDOWN_TIME = 0.75

function PauseState:init()
    self.count = 3
    self.timer = 0
end

--[[
    Keeps track of how much time has passed and decreases count if the
    timer has exceeded our countdown time. If we have gone down to 0,
    we should transition to our PlayState.
]]
function PauseState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('p') or love.keyboard.wasPressed('p') then
        gStateMachine:change('play')
    end
end

function PauseState:render()
    love.graphics.setFont(hugeFont)
    love.graphics.printf(tostring(self.count), 0, 120, VIRTUAL_WIDTH, 'center')
end

--[[
    Called when this state is transitioned to from another state.
]]
function PauseState:enter()
    -- if we're coming from death, restart scrolling
    scrolling = true
end

--[[
    Called when this state changes to another state.
]]
function PauseState:exit()
    -- stop scrolling for the death/score screen
    scrolling = false
end
