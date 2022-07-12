local configs = {
  lazy = {},
  start = {},
}

local Plug = {
  begin = vim.fn["plug#begin"],
  ends = function()
    vim.call("plug#end")
    for _, config in pairs(configs.start) do
      config()
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

local meta = {
  __call = function(_, src, opts)
    opts = opts or vim.empty_dict()
    opts["do"] = opts.run
    opts.run = nil
    opts["for"] = opts.ft
    opts.ft = nil

    if type(opts.preload) == "function" then
      opts.preload()
    end

    vim.call("plug#", src, opts)

    if type(opts.config) == "function" then
      local plugin = opts.as or plug_name(src)
      if opts["for"] == nil and opts.on == nil then
        configs.start[plugin] = opts.config
      else
        configs.lazy[plugin] = opts.config

        local user_cmd = [[ autocmd! User %s ++once lua VimPlugApplyConfig('%s') ]]
        vim.cmd(user_cmd:format(plugin, plugin))
      end
    end
  end
}

return setmetatable(Plug, meta)
