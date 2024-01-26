local autopairs_setup, autopairs = pcall(require, "nvim-autopairs")

if not autopairs_setup then
  return
end

autopairs.setup({
  check_ts = true, -- enable treesiter
  ts_config = {
    lua = { "string" },
    javascript = { "template_string" },
    java = false,
  }
})

local cmp_autopairs_setup, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")

if not autopairs then
  return
end

local cmp_setup, cmp = pcall(require, "cmp")

if not cmp_setup then
  return
end

cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

