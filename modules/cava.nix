{ config, pkgs, ... }:

{
  programs.cava = {
    enable = true;
    
    settings = {
      general = {
        # 模式：normal, scientific, waves
        mode = "normal";
        
        # 幀率
        framerate = 60;
        
        # 自動敏感度調整
        autosens = 1;
        
        # 靈敏度百分比
        sensitivity = 100;
        
        # 條數
        bars = 0;  # 0 = 自動根據終端寬度
        
        # 條寬度
        bar_width = 2;
        
        # 條間距
        bar_spacing = 1;
        
        # 低頻截止
        lower_cutoff_freq = 50;
        
        # 高頻截止  
        higher_cutoff_freq = 10000;
      };

      input = {
        # 音頻輸入方法：pulse, alsa, fifo, sndio, shmem, portaudio
        method = "pulse";
        
        # PulseAudio 來源（留空自動偵測）
        source = "auto";
      };

      output = {
        # 輸出方法：ncurses, noncurses, raw, noritake, circle
        method = "ncurses";
        
        # ncurses 輸出樣式：stereo, mono
        style = "stereo";
        
        # 反向顯示
        reverse = 0;
        
        # 原始輸出目標
        # raw_target = "/dev/stdout";
        
        # 資料格式：binary, ascii
        # data_format = "binary";
        
        # ASCII 字符範圍（從低到高）
        # ascii_max_range = 1000;
        
        # 位元格式：8bit, 16bit
        # bit_format = "16bit";
        
        # Channels
        channels = "stereo";
      };

      color = {
        # 漸層模式：1 = 啟用
        gradient = 1;
        
        # 漸層顏色數量
        gradient_count = 6;
        
        # 漸層顏色（白色系震撼感）
        # 從底部到頂部：深灰 → 銀白 → 純白 → 亮白 → 極亮白 → 爆閃白
        gradient_color_1 = "'#4a4a4a'";
        gradient_color_2 = "'#a8a8a8'";
        gradient_color_3 = "'#e0e0e0'";
        gradient_color_4 = "'#f5f5f5'";
        gradient_color_5 = "'#ffffff'";
        gradient_color_6 = "'#ffffff'";
      };

      smoothing = {
        # 蒙特卡洛平滑：0 = 關閉
        monstercat = 0;
        
        # 波浪平滑：0 = 關閉
        waves = 0;
        
        # 重力：0-1000，數字越大下降越慢
        gravity = 200;
        
        # 噪音抑制：0-1
        noise_reduction = 0.77;
        
        # 積分：0-1，數字越大平滑越多
        integral = 0.7;
      };

      eq = {
        # 均衡器 (1-10 為 10 個頻段)
        # 格式：頻率:增益
        # 1 = "50:1";
        # 2 = "100:1";
        # 3 = "200:1";
        # 4 = "400:1";
        # 5 = "800:1";
        # 6 = "1600:1";
        # 7 = "3200:1";
        # 8 = "6400:1";
        # 9 = "12800:1";
        # 10 = "20000:1";
      };
    };
  };

  # 可選：創建啟動腳本
  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "cava-fullscreen" ''
      #!/usr/bin/env bash
      # 全螢幕震撼模式
      kitty --class cava-fullscreen -o font_size=8 -o background_opacity=0.85 -e cava
    '')
  ];
}
