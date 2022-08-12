local configs = {
  lazy = {},
  start = {},
}

local Plug = {
  begin = vim.fn["plug#begin"],
  ends = function()
    vim.call("plug#end")
    for plug_name, config in pairs(configs.start) do
      if not pcall(config) then
        vim.notify("failed to load config for " .. plug_name)
      end
    end
  end
}

_G.VimPlugApplyConfig = function(plugin)
  local fn = configs.lazy[plugin]
  if type(fn) == "function" then
    fn()
  end
end

local plug_name = function(src)
  return src:match("^[%w-]+/([%w-_.]+)$")
end

function table.contains(tbl, value)
  for _, val in pairs(tbl) do
    if val == value then
      return true
    end
  end
  return false
end

local meta = {
  __call = function(_, src, opts)
    opts = opts or vim.empty_dict()
    opts["do"] = opts.run
    opts.run = nil
    opts["for"] = opts.ft
    opts.ft = nil

    local plugin = opts.as or plug_name(src)
    if type(opts.preload) == "function" then
      if not pcall(opts.preload) then
        vim.notify("failed to preload " .. plugin)
      end
    end

    if opts.except then
      opts["for"] = {}
    end

    vim.call("plug#", src, opts)

    if type(opts.config) == "function" then
      if opts["for"] == nil and opts.on == nil then
        configs.start[plugin] = opts.config
      else
        configs.lazy[plugin] = opts.config

        if opts.except then
          function LoadPlugin()
            local ft = vim.fn.expand("<amatch>")
            if not table.contains(opts.except, ft) then
              vim.call("plug#load", plugin)
            end
          end

          local load_cmd = [[
            augroup plug_x%s
              autocmd FileType * ++once lua LoadPlugin()
            augroup END
          ]]
          vim.cmd(load_cmd:format(plugin))
        end

        local user_cmd = [[ autocmd! User %s ++once lua VimPlugApplyConfig('%s') ]]
        vim.cmd(user_cmd:format(plugin, plugin))
      end
    end
  end
}

return setmetatable(Plug, meta)
