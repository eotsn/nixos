{
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    sensibleOnTop = true;
    terminal = "tmux-256color";
    extraConfig = ''
      set -as terminal-features ',xterm-256color:RGB'
      set -g status-style 'bg=default,fg=#89b4fa,bold'
      set-option -g allow-passthrough on
      set -s escape-time 0
    '';
  };
}
