{
  programs.lazyvim.plugins.pomo = ''
    return {
      "epwalsh/pomo.nvim",
      version = "*",
      lazy = true,
      cmd = { "TimerStart", "TimerRepeat", "TimerSession" },
      opts = {
        update_interval = 1000,
        notifiers = {
          {
            name = "Default",
            opts = {
              sticky = false,
              title_icon = "󱎫",
              text_icon = "󰄉",
            },
          },
          { name = "System" },
        },
        timers = {
          Break = { { name = "System" } },
        },
        sessions = {
          pomodoro = {
            { name = "Work",        duration = "25m" },
            { name = "Short Break", duration = "5m"  },
            { name = "Work",        duration = "25m" },
            { name = "Short Break", duration = "5m"  },
            { name = "Work",        duration = "25m" },
            { name = "Long Break",  duration = "15m" },
          },
        },
      },
    }
  '';
}
