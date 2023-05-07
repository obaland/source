-- plugin: vfiler.vim
-- see: https://github.com/obaland/vfiler.vim

local exprolorer_bufnrs = {}

local M = {}

function M.setup()
  -- column settings
  require('vfiler/columns/indent').setup({
    icon = '',
  })

  require('vfiler/config').setup({
    options = {
      columns = 'indent,devicons,name,mode,size,time',
      session = 'share',
      toggle = true,
    },
  })
end

function M.start_exprolorer()
  local action = require('vfiler/action')

  local configs = {
    options = {
      auto_cd = true,
      auto_resize = true,
      find_file = true,
      header = false,
      keep = true,
      name = 'exp',
      layout = 'left',
      width = 36,
      columns = 'indent,devicons,name,git',
      git = {
        enabled = true,
        untracked = true,
        ignored = true,
      },
    },

    mappings = {
      ['<C-j>'] = action.move_cursor_bottom_sibling,
      ['<C-k>'] = action.move_cursor_top_sibling,
      ['J'] = action.loop_cursor_down_sibling,
      ['K'] = action.loop_cursor_up_sibling,
    },
  }

  local path = vim.fn.bufname(vim.fn.bufnr())
  if vim.fn.isdirectory(path) ~= 1 then
    path = vim.fn.getcwd()
  end
  path = vim.fn.fnamemodify(path, ':p:h')

  local vfiler = require('vfiler')
  vfiler.start(path, configs)

  local status = vfiler.status(0)
  if status.bufnr then
    exprolorer_bufnrs[vim.fn.tabpagenr()] = status.bufnr
  end
end

function M.get_exprolorer_status(tabpagenr)
  tabpagenr = tabpagenr or vim.fn.tabpagenr()
  local bufnr = exprolorer_bufnrs[tabpagenr]
  if not bufnr then
    return {}
  end
  return require('vfiler').status(bufnr)
end

return M
