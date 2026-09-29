local java_home = "/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home"

return {
  {
    "mfussenegger/nvim-jdtls",
    init = function()
      if vim.fn.isdirectory(java_home) == 1 then
        vim.env.JAVA_HOME = java_home
        vim.env.PATH = java_home .. "/bin:" .. (vim.env.PATH or "")
      end
    end,
  },
}
