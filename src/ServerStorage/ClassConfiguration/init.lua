local module = {}
module.get = function(name)
    local ReturnModuke = script:FindFirstChild(name)
    if not ReturnModuke then
        error("CLASS: "..name .." IS NOT FOUND")
    end
    return ReturnModuke
end

return module