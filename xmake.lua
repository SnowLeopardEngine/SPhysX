-- set project name
set_project("PhysX")

-- set project version
set_version("5.3.1")

-- set language version: C++ 17
set_languages("cxx17")

-- global options
option("examples") -- build examples?
    set_default(true)
option_end()

-- if build on windows
if is_host("windows") then
    add_cxxflags("/Zc:__cplusplus", {tools = {"msvc", "cl"}}) -- fix __cplusplus == 199711L error
    add_cxxflags("/bigobj") -- avoid big obj
    if is_mode("debug") then
        set_runtimes("MTd")
    end
end

-- global rules
add_rules("mode.debug", "mode.release")
add_rules("plugin.vsxmake.autoupdate")
add_rules("plugin.compile_commands.autoupdate", {outputdir = ".vscode"})

-- add our own xmake-repo here
add_repositories("snow-leopard-engine-xmake-repo https://github.com/SnowLeopardEngine/xmake-repo.git dev")

-- add a physx static library
target("PhysX_static")
    -- set target kind: static library
    set_kind("static")

    -- add an empty source
    add_files("empty.cpp")

    -- add include dir
    add_includedirs("include", {public = true}) -- public: let other targets to auto include

    before_build(function (target)
        if is_plat("windows") then
            os.exec("powershell.exe .\\download_prebuilt_sdk.ps1")
        end
    end)

    -- links
    add_linkdirs("Prebuilt/Libraries/$(plat)/$(arch)/$(mode)/")
    add_links("PhysX_64",
              "PhysXCharacterKinematic_static_64",
              "PhysXCommon_64",
              "PhysXCooking_64",
              "PhysXExtensions_static_64",
              "PhysXFoundation_64",
              "PhysXPvdSDK_static_64",
              "SceneQuery_static_64")

-- if build examples, then include examples
if has_config("examples") then
    includes("Examples")
end