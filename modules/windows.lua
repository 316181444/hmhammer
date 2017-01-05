-- Hammerspoon --
-- https://github.com/cmsj/hammerspoon-config

require "hs.application"
local hotkey = require 'hs.hotkey'
local window = require 'hs.window'
local layout = require 'hs.layout'
local alert = require 'hs.alert'
local hints = require 'hs.hints'
local grid = require 'hs.grid'
local geometry = require 'hs.geometry'

grid.setGrid'10x4'

-- make window transitions much snappier
-- The default duration for animations, in seconds.
-- Initial value is 0.2; set to 0 to disable animations.
window.animationDuration = 0

-- Defines for window maximize toggler
local frameCache = {}
-- Toggle a window between its normal size, and being maximized
function toggle_window_maximized()
    local win = window.focusedWindow()
    if frameCache[win:id()] then
        win:setFrame(frameCache[win:id()])
        frameCache[win:id()] = nil
    else
        frameCache[win:id()] = win:frame()
        win:maximize()
    end
end

-- draw a bright red circle around the mouse pointer for a few seconds
function mouseHighlight()
    if mouseCircle then
        mouseCircle:delete()
        if mouseCircleTimer then
            mouseCircleTimer:stop()
        end
    end
    mousepoint = hs.mouse.getAbsolutePosition()
    mouseCircle = hs.drawing.circle(hs.geometry.rect(mousepoint.x-40, mousepoint.y-40, 80, 80))
    mouseCircle:setStrokeColor({["red"]=1,["blue"]=0,["green"]=0,["alpha"]=1})
    mouseCircle:setFill(false)
    mouseCircle:setStrokeWidth(5)
    mouseCircle:bringToFront(true)
    mouseCircle:show(0.5)

    mouseCircleTimer = hs.timer.doAfter(3, function()
                                            mouseCircle:hide(0.5)
                                            hs.timer.doAfter(0.6, function() mouseCircle:delete() end)
    end)
end

function fullScreen(win)
    local f = win:frame()
    local screen = win:screen()
    local max = screen:fullFrame()
    f.x = max.x
    f.y = max.y
    f.w = max.w
    f.h = max.h
    win:setFrame(f)
end

function focusedWindowFirst(fn)
    if window.focusedWindow() then
        fn()
    else
        alert.show("No active window")
    end
end



hotkey.bind(hyper, '0', function() mouseHighlight() end)
hotkey.bind(hyper, 'tab', function()
                focusedWindowFirst(function()
                        toggle_window_maximized()
                end)
end)
hotkey.bind(hyper, '/', function()
                hints.windowHints()
end)
hotkey.bind(hyper, '=', function()
                focusedWindowFirst(function()
                        fullScreen(hs.window.focusedWindow())
                end)
end)
