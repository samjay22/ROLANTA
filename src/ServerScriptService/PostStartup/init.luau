--!strict
for _, mod in script:GetChildren() do
    require(mod)
end

return 0