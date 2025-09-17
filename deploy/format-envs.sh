#!/bin/bash
# 遍历当前目录及子目录，格式化所有 *.env 文件（原地覆盖）

find . -type f -name "*.env" | while read -r file; do
	echo "📂 格式化: $file"

	tmpfile=$(mktemp)

	# 计算 KEY 的最大长度
	max_len=$(grep -vE '^\s*#|^\s*$' "$file" | cut -d= -f1 | awk '{print length}' | sort -nr | head -1)

	# 格式化
	while IFS= read -r line; do
		if [[ "$line" =~ ^[[:space:]]*# || -z "$line" ]]; then
			echo "$line" >>"$tmpfile"
		else
			key=$(echo "$line" | cut -d= -f1 | xargs)
			value=$(echo "$line" | cut -d= -f2-)
			printf "%-${max_len}s = %s\n" "$key" "$value" >>"$tmpfile"
		fi
	done <"$file"

	mv "$tmpfile" "$file"
done

echo "✅ 所有 *.env 文件格式化完成！"
