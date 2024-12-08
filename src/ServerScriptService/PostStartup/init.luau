for _, r in script:GetChildren() do
   task.spawn(function()
        require(r)
   end)
end

return 0