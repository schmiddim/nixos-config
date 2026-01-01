{ ... }:

{
  services.kanshi = {
    enable = true;

    settings = [

      {
        profile = {
          name = "zuhause";

          outputs = [
            {
              criteria = "Iiyama North America PL2760H 1164011302154";
              mode = "1920x1080";
              position = "0,0";
              scale = 1.0;
              status = "enable";
            }

            {
              criteria = "Iiyama North America PL2790 11306JK401162";
              mode = "1920x1080@60Hz";
              position = "1920,0";
              scale = 1.0;
              status = "enable";
            }

            {
              criteria = "eDP-1";
              status = "disable";
            }
          ];
        };
      }

      {
        profile = {
          name = "unterwegs";
          outputs = [
            {
              criteria = "eDP-1";
              mode = "1920x1080@60.027Hz";
              position = "0,0";
              scale = 1.0;
              status = "enable";
            }
            {
              criteria = "DVI-I-1";
              status = "disable";
            }
            {
              criteria = "DVI-I-2";
              status = "disable";
            }
          ];
        };
      }
    ];
  };
}
