# luabind



## Reflection Functions
    class_info()

    -- Variable "game" is an instance of class "Game"
    c = class_info(game)

    print(c.name)
    -- Prints:
    --   Game

    for k, v in pairs(c.methods) do print(k, v) end
    -- Prints:
    --   get_config    function: 01765AE0
    --   on_init       function: 01765E90
    --   ...

    for k, v in pairs(c.attributes) do print(k, v) end
    -- ...

    class_names()

    for i, v in ipairs(class_names()) do print(v) end
    -- Prints:
    --   class_info_data
    --   Config
    --   Game
    --   ...