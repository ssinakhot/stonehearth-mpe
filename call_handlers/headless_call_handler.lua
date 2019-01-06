local HeadlessCallHandler = class()

function HeadlessCallHandler:is_headless_mode_enabled(session, response)
    local is_headless = false
    if stonehearth_mpe.headless_enabled then
        is_headless = true        
    end
    return is_headless
end

return HeadlessCallHandler