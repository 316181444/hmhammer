-- reload
config_reload = function ()
    log.i()
    log.i('ready to reload config ...')
    log.i()

    hs.notify.show('Hxms', 'Hammerspoon', 'hotkey trigger config reload ....')

    hs.reload()
end

hotkey.bind(hyper, '\\', config_reload)
