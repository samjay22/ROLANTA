--!strict
local Trie = {}
Trie.__index = Trie


local function _makeStringMatchTrie(node : any, charsLeft : {string})
    if #charsLeft == 0 then
        return
    end

    local key : string = table.remove(charsLeft, 1)
    if not key then
        return
    end

    if not node[key] then
        node[key] = {}
    end    
    
    _makeStringMatchTrie(node[key], charsLeft)
end

function Trie:GenerateSuggestion(name : string)
    local closest = {}
    local chars = string.split(name, "")
    local nextChar : string = table.remove(chars, 1)
    local node = self.Head[nextChar]
    while #chars > 0 and node do
        table.insert(closest, nextChar)
        nextChar = table.remove(chars, 1)
        node = node[nextChar]
        task.wait()
    end

    return table.concat(closest)
end

function Trie.new(strings : {string})
    local self = setmetatable({Head = {}}, Trie)
    local head = self.Head
    
    for _, str in strings do
        _makeStringMatchTrie(head, string.split(str, ""))
    end

    return self
end

function Trie:GetHead()
    return self.Head
end

return Trie