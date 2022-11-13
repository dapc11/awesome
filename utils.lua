local clock = os.clock
local M = {}
function M.sleep(n) -- seconds
  local t0 = clock()
  while clock() - t0 <= n do
  end
end

return M
