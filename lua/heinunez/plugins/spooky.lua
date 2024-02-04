local ok, spooky = pcall(require, "spooky")

if not ok then
  return
end

spooky.setup({
  auto_use_only = false,
  ui = {
    select = "telescope"
  }
})

