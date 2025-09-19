
# 清理 DS_Store 文件
# 在任意目录下执行，清理当前目录及子目录

find . -name ".DS_Store" -type f -print -delete


# 删除本地所有被 .gitignore 忽略的文件

# •	-f 表示强制执行（必须加上，否则不会删除）。
# •	-d 表示连目录也一起清理。
# •	-X 表示只删除 被 .gitignore 忽略的文件。

# git clean -fdnX   # 仅列出会删除的被忽略文件
# git clean -fdnx   # 仅列出会删除的所有未跟踪文件
git clean -fdX