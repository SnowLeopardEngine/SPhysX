-- target defination, name: LibraryWorks
target("LibraryWorks")
    -- set target kind: executable
    set_kind("binary")

    -- add source files
    add_files("main.cpp")

    -- add deps
    add_deps("PhysX_static")

    -- defines
    if is_mode("debug") then
        add_defines("_DEBUG")
    end

    -- copy necessary dlls
    local dll_dir = "Prebuilt/Libraries/$(plat)/$(arch)/$(mode)/dll"

    after_build(function (target)
        os.cp(dll_dir .. "/*", target:targetdir())
    end)