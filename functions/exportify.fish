function exportify
  rm -f index.ts

  for f in *.ts *.tsx
    if string match -q '*.config.ts' $f
      continue
    end
    set -l base (path change-extension '' $f)
    if grep -q 'export default' $f
      echo "export { default as $base } from './$base';" >> index.ts
    end
    echo "export * from './$base';" >> index.ts
  end
end

