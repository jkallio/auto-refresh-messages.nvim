local M = { timer = nil, opts = { interval = 1000, silent = false } }

M.setup = function(opts)
    if opts ~= nil then
        M.opts = vim.tbl_extend('force', M.opts, opts or {})
    end
end

function M.toggle()
    if M.timer == nil then
        M.start()
    else
        M.stop()
    end
end

function M.start()
    if M.timer ~= nil then
        if (not M.opts.silent) then
            vim.api.nvim_err_writeln("Message refresh loop is already running")
        end
        return
    end

    if (not M.opts.silent) then
        print("Start refreshing messages buffer " .. M.opts.interval .. "ms")
    end
    M.timer = vim.uv.new_timer()
    M.timer:start(1000, M.opts.interval, vim.schedule_wrap(function()
        vim.cmd('messages')
    end))
end

function M.stop()
    if M.timer ~= nil then
        if (not M.opts.silent) then
            print("Stop refreshing messages buffer")
        end
        M.timer:close()
        M.timer = nil
    end
end

return M
