#!/usr/bin/env bash
set -euo pipefail

root="${1:-}"
if [[ -z "$root" ]]; then
  echo "make_error_pdf.sh: missing rootname argument (expected e.g. main)" >&2
  exit 2
fi

log="${root}.log"
pdf="${root}.pdf"

# Pull the first useful error line:
err="$(
  { grep -m1 -E '^[^:]+:[0-9]+:|^!' "$log" || true; } | head -n1
)"
if [[ -z "$err" ]]; then
  err="Build failed. See ${log} for details."
fi

cat > __build_error__.tex <<EOF
\\documentclass{article}
\\usepackage[margin=2cm]{geometry}
\\usepackage[T1]{fontenc}
\\usepackage{listings}
\\begin{document}
\\thispagestyle{empty}
\\section*{Build failed}
\\noindent\\textbf{First error:}
\\begin{lstlisting}
$err
\\end{lstlisting}
\\bigskip
\\noindent Full log: \\texttt{$log}
\\end{document}
EOF

lualatex -interaction=nonstopmode -halt-on-error __build_error__.tex >/dev/null 2>&1
mv -f __build_error__.pdf "$pdf"

