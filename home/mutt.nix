{ ... }:
{
  programs = {
    mbsync.enable = true;
    msmtp.enable = true;
    neomutt.enable = true;
  };

  programs.neomutt = {
    editor = "nvim";
    vimKeys = true;
    checkStatsInterval = 60;
    sidebar = {
      enable = true;
      width = 24;
      shortPath = true;
    };
    binds = [
      {
        map = [ "index" "pager" ];
        key = "\\Cb";
        action = "<enter-command>toggle sidebar_visible<enter><refresh>";
      }
    ];
    macros = [
      {
        map = [ "index" "pager" ];
        key = "<f5>";
        action = "<shell-escape>mbsync -a<enter>";
      }
    ];
    settings = {
      sort = "threads";
      sort_aux = "last-date-received";
      pager_index_lines = "8";
    };
    extraConfig = ''
      set mail_check_stats
      alternative_order text/plain text/html text/*
      color status brightwhite blue
      color index brightyellow default "~N"
      color index brightcyan default "~T"
      color index brightgreen default "~F"
      color index brightmagenta default "~p"
      color index brightred default "~D"
      color header yellow default "^Subject:"
      color header cyan default "^From:"
      color header green default "^To:"
      color header magenta default "^Date:"
      color sidebar_new brightgreen default
      color sidebar_flagged brightyellow default
      set status_format="[%r] %f %h %m (%?M?%M/?%m) %?p?%p%%? %> %?d?%d? %?t?%t? %?n?%n? %?O?%O? %?S?%S?"
    '';
  };

  accounts.email = {
    accounts.gmx = {
      primary = true;
      address = "schmiddim@gmx.at";
      realName = "Michael Schmitt";
      userName = "schmiddim@gmx.at";
      passwordCommand = [
        "bash"
        "-lc"
        "source \"$HOME/.config/zsh/env.secrets\"; printf %s \"$GMX_MAIL_PASSWD\""
      ];
      imap = {
        host = "imap.gmx.net";
        port = 993;
        tls.enable = true;
      };
      smtp = {
        host = "mail.gmx.net";
        port = 587;
        tls = {
          enable = true;
          useStartTls = true;
        };
      };
      folders = {
        inbox = "INBOX";
        sent = "Sent";
        drafts = "Drafts";
        trash = "Trash";
      };
      signature = {
        showSignature = "append";
        text = ''
          Michael Schmitt
          Hermine-von-Parish-Straße 74
          81245 München
          01719579720
        '';
      };
      mbsync.enable = true;
      msmtp.enable = true;
      neomutt = {
        enable = true;
        mailboxType = "maildir";
        extraMailboxes = [
          "Sent"
          "Drafts"
          "Trash"
        ];
      };
    };
  };

  services.mbsync = {
    enable = true;
    frequency = "*:0/5";
  };
}
