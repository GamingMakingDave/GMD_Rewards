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
            print("[DEBUG]" .. table.concat(printed_args, " ") .. " at line " .. line .. " in file " .. source .. "")
        else
            print("[DEBUG]" .. table.concat(printed_args, " ") .. " at line " .. line .. " in file " .. source .. "")
        end
    end
end