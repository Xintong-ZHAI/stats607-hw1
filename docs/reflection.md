# Reflection

The original state of my analysis was not reproducible. I only had one long R Markdown file, with all data cleaning, models, and plots together. Packages were installed directly on my laptop, and results were not organized into folders.

The biggest challenge in the transformation was learning how to use git and renv. I often had errors with missing packages or push conflicts. It was also hard for me to split code into a pipeline script and tests.

The most important improvements for reproducibility were:
- Using renv to record package versions.
- Writing a single run_analysis.R so results can be reproduced with one command.
- Adding tests to check data validity and output files.

In a future project, I would start with a clean folder structure and version control from the beginning. I would also try to write tests earlier, not only at the end.

Approximate time:
- Setting up Git and GitHub: ~2 hours
- Learning and using renv: ~2 hours
- Rewriting the analysis script: ~3 hours
- Writing tests and documentation: ~2 hours
