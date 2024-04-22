function debugprint(...)
    if Config.DebugMode then
        local source = debug.getinfo(2).short_src or ""
        local line = debug.getinfo(2).currentline or ""
        local args = {...}
        if #args > 0 then
            local printed_args = {}
            for _, arg in ipairs(args) do
                local var_type = type(arg)
                if var_type == "table" then
                    table.insert(printed_args, "[" .. var_type .. "] " .. table.concat(arg, ", "))
                elseif arg == nil then
                    table.insert(printed_args, "[nil]")
                else
                    table.insert(printed_args, "[" .. var_type .. "] " .. tostring(arg))
                end
            end
            print("\27[31m[DEBUG] \27[0m \20" .. table.concat(printed_args, " ") .. "\20 \27[31m at line \27[0m\27[31m" .. line .. " in file " .. source .. "\27[0m")
        else
            print("\27[31m[DEBUG] No arguments provided at line " .. line .. " in file " .. source .. "\27[0m")
        end
    end
end