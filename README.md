### Quick Start

Use GitHub Codespaces - it's the fastest way to get started:

<img width="438" height="463" alt="image" src="https://github.com/user-attachments/assets/a7336c87-4958-4c5f-8d90-5dcc2b73a55d" />

### Install Python packages

```bash
uv sync
```

### Usage

Navigate to a lab directory (e.g., `L1`) and run:

```bash
make build
```

**This will:**

1. Run calculations (`calc.py` if present)
2. Compile the Typst document to PDF

### Lab Report Workflow

Here's the complete process for creating a lab report:

1. **Configure course details** - Edit `config.toml` in the project root:
   - Set course name, schedule, and student member information
   
2. **Create lab directory** - Each lab gets its own directory (e.g., `L1/`, `L2/`)

3. **Set up lab data** - Create `input.toml` in the lab directory:
   - Define lab title, subtitle, and parameters
   - Include measurement data and experimental values
   
4. **Write calculations** - Create `calc.py` to process the input data:
   - Load data from `input.toml`
   - Perform statistical calculations and error analysis
   - Save results to `output.toml` for use in the report
   
5. **Write report content** - Create Typst files for each section:
   - Break content into logical sections (e.g., `00-intro.typ`, `01-analysis.typ`)
   - Use data from `output.toml` in your Typst templates
   
6. **Create main template** - Set up `main.typ`:
   - Import shared styling from `../common.typ`
   - Load configuration and output data
   - Include all section files
   
7. **Build the report** - Run `make build` to generate the final PDF:
   - Executes `calc.py` if present
   - Compiles Typst document to PDF
   - Output: `{lab_directory_name}.pdf`

### Development

For auto-rebuild on file changes:

```bash
make dev
```

### Configuration

- Edit `config.toml` in the project root for course info and student details
- Each lab has its own `input.toml` for lab-specific parameters

### Structure

```
labgen/
├── L1/, L2/, etc.   # Individual lab directories
├── *.typ            # Shared Typst code
├── *.py             # Shared Python code
├── fonts/           # Custom fonts for Typst compilation
└── Makefile.tpl     # Shared build configuration
```

### Requirements

| Tool             | Links                                                                                                                                   |
| ---------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| **uv**           | [site](https://astral.sh/uv) • [docs](https://docs.astral.sh/uv/) • [install](https://docs.astral.sh/uv/getting-started/installation/)  |
| **Make**         | [tutorial](https://learnxinyminutes.com/make/) • [install](https://itsfoss.com/make-command-not-found-ubuntu/)                          |
| **Python**       | [site](https://www.python.org/) • [docs](https://docs.python.org/) • [install](https://realpython.com/installing-python/)               |
| **Typst**        | [site](https://typst.app/) • [docs](https://typst.app/docs/) • [install](https://github.com/typst/typst#installation)                   |
| **watchexec**    | [site](https://watchexec.github.io/) • [docs](https://watchexec.github.io/) • [install](https://github.com/watchexec/watchexec#install) |
