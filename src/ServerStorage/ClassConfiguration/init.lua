local module = {}
module.get = function(name)
    local ReturnModule = script:FindFirstChild(name)
    if not ReturnModule then
        error("CLASS: "..name .." IS NOT FOUND")
    end
    return require(ReturnModule)
end

return module