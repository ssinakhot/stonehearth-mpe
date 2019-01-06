local HeadlessCallHandler = class()

function HeadlessCallHandler:is_headless_mode_enabled(session, response)
    if stonehearth_mpe.headless_enabled then
        return true
    end
    return false
end