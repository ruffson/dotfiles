return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    local sk = LazyVim.opts("sidekick.nvim") ---@type sidekick.Config|{}
    if vim.tbl_get(sk, "nes", "enabled") ~= false then
      opts.servers = opts.servers or {}
      opts.servers.copilot = opts.servers.copilot or {}
    end
  end,
}
