return {
  {
    "leoluz/nvim-dap-go",
    config = function()
      require("dap-go").setup()

      require("dap").adapters.drone_api_remote = {
        type = "server",
        host = "osmose-flightai.local",
        port = 2345,
      }
    end,
  },
}
