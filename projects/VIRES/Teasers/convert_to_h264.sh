#!/bin/bash

# 获取当前文件夹中的所有视频文件
for file in *; do
  # 跳过非视频文件，根据扩展名过滤
  if [[ "$file" == *.mp4 || "$file" == *.mkv || "$file" == *.avi || "$file" == *.mov || "$file" == *.flv || "$file" == *.wmv ]]; then
    # 获取文件扩展名
    extension="${file##*.}"
    
    # 创建带有原始扩展名的临时输出文件名
    temp_output="${file%.*}_tmp.${extension}"

    # 使用 ffmpeg 转换为 H.264
    ffmpeg -i "$file" -c:v libx264 -preset slow -crf 23 -c:a aac -b:a 128k "$temp_output"

    # 检查转换是否成功
    if [[ $? -eq 0 ]]; then
      # 用临时文件替换原文件
      mv "$temp_output" "$file"
      echo "转换完成并覆盖: $file"
    else
      # 删除临时文件并报错
      rm -f "$temp_output"
      echo "转换失败: $file"
    fi
  else
    echo "跳过非视频文件: $file"
  fi
done
