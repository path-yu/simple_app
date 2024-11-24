
flutter build web --release --web-renderer auto

# 创建目标目录 
TARGET_DIR="my_webApp"
mkdir -p $TARGET_DIR # 移动生成的文件到目标目录
mv build/web/* $TARGET_DIR