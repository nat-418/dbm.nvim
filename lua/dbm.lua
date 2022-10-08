local M = {}

M.split_window = function(buffer_number)
  local current_tab_number = vim.fn.tabpagenr()
  local number_of_windows_in_tab = vim.fn.tabpagewinnr(current_tab_number, '$')

  if (number_of_windows_in_tab == 1) then
    vim.api.nvim_command('vert belowright sbuffer ' .. buffer_number)
  else
    vim.cmd('wincmd l')
    vim.api.nvim_command('belowright sbuffer ' .. buffer_number)
  end
end

M.swap = function()
  local buffer_number_list = vim.fn.tabpagebuflist()
  local selected_buffer_number = vim.fn.bufnr()
  local main_buffer_number = buffer_number_list[1]

  if (selected_buffer_number ~= main_buffer_number) then
    local cursor_position = vim.fn.getpos('.')
    vim.cmd('wincmd h')
    vim.cmd('buffer ' .. selected_buffer_number)
    vim.cmd('wincmd p')
    vim.cmd('buffer ' .. main_buffer_number)
    vim.cmd('wincmd h')
    vim.fn.setpos('.', cursor_position)
  end
end

M.split = function(target)
  local current_buffer_name = vim.fn.bufname()
  local current_tab_number  = vim.fn.tabpagenr()
  local number_of_windows   = vim.fn.tabpagewinnr( current_tab_number, '$')

  if target == nil then target = '' end

  if (current_buffer_name == '') then
    vim.api.nvim_command('edit ' .. target)
  else
    if (number_of_windows == 1) then
      vim.api.nvim_command('vert belowright split ' .. target)
    else
      vim.cmd('wincmd l')
      vim.api.nvim_command('belowright split ' .. target)
    end
  end
end

M.is_focus_window_toggled = false

M.focus = function()
  if M.is_focus_window_toggled then
    vim.cmd('wincmd =')
    M.is_focus_window_toggled = false
  else
    vim.cmd('wincmd _')
    vim.cmd('wincmd |')
    M.is_focus_window_toggled = true
  end
end

M.go = function(target_number)
  local number_of_tabs = vim.fn.tabpagenr('$')

  while (number_of_tabs < target_number)
    do
      vim.api.nvim_command('tabnew')
      number_of_tabs = vim.fn.tabpagenr('$')
    end

  vim.cmd('normal ' .. target_number .. 'gt')
end

M.send = function(target_number)
  local current_buffer_number = vim.fn.bufnr()
  local current_tab_number = vim.fn.tabpagenr()

  M.go(target_number)

  local number_of_windows = vim.fn.tabpagewinnr(target_number, '$')

  vim.api.nvim_command('normal ' .. target_number .. 'gt')

  if (number_of_windows == 1) then
    local lone_buffer_name = vim.fn.bufname(
      vim.fn.tabpagebuflist(target_number)[1]
    )

    if (lone_buffer_name == '') then
      vim.api.nvim_command('buffer ' .. current_buffer_number)
    else
      M.split_window(current_buffer_number)
    end
  else
      M.split_window(current_buffer_number)
  end

  vim.api.nvim_command('normal ' .. current_tab_number .. 'gt')
end

M.next = function() vim.cmd('wincmd w') end

M.cmd = function(args)
  local string2list = function(string)
    local list = {}
    for each in string:gmatch("%w+") do table.insert(list, each) end
    return list
  end

  local parsed = string2list(args.args)

  local subcmd = parsed[1]
  local arg1   = parsed[2]

  if subcmd == 'next'  then M.next()               end
  if subcmd == 'split' then M.split(arg1)          end
  if subcmd == 'swap'  then M.swap()               end
  if subcmd == 'focus' then M.focus()              end
  if subcmd == 'send'  then M.send(tonumber(arg1)) end
  if subcmd == 'go'    then M.go(tonumber(arg1))   end
end


M.setup = function()
  local completion = function(_, _, _)
    return {
      'next',
      'split',
      'swap',
      'focus',
      'send',
      'go'
    }
  end

  vim.api.nvim_create_user_command(
    'DBM',
    function(args) M.cmd(args) end,
    {nargs = '*', complete = completion}
  )
end

return M
