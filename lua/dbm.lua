local function press_keys(keys)
  vim.cmd(vim.api.nvim_replace_termcodes('normal ' .. keys, true, true, true))
end

local M = {}

M.split_buffer = function(buffer_number)
  local current_tab_number = vim.fn.tabpagenr()
  local number_of_windows_in_tab = vim.fn.tabpagewinnr(current_tab_number, '$')

  if (number_of_windows_in_tab == 1) then
    vim.api.nvim_command('vert belowright sbuffer ' .. buffer_number)
  else
    press_keys('<C-w>l')
    vim.api.nvim_command('belowright sbuffer ' .. buffer_number)
  end
end

M.swap_buffer = function()
  local buffer_number_list = vim.fn.tabpagebuflist()
  local selected_buffer_number = vim.fn.bufnr()
  local main_buffer_number = buffer_number_list[1]

  if (selected_buffer_number ~= main_buffer_number) then
    local cursor_position = vim.fn.getpos('.')
    press_keys('<C-w>h')
    vim.cmd('buffer ' .. selected_buffer_number)
    press_keys('<C-w>p')
    vim.cmd('buffer ' .. main_buffer_number)
    press_keys('<C-w>h')
    vim.fn.setpos('.', cursor_position)
  end
end

M.split = function(target)
  local current_buffer_name = vim.fn.bufname()
  local current_tab_number  = vim.fn.tabpagenr()
  local number_of_windows   = vim.fn.tabpagewinnr( current_tab_number, '$')

  if (current_buffer_name == '') then
    vim.api.nvim_command('edit ' .. target)
  else
    if (number_of_windows == 1) then
      vim.api.nvim_command('vert belowright split ' .. target)
    else
      press_keys('<C-w>l')
      vim.api.nvim_command('belowright split ' .. target)
    end
  end
end

M.is_focus_buffer_toggled = false

M.toggle_focus_buffer = function()
  if M.is_focus_buffer_toggled then
    press_keys('<C-w>=')
    M.is_focus_buffer_toggled = false
  else
    press_keys('<C-w>_<C-w>|')
    M.is_focus_buffer_toggled = true
  end
end

M.view_or_create_tab = function(target_number)
  local number_of_tabs = vim.fn.tabpagenr('$')

  while (number_of_tabs < target_number)
    do
      vim.api.nvim_command('tabnew')
      number_of_tabs = vim.fn.tabpagenr('$')
    end

  vim.cmd('normal ' .. target_number .. 'gt')
end

M.move_to_tab = function(target_number)
  local current_buffer_number = vim.fn.bufnr()
  local current_tab_number = vim.fn.tabpagenr()

  M.view_or_create_tab(target_number)

  local number_of_windows = vim.fn.tabpagewinnr(target_number, '$')

  vim.api.nvim_command('normal ' .. target_number .. 'gt')

  if (number_of_windows == 1) then
    local lone_buffer_name = vim.fn.bufname(
      vim.fn.tabpagebuflist(target_number)[1]
    )

    if (lone_buffer_name == '') then
      vim.api.nvim_command('buffer ' .. current_buffer_number)
    else
      M.split_buffer(current_buffer_number)
    end
  else
      M.split_buffer(current_buffer_number)
  end

  vim.api.nvim_command('normal ' .. current_tab_number .. 'gt')
end

M.setup = function()
  vim.api.nvim_add_user_command(
    'DBMNextBuffer',
    function() press_keys('<C-w><C-w>') end,
    {nargs = 0}
  )

  vim.api.nvim_add_user_command(
    'DBMSplit',
    function(args) M.split(args.args) end,
    {nargs = '*', complete='file'}
  )

  vim.api.nvim_add_user_command(
    'DBMSplitBuffer',
    M.split_buffer,
    {nargs = 1}
  )

  vim.api.nvim_add_user_command(
    'DBMSwapBuffer',
    M.swap_buffer,
    {nargs = 0}
  )

  vim.api.nvim_add_user_command(
    'DBMToggleFocusBuffer',
    M.toggle_focus_buffer,
    {nargs = 0}
  )

  vim.api.nvim_add_user_command(
    'DBMViewTab',
    function(args)
      M.view_or_create_tab(tonumber(args.args))
    end,
    {nargs = 1}
  )

  vim.api.nvim_add_user_command(
    'DBMMoveToTab',
    function(args)
      M.move_to_tab(tonumber(args.args))
    end,
    {nargs = 1}
  )
end

return M
