local key2App = {
    I = 'com.jetbrains.intellij',
    E = 'org.gnu.Emacs',
    C = 'com.googlecode.iterm2',
    G = 'com.google.Chrome',
    W = 'com.tencent.qq',
    U = 'com.unity3d.UnityEditor5.x',
    M = 'com.unity.monodevelop',
    R = 'com.jetbrains.rider',
    X = 'com.google.android.studio'
}

for key, app in pairs(key2App) do
    hotkey.bind(hyper, key, function()
                    toggle_application(app)
    end)
end

function toggle_application(_app)
    -- finds a running applications
    local app = application.get(_app)
    if app == nil then
        -- application not running, launch app
        application.launchOrFocusByBundleID(_app)
        return
    end

    if app == nil then
        hs.alert.show("can't find app : " + _app)
    end

    -- application running, toggle hide/unhide
    local mainwin = app:mainWindow()
    if mainwin and mainwin:application() then
        if true == app:isFrontmost() then
            mainwin:application():hide()
        else
            mainwin:application():activate(true)
            mainwin:application():unhide()
            mainwin:focus()
        end
    else
        application.launchOrFocusByBundleID(_app)
    end
end


hotkey.bind(hyper, '=', function()
                local cur = application.frontmostApplication()

                log.i('output current application info...')
                log.i(cur:name())
                log.i(cur:bundleID())
                log.i(cur:path())
end)
