local clock = os.clock
local M = {}
function M.sleep(n) -- seconds
  local t0 = clock()
  while clock() - t0 <= n do
  end
end

function M.dump(o)
  if type(o) == "table" then
    local s = "{ "
    for k, v in pairs(o) do
      if type(k) == "boolean" then
        k = tostring(k)
      end
      if type(k) ~= "number" then
        k = '"' .. k .. '"'
      elseif type(o) == "string" then
        return tostring('"' .. o .. '"')
      end
      s = s .. "[" .. k .. "] = " .. dump(v) .. ","
    end
    return s .. "} "
  else
    return tostring(o)
  end
end

return M
