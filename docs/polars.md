# Polars for Ruby

This document provides a comprehensive overview of the Polars for Ruby library, focusing on concise explanations and practical code examples.

## Getting Started

First, install the `polars-df` gem.

```sh
gem install polars-df
```

Then, you can create your first DataFrame:

```ruby
require "polars-df"

df = Polars::DataFrame.new(
  {
    "A" => [1, 2, 3, 4, 5],
    "fruits" => ["banana", "banana", "apple", "apple", "banana"],
    "B" => [5, 4, 3, 2, 1],
    "cars" => ["beetle", "audi", "beetle", "beetle", "beetle"]
  }
)

puts df
```

```text
shape: (5, 4)
┌─────┬────────┬─────┬────────┐
│ A   ┆ fruits ┆ B   ┆ cars   │
│ --- ┆ ---    ┆ --- ┆ ---    │
│ i64 ┆ str    ┆ i64 ┆ str    │
╞═════╪════════╪═════╪════════╡
│ 1   ┆ banana ┆ 5   ┆ beetle │
│ 2   ┆ banana ┆ 4   ┆ audi   │
│ 3   ┆ apple  ┆ 3   ┆ beetle │
│ 4   ┆ apple  ┆ 2   ┆ beetle │
│ 5   ┆ banana ┆ 1   ┆ beetle │
└─────┴────────┴─────┴────────┘
```

## Data Structures

### DataFrame

A `DataFrame` is a 2D data structure that is composed of `Series`.

#### Initialization

```ruby
# From a hash of arrays/ranges
df = Polars::DataFrame.new(
  {"a" => 1..3, "b" => ["one", "two", "three"]}
)

# From an array of hashes
df = Polars::DataFrame.new([
  {"a" => 1, "b" => "one"},
  {"a" => 2, "b" => "two"},
  {"a" => 3, "b" => "three"}
])

# From an array of Series
df = Polars::DataFrame.new([
  Polars::Series.new("a", [1, 2, 3]),
  Polars::Series.new("b", ["one", "two", "three"])
])

# With schema definition
df = Polars::DataFrame.new(
  {"a" => [DateTime.new(2022, 1, 1)]},
  schema: {"a" => Polars::Datetime.new("ms")}
)
```

#### Attributes

*   `df.shape` -> `[rows, columns]`
*   `df.height` -> Number of rows
*   `df.width` -> Number of columns
*   `df.columns` -> `["col1", "col2", ...]`
*   `df.dtypes` -> `[Polars::DataType, ...]`
*   `df.schema` -> `{"col1" => Polars::DataType, ...}`

```ruby
df = Polars::DataFrame.new({"a" => [1, 2], "b" => ["one", "two"]})

df.shape
# => [2, 2]

df.columns
# => ["a", "b"]

df.dtypes
# => [Polars::Int64, Polars::String]
```

#### Column Selection

```ruby
df = Polars::DataFrame.new(
  {
    "a" => [1, 2, 3],
    "b" => [4, 5, 6],
    "c" => [7, 8, 9]
  }
)

# Select a single column, returns a Series
df["a"]
# =>
# shape: (3,)
# Series: 'a' [i64]
# [
#         1
#         2
#         3
# ]

# Select multiple columns, returns a DataFrame
df[["a", "c"]]
# =>
# shape: (3, 2)
# ┌─────┬─────┐
# │ a   ┆ c   │
# │ --- ┆ --- │
# │ i64 ┆ i64 │
# ╞═════╪═════╡
# │ 1   ┆ 7   │
# │ 2   ┆ 8   │
# │ 3   ┆ 9   │
# └─────┴─────┘
```

#### Row Selection

```ruby
df = Polars::DataFrame.new({"a" => 0..4, "b" => 5..9})

# Select a single row by index
df[2]
# =>
# shape: (1, 2)
# ┌─────┬─────┐
# │ a   ┆ b   │
# │ --- ┆ --- │
# │ i64 ┆ i64 │
# ╞═════╪═════╡
# │ 2   ┆ 7   │
# └─────┴─────┘

# Select rows with a slice
df[1..3]
# =>
# shape: (3, 2)
# ┌─────┬─────┐
# │ a   ┆ b   │
# │ --- ┆ --- │
# │ i64 ┆ i64 │
# ╞═════╪═════╡
# │ 1   ┆ 6   │
# │ 2   ┆ 7   │
# │ 3   ┆ 8   │
# └─────┴─────┘

# Select rows with a boolean Series
df[df["a"].is_even]
# =>
# shape: (3, 2)
# ┌─────┬─────┐
# │ a   ┆ b   │
# │ --- ┆ --- │
# │ i64 ┆ i64 │
# ╞═════╪═════╡
# │ 0   ┆ 5   │
# │ 2   ┆ 7   │
# │ 4   ┆ 9   │
# └─────┴─────┘
```

#### Element Selection

```ruby
df = Polars::DataFrame.new({"a" => [1, 2, 3], "b" => [4, 5, 6]})

# Get element by row and column index
df[1, 1]
# => 5

# Get element by row index and column name
df[2, "a"]
# => 3
```

#### Methods

For a full list of methods, see the sections below. Key methods include:
*   `select`
*   `with_columns`
*   `filter`
*   `group_by`
*   `join`

### Series

A `Series` is a 1D data structure that is the building block of a `DataFrame`.

#### Initialization

```ruby
# From an array
s = Polars::Series.new("a", [1, 2, 3])

# With a specific dtype
s = Polars::Series.new("b", [1.0, 2.0], dtype: Polars::Float32)

# From a Range
s = Polars::Series.new("c", 1..3)
```

#### Attributes
*   `s.name` -> Name of the series
*   `s.dtype` -> `Polars::DataType` of the series
*   `s.len` -> Length of the series
*   `s.shape` -> `[length]`

#### Indexing

```ruby
s = Polars::Series.new("a", [10, 20, 30, 40])

s[1]
# => 20

s[-1]
# => 40

s[1..2]
# =>
# shape: (2,)
# Series: 'a' [i64]
# [
#         20
#         30
# ]
```

#### Methods

Many `Series` methods are also available as `Expr` methods, allowing them to be used inside `select`, `group_by`, etc. They can also be called directly on a `Series` object for eager execution.

*   **Arithmetic**: `+`, `-`, `*`, `/`, `%`
*   **Comparison**: `==`, `!=`, `>`, `<`, `>=`, `<=`
*   **Aggregation**: `sum`, `mean`, `min`, `max`, `std`, `var`, `median`, `quantile`
*   **Transformation**: `sort`, `filter`, `map_elements`, `round`, `clip`, `cast`

## I/O (Reading & Writing Data)

### CSV

*   `Polars.read_csv(source, **options)`
*   `Polars.scan_csv(source, **options)`
*   `df.write_csv(file, **options)`
*   `ldf.sink_csv(path, **options)`

```ruby
# Write a DataFrame to a CSV file
df = Polars::DataFrame.new({"a" => [1, 2, 3], "b" => ["one", "two", "three"]})
df.write_csv("data.csv")
File.read("data.csv")
# => "a,b\n1,one\n2,two\n3,three\n"

# Read from a CSV file
Polars.read_csv("data.csv")
# =>
# shape: (3, 2)
# ┌─────┬───────┐
# │ a   ┆ b     │
# │ --- ┆ ---   │
# │ i64 ┆ str   │
# ╞═════╪═══════╡
# │ 1   ┆ one   │
# │ 2   ┆ two   │
# │ 3   ┆ three │
# └─────┴───────┘

# Lazily scan a CSV for memory-efficient queries
Polars.scan_csv("data.csv").filter(Polars.col("a") > 2).collect
# =>
# shape: (1, 2)
# ┌─────┬───────┐
# │ a   ┆ b     │
# │ --- ┆ ---   │
# │ i64 ┆ str   │
# ╞═════╪═══════╡
# │ 3   ┆ three │
# └─────┴───────┘
```

### Parquet

*   `Polars.read_parquet(source, **options)`
*   `Polars.scan_parquet(source, **options)`
*   `df.write_parquet(file, **options)`
*   `ldf.sink_parquet(path, **options)`

```ruby
df = Polars::DataFrame.new({"a" => [1, 2, 3], "b" => ["one", "two", "three"]})
df.write_parquet("data.parquet")

Polars.read_parquet("data.parquet")
# =>
# shape: (3, 2)
# ┌─────┬───────┐
# │ a   ┆ b     │
# │ --- ┆ ---   │
# │ i64 ┆ str   │
# ╞═════╪═══════╡
# │ 1   ┆ one   │
# │ 2   ┆ two   │
# │ 3   ┆ three │
# └─────┴───────┘
```

### JSON / NDJSON

*   `Polars.read_json(source, **options)` (for JSON array of objects)
*   `Polars.read_ndjson(source, **options)` (for newline-delimited JSON)
*   `Polars.scan_ndjson(source, **options)`
*   `df.write_json(file)`
*   `df.write_ndjson(file)`
*   `ldf.sink_ndjson(path)`

```ruby
# JSON (array of objects)
File.write("data.json", %{[{"a":1,"b":"one"},{"a":2,"b":"two"}]})
Polars.read_json("data.json")
# =>
# shape: (2, 2)
# ┌─────┬─────┐
# │ a   ┆ b   │
# │ --- ┆ --- │
# │ i64 ┆ str │
# ╞═════╪═════╡
# │ 1   ┆ one │
# │ 2   ┆ two │
# └─────┴─────┘

# NDJSON (newline-delimited)
File.write("data.ndjson", %[{"a":1,"b":"one"}\n{"a":2,"b":"two"}])
Polars.read_ndjson("data.ndjson")
# =>
# shape: (2, 2)
# ┌─────┬─────┐
# │ a   ┆ b   │
# │ --- ┆ --- │
# │ i64 ┆ str │
# ╞═════╪══════╡
# │ 1   ┆ one  │
# │ 2   ┆ two  │
# └─────┴──────┘
```

### Other Formats

*   **Arrow IPC / Feather**: `read_ipc`, `scan_ipc`, `write_ipc`, `sink_ipc`
*   **Avro**: `read_avro`, `write_avro`
*   **Delta Lake**: `read_delta`, `scan_delta`, `write_delta`
*   **Database (via ActiveRecord)**: `read_database`, `write_database`

```ruby
# Example with a database (ActiveRecord required)
# Assuming a 'users' table exists
Polars.read_database("SELECT * FROM users WHERE id > 10")
```

## The Expression API

Polars is built around a powerful expression API that allows for complex queries to be executed efficiently and in parallel. Expressions are the foundation of operations within `select`, `with_columns`, `filter`, and `group_by.agg`.

#### Core Functions

*   `Polars.col(name)`: Selects one or more columns to create an expression.
*   `Polars.lit(value)`: Creates an expression from a literal value.

```ruby
df = Polars::DataFrame.new({"a" => [1, 2, 3], "b" => [4, 5, 6]})

df.select(
  Polars.col("a"),                 # Select column "a"
  (Polars.col("a") * 2).alias("a_doubled"), # Create a new column
  (Polars.col("a") + Polars.col("b")).alias("a_plus_b")
)
# =>
# shape: (3, 3)
# ┌─────┬───────────┬──────────┐
# │ a   ┆ a_doubled ┆ a_plus_b │
# │ --- ┆ ---       ┆ ---      │
# │ i64 ┆ i64       ┆ i64      │
# ╞═════╪═══════════╪══════════╡
# │ 1   ┆ 2         ┆ 5        │
# │ 2   ┆ 4         ┆ 7        │
# │ 3   ┆ 6         ┆ 9        │
# └─────┴───────────┴──────────┘
```

#### Contexts

Expressions are evaluated within a specific context, most commonly `select`, `with_columns`, and `group_by.agg`.

*   **`select`**: Selects, renames, or creates new columns. The number of rows is preserved (unless using an aggregation without a `group_by`).
*   **`with_columns`**: Adds or replaces columns in the DataFrame.
*   **`filter`**: Filters rows based on a boolean expression.

```ruby
df = Polars::DataFrame.new(
  {
    "nrs" => [1, 2, 3, nil, 5],
    "groups" => ["A", "A", "B", "C", "B"]
  }
)

# with_columns: add a new column
df.with_columns(
  (Polars.col("nrs") * 2).alias("nrs_doubled")
)
# =>
# shape: (5, 3)
# ┌──────┬────────┬─────────────┐
# │ nrs  ┆ groups ┆ nrs_doubled │
# │ ---  ┆ ---    ┆ ---         │
# │ i64  ┆ str    ┆ i64         │
# ╞══════╪════════╪═════════════╡
# │ 1    ┆ A      ┆ 2           │
# │ 2    ┆ A      ┆ 4           │
# │ 3    ┆ B      ┆ 6           │
# │ null ┆ C      ┆ null        │
# │ 5    ┆ B      ┆ 10          │
# └──────┴────────┴─────────────┘

# filter: select rows
df.filter(Polars.col("nrs") > 2)
# =>
# shape: (2, 2)
# ┌─────┬────────┐
# │ nrs ┆ groups │
# │ --- ┆ ---    │
# │ i64 ┆ str    │
# ╞═════╪════════╡
# │ 3   ┆ B      │
# │ 5   ┆ B      │
# └─────┴────────┘
```

#### Chaining

Expressions can be chained together to form complex transformations.

```ruby
Polars.col("foo").sort.head(5) * Polars.col("bar").sum
```

## Namespaces

Expressions have special namespaces for operations specific to their data type.

### String Namespace (`.str`)

For `String` and `Categorical` data types.

*   `str.contains(pattern)`
*   `str.starts_with(prefix)` / `str.ends_with(suffix)`
*   `str.replace(pattern, value)`
*   `str.to_lowercase()` / `str.to_uppercase()`
*   `str.len_chars()` / `str.len_bytes()`
*   `str.split(by)`
*   `str.strptime(dtype, format)`

```ruby
df = Polars::DataFrame.new({"log": ["INFO:_foo", "WARN:_bar"]})

df.select(
  Polars.col("log").str.split(":_").struct[1].alias("message")
)
# =>
# shape: (2, 1)
# ┌─────────┐
# │ message │
# │ ---     │
# │ str     │
# ╞═════════╡
# │ foo     │
# │ bar     │
# └─────────┘
```

### Datetime Namespace (`.dt`)

For `Datetime`, `Date`, and `Time` data types.

*   `dt.year()`, `dt.month()`, `dt.day()`
*   `dt.hour()`, `dt.minute()`, `dt.second()`
*   `dt.weekday()`, `dt.ordinal_day()`
*   `dt.strftime(format)`
*   `dt.truncate(every)`
*   `dt.offset_by(duration_string)`

```ruby
df = Polars::DataFrame.new(
  {"datetime" => Polars.datetime_range(DateTime.new(2022,1,1), DateTime.new(2022,1,3), "1d", eager: true)}
)

df.with_columns(
  Polars.col("datetime").dt.strftime("%Y-%m-%d (%A)").alias("formatted")
)
# =>
# shape: (3, 2)
# ┌─────────────────────┬───────────────────────────┐
# │ datetime            ┆ formatted                 │
# │ ---                 ┆ ---                       │
# │ datetime[ns]        ┆ str                       │
# ╞═════════════════════╪═══════════════════════════╡
# │ 2022-01-01 00:00:00 ┆ 2022-01-01 (Saturday)     │
# │ 2022-01-02 00:00:00 ┆ 2022-01-02 (Sunday)       │
# │ 2022-01-03 00:00:00 ┆ 2022-01-03 (Monday)       │
# └─────────────────────┴───────────────────────────┘
```

### List & Array Namespaces (`.list`, `.arr`)

For `List` and `Array` data types. Array operations are similar but often preserve the fixed-size nature.

*   `list.len()`
*   `list.sum()`, `list.mean()`, `list.max()`, `list.min()`
*   `list.sort()`
*   `list.get(index)`
*   `list.join(separator)`
*   `list.explode()`
*   `list.eval(expression)`

```ruby
df = Polars::DataFrame.new({
  "grades" => [[10, 8, 9], [6, 7], [9, 8]]
})

df.select(
  Polars.col("grades").list.mean.alias("avg_grade")
)
# =>
# shape: (3, 1)
# ┌───────────┐
# │ avg_grade │
# │ ---       │
# │ f64       │
# ╞═══════════╡
# │ 9.0       │
# │ 6.5       │
# │ 8.5       │
# └───────────┘
```

### Other Namespaces

*   **`.struct`**: For `Struct` types (`field`, `rename_fields`, `unnest`).
*   **`.cat`**: For `Categorical` types (`get_categories`).
*   **`.bin`**: For `Binary` types (`contains`, `encode`, `decode`).
*   **`.meta`**: For expression metadata (`output_name`, `root_names`).
*   **`.name`**: For modifying expression output names (`prefix`, `suffix`).

## Lazy API (`LazyFrame`)

The Lazy API allows you to build a query plan (a `LazyFrame`) which Polars can optimize before execution. This is crucial for performance and for working with datasets larger than memory.

*   **`df.lazy`**: Convert a `DataFrame` to a `LazyFrame`.
*   **`Polars.scan_*`**: Start a lazy query directly from a file.
*   **`ldf.collect`**: Execute the query plan and return a `DataFrame`.
*   **`ldf.fetch(n)`**: Execute the query on the first `n` rows of the data, useful for debugging.
*   **`ldf.sink_*`**: Execute the query and write the result directly to a file without collecting it into memory.

```ruby
# An example of a lazy query
lf = Polars.scan_csv("iris.csv")
query = lf.filter(Polars.col("sepal_length") > 5)
           .group_by("species")
           .agg(Polars.all.sum)

# The query is only executed when .collect() is called
result = query.collect
```

## Grouping

Polars provides powerful grouping capabilities.

#### `group_by`

```ruby
df = Polars::DataFrame.new(
  {
    "category" => ["A", "A", "B", "B", "C"],
    "value" => [1, 2, 3, 4, 5]
  }
)

df.group_by("category", maintain_order: true).agg(
  Polars.col("value").sum.alias("sum_val"),
  Polars.col("value").mean.alias("mean_val")
)
# =>
# shape: (3, 3)
# ┌──────────┬─────────┬──────────┐
# │ category ┆ sum_val ┆ mean_val │
# │ ---      ┆ ---     ┆ ---      │
# │ str      ┆ i64     ┆ f64      │
# ╞══════════╪═════════╪══════════╡
# │ A        ┆ 3       ┆ 1.5      │
# │ B        ┆ 7       ┆ 3.5      │
# │ C        ┆ 5       ┆ 5.0      │
# └──────────┴──────────┴──────────┘
```

#### `group_by_dynamic` & `rolling`

For temporal or sequential data, you can group by dynamic windows.

```ruby
df = Polars::DataFrame.new({
  "ts" => Polars.datetime_range(DateTime.new(2020, 1, 1), DateTime.new(2020, 1, 5), "1d", eager: true),
  "value" => [10, 20, 15, 25, 30]
}).set_sorted("ts")

df.group_by_dynamic(
  "ts",
  every: "2d",
  period: "3d",
  include_boundaries: true
).agg(
  Polars.col("value").sum.alias("value_sum")
)
# =>
# shape: (3, 4)
# ┌─────────────────────┬─────────────────────┬─────────────────────┬───────────┐
# │ _lower_boundary     ┆ _upper_boundary     ┆ ts                  ┆ value_sum │
# │ ---                 ┆ ---                 ┆ ---                 ┆ ---       │
# │ datetime[ns]        ┆ datetime[ns]        ┆ datetime[ns]        ┆ i64       │
# ╞═════════════════════╪═════════════════════╪═════════════════════╪═══════════╡
# │ 2019-12-31 00:00:00 ┆ 2020-01-03 00:00:00 ┆ 2020-01-01 00:00:00 ┆ 45        │
# │ 2020-01-02 00:00:00 ┆ 2020-01-05 00:00:00 ┆ 2020-01-03 00:00:00 ┆ 70        │
# │ 2020-01-04 00:00:00 ┆ 2020-01-07 00:00:00 ┆ 2020-01-05 00:00:00 ┆ 30        │
# └─────────────────────┴─────────────────────┴─────────────────────┴───────────┘
```

## Joins & Concatenation

#### Joins

*   **`df.join(other_df, on:, how:)`**: Standard SQL-style joins.
*   **`df.join_asof(other_df, on:, by:, strategy:)`**: Joins on the nearest key.

```ruby
df_a = Polars::DataFrame.new({a: [1, 2, 3], b: ["one", "two", "three"]})
df_b = Polars::DataFrame.new({a: [1, 1, 2], c: ["c1", "c2", "c3"]})

df_a.join(df_b, on: "a", how: "inner")
# =>
# shape: (3, 3)
# ┌─────┬───────┬─────┐
# │ a   ┆ b     ┆ c   │
# │ --- ┆ ---   ┆ --- │
# │ i64 ┆ str   ┆ str │
# ╞═════╪═══════╪═════╡
# │ 1   ┆ one   ┆ c1  │
# │ 1   ┆ one   ┆ c2  │
# │ 2   ┆ two   ┆ c3  │
# └─────┴───────┴─────┘
```

#### Concatenation

*   **`Polars.concat(items, how:)`**: Concatenate a list of `DataFrames` or `Series`.

```ruby
df1 = Polars::DataFrame.new({a: [1], b: [3]})
df2 = Polars::DataFrame.new({a: [2], b: [4]})

# Vertical concatenation
Polars.concat([df1, df2], how: "vertical")
# =>
# shape: (2, 2)
# ┌─────┬─────┐
# │ a   ┆ b   │
# │ --- ┆ --- │
# │ i64 ┆ i64 │
# ╞═════╪═════╡
# │ 1   ┆ 3   │
# │ 2   ┆ 4   │
# └─────┴─────┘

# Horizontal concatenation
df3 = Polars::DataFrame.new({c: [5], d: [6]})
Polars.concat([df1, df3], how: "horizontal")
# =>
# shape: (1, 4)
# ┌─────┬─────┬─────┬─────┐
# │ a   ┆ b   ┆ c   ┆ d   │
# │ --- ┆ --- ┆ --- ┆ --- │
# │ i64 ┆ i64 ┆ i64 ┆ i64 │
# ╞═════╪═════╪═════╪═════╡
# │ 1   ┆ 3   ┆ 5   ┆ 6   │
# └─────┴─────┴─────┴─────┘
```

## Selectors (`cs`)

Selectors provide a concise way to select multiple columns based on their names, dtypes, or other properties. They are used within `select`, `with_columns`, etc.

*   `Polars.cs.all`
*   `Polars.cs.numeric`, `Polars.cs.string`, `Polars.cs.temporal`, etc.
*   `Polars.cs.by_name("a", "b")`
*   `Polars.cs.starts_with("prefix_")`, `Polars.cs.ends_with("_suffix")`
*   `Polars.cs.matches("regex")`

```ruby
df = Polars::DataFrame.new({
  "temp_c" => [10, 20],
  "temp_f" => [50, 68],
  "unit" => ["C", "F"]
})

# Select all numeric columns and multiply by 2
df.select(Polars.cs.numeric * 2)
# =>
# shape: (2, 2)
# ┌────────┬────────┐
# │ temp_c ┆ temp_f │
# │ ---    ┆ ---    │
# │ i64    ┆ i64    │
# ╞════════╪════════╡
# │ 20     ┆ 100    │
# │ 40     ┆ 136    │
# └────────┴────────┘
```

## SQL Interface

You can query `DataFrame` and `LazyFrame` objects using SQL.

*   `Polars::SQLContext.new(...)`
*   `ctx.register(name, frame)`
*   `ctx.execute(query)`

```ruby
lf = Polars::LazyFrame.new({"a" => [1, 2, 3], "b" => ["x", nil, "z"]})
ctx = Polars::SQLContext.new(frame: lf)

result_lf = ctx.execute(
  "SELECT b, a*2 AS two_a FROM frame WHERE b IS NOT NULL"
)

result_lf.collect
# =>
# shape: (2, 2)
# ┌─────┬───────┐
# │ b   ┆ two_a │
# │ --- ┆ ---   │
# │ str ┆ i64   │
# ╞═════╪═══════╡
# │ x   ┆ 2     │
# │ z   ┆ 6     │
# └─────┴───────┘
```

## Configuration

Customize Polars' behavior, especially for display formatting.

```ruby
# Temporarily set configuration options for a block of code
Polars.config(tbl_rows: 5, tbl_cols: 4) do
  # Code here will display DataFrames with at most 5 rows and 4 columns
  puts Polars::DataFrame.new(10.times.to_h { |i| [i.to_s, (1..10).to_a] })
end
```

## Data Types

Polars has a rich set of data types.

**Numeric:**
*   `Polars::Int8`, `Int16`, `Int32`, `Int64`
*   `Polars::UInt8`, `UInt16`, `UInt32`, `UInt64`
*   `Polars::Float32`, `Float64`
*   `Polars::Decimal`

**Other:**
*   `Polars::Boolean`
*   `Polars::String`
*   `Polars::Binary`
*   `Polars::Categorical`
*   `Polars::Enum`
*   `Polars::Object` (for arbitrary Ruby objects)

**Temporal:**
*   `Polars::Date`
*   `Polars::Time`
*   `Polars::Datetime`
*   `Polars::Duration`

**Nested:**
*   `Polars::List`
*   `Polars::Array`
*   `Polars::Struct`

You can specify dtypes during creation or cast later:

```ruby
# Specify on creation
df = Polars::DataFrame.new(
  {"a" => [1, 2]},
  schema: {"a" => Polars::Int16}
)

# Cast an existing column
df.select(Polars.col("a").cast(Polars::Float64))
```

```

In []:
```
# Polars for Ruby

This document provides a comprehensive overview of the Polars for Ruby library, focusing on concise explanations and practical code examples.

## Getting Started

First, install the `polars-df` gem.

```sh
gem install polars-df
```

Then, you can create your first DataFrame:

```ruby
require "polars-df"

df = Polars::DataFrame.new(
  {
    "A" => [1, 2, 3, 4, 5],
    "fruits" => ["banana", "banana", "apple", "apple", "banana"],
    "B" => [5, 4, 3, 2, 1],
    "cars" => ["beetle", "audi", "beetle", "beetle", "beetle"]
  }
)

puts df
```
```text
shape: (5, 4)
┌─────┬────────┬─────┬────────┐
│ A   ┆ fruits ┆ B   ┆ cars   │
│ --- ┆ ---    ┆ --- ┆ ---    │
│ i64 ┆ str    ┆ i64 ┆ str    │
╞═════╪════════╪═════╪════════╡
│ 1   ┆ banana ┆ 5   ┆ beetle │
│ 2   ┆ banana ┆ 4   ┆ audi   │
│ 3   ┆ apple  ┆ 3   ┆ beetle │
│ 4   ┆ apple  ┆ 2   ┆ beetle │
│ 5   ┆ banana ┆ 1   ┆ beetle │
└─────┴────────┴─────┴────────┘
```

## Data Structures

### DataFrame

A `DataFrame` is a 2D data structure that is composed of `Series`.

#### Initialization

```ruby
# From a hash of arrays/ranges
df = Polars::DataFrame.new(
  {"a" => 1..3, "b" => ["one", "two", "three"]}
)

# From an array of hashes
df = Polars::DataFrame.new([
  {"a" => 1, "b" => "one"},
  {"a" => 2, "b" => "two"},
  {"a" => 3, "b" => "three"}
])

# From an array of Series
df = Polars::DataFrame.new([
  Polars::Series.new("a", [1, 2, 3]),
  Polars::Series.new("b", ["one", "two", "three"])
])

# With schema definition
df = Polars::DataFrame.new(
  {"a" => [DateTime.new(2022, 1, 1)]},
  schema: {"a" => Polars::Datetime.new("ms")}
)
```

#### Attributes

*   `df.shape` -> `[rows, columns]`
*   `df.height` -> Number of rows
*   `df.width` -> Number of columns
*   `df.columns` -> `["col1", "col2", ...]`
*   `df.dtypes` -> `[Polars::DataType, ...]`
*   `df.schema` -> `{"col1" => Polars::DataType, ...}`

```ruby
df = Polars::DataFrame.new({"a" => [1, 2], "b" => ["one", "two"]})

df.shape
# => [2, 2]

df.columns
# => ["a", "b"]

df.dtypes
# => [Polars::Int64, Polars::String]
```

#### Column Selection

```ruby
df = Polars::DataFrame.new(
  {
    "a" => [1, 2, 3],
    "b" => [4, 5, 6],
    "c" => [7, 8, 9]
  }
)

# Select a single column, returns a Series
df["a"]
# =>
# shape: (3,)
# Series: 'a' [i64]
# [
#         1
#         2
#         3
# ]

# Select multiple columns, returns a DataFrame
df[["a", "c"]]
# =>
# shape: (3, 2)
# ┌─────┬─────┐
# │ a   ┆ c   │
# │ --- ┆ --- │
# │ i64 ┆ i64 │
# ╞═════╪═════╡
# │ 1   ┆ 7   │
# │ 2   ┆ 8   │
# │ 3   ┆ 9   │
# └─────┴─────┘
```

#### Row Selection

```ruby
df = Polars::DataFrame.new({"a" => 0..4, "b" => 5..9})

# Select a single row by index
df[2]
# =>
# shape: (1, 2)
# ┌─────┬─────┐
# │ a   ┆ b   │
# │ --- ┆ --- │
# │ i64 ┆ i64 │
# ╞═════╪═════╡
# │ 2   ┆ 7   │
# └─────┴─────┘

# Select rows with a slice
df[1..3]
# =>
# shape: (3, 2)
# ┌─────┬─────┐
# │ a   ┆ b   │
# │ --- ┆ --- │
# │ i64 ┆ i64 │
# ╞═════╪═════╡
# │ 1   ┆ 6   │
# │ 2   ┆ 7   │
# │ 3   ┆ 8   │
# └─────┴─────┘

# Select rows with a boolean Series
df[df["a"].is_even]
# =>
# shape: (3, 2)
# ┌─────┬─────┐
# │ a   ┆ b   │
# │ --- ┆ --- │
# │ i64 ┆ i64 │
# ╞═════╪═════╡
# │ 0   ┆ 5   │
# │ 2   ┆ 7   │
# │ 4   ┆ 9   │
# └─────┴─────┘
```

#### Element Selection

```ruby
df = Polars::DataFrame.new({"a" => [1, 2, 3], "b" => [4, 5, 6]})

# Get element by row and column index
df[1, 1]
# => 5

# Get element by row index and column name
df[2, "a"]
# => 3
```

#### Methods

For a full list of methods, see the sections below. Key methods include:
*   `select`
*   `with_columns`
*   `filter`
*   `group_by`
*   `join`

### Series

A `Series` is a 1D data structure that is the building block of a `DataFrame`.

#### Initialization

```ruby
# From an array
s = Polars::Series.new("a", [1, 2, 3])

# With a specific dtype
s = Polars::Series.new("b", [1.0, 2.0], dtype: Polars::Float32)

# From a Range
s = Polars::Series.new("c", 1..3)
```

#### Attributes
*   `s.name` -> Name of the series
*   `s.dtype` -> `Polars::DataType` of the series
*   `s.len` -> Length of the series
*   `s.shape` -> `[length]`

#### Indexing

```ruby
s = Polars::Series.new("a", [10, 20, 30, 40])

s[1]
# => 20

s[-1]
# => 40

s[1..2]
# =>
# shape: (2,)
# Series: 'a' [i64]
# [
#         20
#         30
# ]
```

#### Methods

Many `Series` methods are also available as `Expr` methods, allowing them to be used inside `select`, `group_by`, etc. They can also be called directly on a `Series` object for eager execution.

*   **Arithmetic**: `+`, `-`, `*`, `/`, `%`
*   **Comparison**: `==`, `!=`, `>`, `<`, `>=`, `<=`
*   **Aggregation**: `sum`, `mean`, `min`, `max`, `std`, `var`, `median`, `quantile`
*   **Transformation**: `sort`, `filter`, `map_elements`, `round`, `clip`, `cast`

## I/O (Reading & Writing Data)

### CSV

*   `Polars.read_csv(source, **options)`
*   `Polars.scan_csv(source, **options)`
*   `df.write_csv(file, **options)`
*   `ldf.sink_csv(path, **options)`

```ruby
# Write a DataFrame to a CSV file
df = Polars::DataFrame.new({"a" => [1, 2, 3], "b" => ["one", "two", "three"]})
df.write_csv("data.csv")
File.read("data.csv")
# => "a,b\n1,one\n2,two\n3,three\n"

# Read from a CSV file
Polars.read_csv("data.csv")
# =>
# shape: (3, 2)
# ┌─────┬───────┐
# │ a   ┆ b     │
# │ --- ┆ ---   │
# │ i64 ┆ str   │
# ╞═════╪═══════╡
# │ 1   ┆ one   │
# │ 2   ┆ two   │
# │ 3   ┆ three │
# └─────┴───────┘

# Lazily scan a CSV for memory-efficient queries
Polars.scan_csv("data.csv").filter(Polars.col("a") > 2).collect
# =>
# shape: (1, 2)
# ┌─────┬───────┐
# │ a   ┆ b     │
# │ --- ┆ ---   │
# │ i64 ┆ str   │
# ╞═════╪═══════╡
# │ 3   ┆ three │
# └─────┴───────┘
```

### Parquet

*   `Polars.read_parquet(source, **options)`
*   `Polars.scan_parquet(source, **options)`
*   `df.write_parquet(file, **options)`
*   `ldf.sink_parquet(path, **options)`

```ruby
df = Polars::DataFrame.new({"a" => [1, 2, 3], "b" => ["one", "two", "three"]})
df.write_parquet("data.parquet")

Polars.read_parquet("data.parquet")
# =>
# shape: (3, 2)
# ┌─────┬───────┐
# │ a   ┆ b     │
# │ --- ┆ ---   │
# │ i64 ┆ str   │
# ╞═════╪═══════╡
# │ 1   ┆ one   │
# │ 2   ┆ two   │
# │ 3   ┆ three │
# └─────┴───────┘
```

### JSON / NDJSON

*   `Polars.read_json(source, **options)` (for JSON array of objects)
*   `Polars.read_ndjson(source, **options)` (for newline-delimited JSON)
*   `Polars.scan_ndjson(source, **options)`
*   `df.write_json(file)`
*   `df.write_ndjson(file)`
*   `ldf.sink_ndjson(path)`

```ruby
# JSON (array of objects)
File.write("data.json", %{[{"a":1,"b":"one"},{"a":2,"b":"two"}]})
Polars.read_json("data.json")
# =>
# shape: (2, 2)
# ┌─────┬─────┐
# │ a   ┆ b   │
# │ --- ┆ --- │
# │ i64 ┆ str │
# ╞═════╪═════╡
# │ 1   ┆ one │
# │ 2   ┆ two │
# └─────┴─────┘

# NDJSON (newline-delimited)
File.write("data.ndjson", %({"a":1,"b":"one"}\n{"a":2,"b":"two"}))
Polars.read_ndjson("data.ndjson")
# =>
# shape: (2, 2)
# ┌─────┬─────┐
# │ a   ┆ b   │
# │ --- ┆ --- │
# │ i64 ┆ str │
# ╞═════╪══════╡
# │ 1   ┆ one  │
# │ 2   ┆ two  │
# └─────┴──────┘
```

### Other Formats

*   **Arrow IPC / Feather**: `read_ipc`, `scan_ipc`, `write_ipc`, `sink_ipc`
*   **Avro**: `read_avro`, `write_avro`
*   **Delta Lake**: `read_delta`, `scan_delta`, `write_delta`
*   **Database (via ActiveRecord)**: `read_database`, `write_database`

```ruby
# Example with a database (ActiveRecord required)
# Assuming a 'users' table exists
Polars.read_database("SELECT * FROM users WHERE id > 10")
```

## The Expression API

Polars is built around a powerful expression API that allows for complex queries to be executed efficiently and in parallel. Expressions are the foundation of operations within `select`, `with_columns`, `filter`, and `group_by.agg`.

#### Core Functions

*   `Polars.col(name)`: Selects one or more columns to create an expression.
*   `Polars.lit(value)`: Creates an expression from a literal value.

```ruby
df = Polars::DataFrame.new({"a" => [1, 2, 3], "b" => [4, 5, 6]})

df.select(
  Polars.col("a"),                 # Select column "a"
  (Polars.col("a") * 2).alias("a_doubled"), # Create a new column
  (Polars.col("a") + Polars.col("b")).alias("a_plus_b")
)
# =>
# shape: (3, 3)
# ┌─────┬───────────┬──────────┐
# │ a   ┆ a_doubled ┆ a_plus_b │
# │ --- ┆ ---       ┆ ---      │
# │ i64 ┆ i64       ┆ i64      │
# ╞═════╪═══════════╪══════════╡
# │ 1   ┆ 2         ┆ 5        │
# │ 2   ┆ 4         ┆ 7        │
# │ 3   ┆ 6         ┆ 9        │
# └─────┴───────────┴──────────┘
```

#### Contexts

Expressions are evaluated within a specific context, most commonly `select`, `with_columns`, and `group_by.agg`.

*   **`select`**: Selects, renames, or creates new columns. The number of rows is preserved (unless using an aggregation without a `group_by`).
*   **`with_columns`**: Adds or replaces columns in the DataFrame.
*   **`filter`**: Filters rows based on a boolean expression.

```ruby
df = Polars::DataFrame.new(
  {
    "nrs" => [1, 2, 3, nil, 5],
    "groups" => ["A", "A", "B", "C", "B"]
  }
)

# with_columns: add a new column
df.with_columns(
  (Polars.col("nrs") * 2).alias("nrs_doubled")
)
# =>
# shape: (5, 3)
# ┌──────┬────────┬─────────────┐
# │ nrs  ┆ groups ┆ nrs_doubled │
# │ ---  ┆ ---    ┆ ---         │
# │ i64  ┆ str    ┆ i64         │
# ╞══════╪════════╪═════════════╡
# │ 1    ┆ A      ┆ 2           │
# │ 2    ┆ A      ┆ 4           │
# │ 3    ┆ B      ┆ 6           │
# │ null ┆ C      ┆ null        │
# │ 5    ┆ B      ┆ 10          │
# └──────┴────────┴─────────────┘

# filter: select rows
df.filter(Polars.col("nrs") > 2)
# =>
# shape: (2, 2)
# ┌─────┬────────┐
# │ nrs ┆ groups │
# │ --- ┆ ---    │
# │ i64 ┆ str    │
# ╞═════╪════════╡
# │ 3   ┆ B      │
# │ 5   ┆ B      │
# └─────┴────────┘
```

#### Chaining

Expressions can be chained together to form complex transformations.

```ruby
Polars.col("foo").sort.head(5) * Polars.col("bar").sum
```

## Namespaces

Expressions have special namespaces for operations specific to their data type.

### String Namespace (`.str`)

For `String` and `Categorical` data types.

*   `str.contains(pattern)`
*   `str.starts_with(prefix)` / `str.ends_with(suffix)`
*   `str.replace(pattern, value)`
*   `str.to_lowercase()` / `str.to_uppercase()`
*   `str.len_chars()` / `str.len_bytes()`
*   `str.split(by)`
*   `str.strptime(dtype, format)`

```ruby
df = Polars::DataFrame.new({"log": ["INFO:_foo", "WARN:_bar"]})

df.select(
  Polars.col("log").str.split(":_").struct[1].alias("message")
)
# =>
# shape: (2, 1)
# ┌─────────┐
# │ message │
# │ ---     │
# │ str     │
# ╞═════════╡
# │ foo     │
# │ bar     │
# └─────────┘
```

### Datetime Namespace (`.dt`)

For `Datetime`, `Date`, and `Time` data types.

*   `dt.year()`, `dt.month()`, `dt.day()`
*   `dt.hour()`, `dt.minute()`, `dt.second()`
*   `dt.weekday()`, `dt.ordinal_day()`
*   `dt.strftime(format)`
*   `dt.truncate(every)`
*   `dt.offset_by(duration_string)`

```ruby
df = Polars::DataFrame.new(
  {"datetime" => Polars.datetime_range(DateTime.new(2022,1,1), DateTime.new(2022,1,3), "1d", eager: true)}
)

df.with_columns(
  Polars.col("datetime").dt.strftime("%Y-%m-%d (%A)").alias("formatted")
)
# =>
# shape: (3, 2)
# ┌─────────────────────┬───────────────────────────┐
# │ datetime            ┆ formatted                 │
# │ ---                 ┆ ---                       │
# │ datetime[ns]        ┆ str                       │
# ╞═════════════════════╪═══════════════════════════╡
# │ 2022-01-01 00:00:00 ┆ 2022-01-01 (Saturday)     │
# │ 2022-01-02 00:00:00 ┆ 2022-01-02 (Sunday)       │
# │ 2022-01-03 00:00:00 ┆ 2022-01-03 (Monday)       │
# └─────────────────────┴───────────────────────────┘
```

### List & Array Namespaces (`.list`, `.arr`)

For `List` and `Array` data types. Array operations are similar but often preserve the fixed-size nature.

*   `list.len()`
*   `list.sum()`, `list.mean()`, `list.max()`, `list.min()`
*   `list.sort()`
*   `list.get(index)`
*   `list.join(separator)`
*   `list.explode()`
*   `list.eval(expression)`

```ruby
df = Polars::DataFrame.new({
  "grades" => [[10, 8, 9], [6, 7], [9, 8]]
})

df.select(
  Polars.col("grades").list.mean.alias("avg_grade")
)
# =>
# shape: (3, 1)
# ┌───────────┐
# │ avg_grade │
# │ ---       │
# │ f64       │
# ╞═══════════╡
# │ 9.0       │
# │ 6.5       │
# │ 8.5       │
# └───────────┘
```

### Other Namespaces

*   **`.struct`**: For `Struct` types (`field`, `rename_fields`, `unnest`).
*   **`.cat`**: For `Categorical` types (`get_categories`).
*   **`.bin`**: For `Binary` types (`contains`, `encode`, `decode`).
*   **`.meta`**: For expression metadata (`output_name`, `root_names`).
*   **`.name`**: For modifying expression output names (`prefix`, `suffix`).

## Lazy API (`LazyFrame`)

The Lazy API allows you to build a query plan (a `LazyFrame`) which Polars can optimize before execution. This is crucial for performance and for working with datasets larger than memory.

*   **`df.lazy`**: Convert a `DataFrame` to a `LazyFrame`.
*   **`Polars.scan_*`**: Start a lazy query directly from a file.
*   **`ldf.collect`**: Execute the query plan and return a `DataFrame`.
*   **`ldf.fetch(n)`**: Execute the query on the first `n` rows of the data, useful for debugging.
*   **`ldf.sink_*`**: Execute the query and write the result directly to a file without collecting it into memory.

```ruby
# An example of a lazy query
lf = Polars.scan_csv("iris.csv")
query = lf.filter(Polars.col("sepal_length") > 5)
           .group_by("species")
           .agg(Polars.all.sum)

# The query is only executed when .collect() is called
result = query.collect
```

## Grouping

Polars provides powerful grouping capabilities.

#### `group_by`

```ruby
df = Polars::DataFrame.new(
  {
    "category" => ["A", "A", "B", "B", "C"],
    "value" => [1, 2, 3, 4, 5]
  }
)

df.group_by("category", maintain_order: true).agg(
  Polars.col("value").sum.alias("sum_val"),
  Polars.col("value").mean.alias("mean_val")
)
# =>
# shape: (3, 3)
# ┌──────────┬─────────┬──────────┐
# │ category ┆ sum_val ┆ mean_val │
# │ ---      ┆ ---     ┆ ---      │
# │ str      ┆ i64     ┆ f64      │
# ╞══════════╪═════════╪══════════╡
# │ A        ┆ 3       ┆ 1.5      │
# │ B        ┆ 7       ┆ 3.5      │
# │ C        ┆ 5       ┆ 5.0      │
# └──────────┴─────────┴──────────┘
```

#### `group_by_dynamic` & `rolling`

For temporal or sequential data, you can group by dynamic windows.

```ruby
df = Polars::DataFrame.new({
  "ts" => Polars.datetime_range(DateTime.new(2020, 1, 1), DateTime.new(2020, 1, 5), "1d", eager: true),
  "value" => [10, 20, 15, 25, 30]
}).set_sorted("ts")

df.group_by_dynamic(
  "ts",
  every: "2d",
  period: "3d",
  include_boundaries: true
).agg(
  Polars.col("value").sum.alias("value_sum")
)
# =>
# shape: (3, 4)
# ┌─────────────────────┬─────────────────────┬─────────────────────┬───────────┐
# │ _lower_boundary     ┆ _upper_boundary     ┆ ts                  ┆ value_sum │
# │ ---                 ┆ ---                 ┆ ---                 ┆ ---       │
# │ datetime[ns]        ┆ datetime[ns]        ┆ datetime[ns]        ┆ i64       │
# ╞═════════════════════╪═════════════════════╪═════════════════════╪═══════════╡
# │ 2019-12-31 00:00:00 ┆ 2020-01-03 00:00:00 ┆ 2020-01-01 00:00:00 ┆ 45        │
# │ 2020-01-02 00:00:00 ┆ 2020-01-05 00:00:00 ┆ 2020-01-03 00:00:00 ┆ 70        │
# │ 2020-01-04 00:00:00 ┆ 2020-01-07 00:00:00 ┆ 2020-01-05 00:00:00 ┆ 30        │
# └─────────────────────┴─────────────────────┴─────────────────────┴───────────┘
```

## Joins & Concatenation

#### Joins

*   **`df.join(other_df, on:, how:)`**: Standard SQL-style joins.
*   **`df.join_asof(other_df, on:, by:, strategy:)`**: Joins on the nearest key.

```ruby
df_a = Polars::DataFrame.new({a: [1, 2, 3], b: ["one", "two", "three"]})
df_b = Polars::DataFrame.new({a: [1, 1, 2], c: ["c1", "c2", "c3"]})

df_a.join(df_b, on: "a", how: "inner")
# =>
# shape: (3, 3)
# ┌─────┬───────┬─────┐
# │ a   ┆ b     ┆ c   │
# │ --- ┆ ---   ┆ --- │
# │ i64 ┆ str   ┆ str │
# ╞═════╪═══════╪═════╡
# │ 1   ┆ one   ┆ c1  │
# │ 1   ┆ one   ┆ c2  │
# │ 2   ┆ two   ┆ c3  │
# └─────┴───────┴─────┘
```

#### Concatenation

*   **`Polars.concat(items, how:)`**: Concatenate a list of `DataFrames` or `Series`.

```ruby
df1 = Polars::DataFrame.new({a: [1], b: [3]})
df2 = Polars::DataFrame.new({a: [2], b: [4]})

# Vertical concatenation
Polars.concat([df1, df2], how: "vertical")
# =>
# shape: (2, 2)
# ┌─────┬─────┐
# │ a   ┆ b   │
# │ --- ┆ --- │
# │ i64 ┆ i64 │
# ╞═════╪═════╡
# │ 1   ┆ 3   │
# │ 2   ┆ 4   │
# └─────┴─────┘

# Horizontal concatenation
df3 = Polars::DataFrame.new({c: [5], d: [6]})
Polars.concat([df1, df3], how: "horizontal")
# =>
# shape: (1, 4)
# ┌─────┬─────┬─────┬─────┐
# │ a   ┆ b   ┆ c   ┆ d   │
# │ --- ┆ --- ┆ --- ┆ --- │
# │ i64 ┆ i64 ┆ i64 ┆ i64 │
# ╞═════╪═════╪═════╪═════╡
# │ 1   ┆ 3   ┆ 5   ┆ 6   │
# └─────┴─────┴─────┴─────┘
```

## Selectors (`cs`)

Selectors provide a concise way to select multiple columns based on their names, dtypes, or other properties. They are used within `select`, `with_columns`, etc.

*   `Polars.cs.all`
*   `Polars.cs.numeric`, `Polars.cs.string`, `Polars.cs.temporal`, etc.
*   `Polars.cs.by_name("a", "b")`
*   `Polars.cs.starts_with("prefix_")`, `Polars.cs.ends_with("_suffix")`
*   `Polars.cs.matches("regex")`

```ruby
df = Polars::DataFrame.new({
  "temp_c" => [10, 20],
  "temp_f" => [50, 68],
  "unit" => ["C", "F"]
})

# Select all numeric columns and multiply by 2
df.select(Polars.cs.numeric * 2)
# =>
# shape: (2, 2)
# ┌────────┬────────┐
# │ temp_c ┆ temp_f │
# │ ---    ┆ ---    │
# │ i64    ┆ i64    │
# ╞════════╪════════╡
# │ 20     ┆ 100    │
# │ 40     ┆ 136    │
# └────────┴────────┘
```

## SQL Interface

You can query `DataFrame` and `LazyFrame` objects using SQL.

*   `Polars::SQLContext.new(...)`
*   `ctx.register(name, frame)`
*   `ctx.execute(query)`

```ruby
lf = Polars::LazyFrame.new({"a" => [1, 2, 3], "b" => ["x", nil, "z"]})
ctx = Polars::SQLContext.new(frame: lf)

result_lf = ctx.execute(
  "SELECT b, a*2 AS two_a FROM frame WHERE b IS NOT NULL"
)

result_lf.collect
# =>
# shape: (2, 2)
# ┌─────┬───────┐
# │ b   ┆ two_a │
# │ --- ┆ ---   │
# │ str ┆ i64   │
# ╞═════╪═══════╡
# │ x   ┆ 2     │
# │ z   ┆ 6     │
# └─────┴───────┘
```

## Configuration

Customize Polars' behavior, especially for display formatting.

```ruby
# Temporarily set configuration options for a block of code
Polars.config(tbl_rows: 5, tbl_cols: 4) do
  # Code here will display DataFrames with at most 5 rows and 4 columns
  puts Polars::DataFrame.new(10.times.to_h { |i| [i.to_s, (1..10).to_a] })
end
```

## Data Types

Polars has a rich set of data types.

**Numeric:**
*   `Polars::Int8`, `Int16`, `Int32`, `Int64`
*   `Polars::UInt8`, `UInt16`, `UInt32`, `UInt64`
*   `Polars::Float32`, `Float64`
*   `Polars::Decimal`

**Other:**
*   `Polars::Boolean`
*   `Polars::String`
*   `Polars::Binary`
*   `Polars::Categorical`
*   `Polars::Enum`
*   `Polars::Object` (for arbitrary Ruby objects)

**Temporal:**
*   `Polars::Date`
*   `Polars::Time`
*   `Polars::Datetime`
*   `Polars::Duration`

**Nested:**
*   `Polars::List`
*   `Polars::Array`
*   `Polars::Struct`

You can specify dtypes during creation or cast later:

```ruby
# Specify on creation
df = Polars::DataFrame.new(
  {"a" => [1, 2]},
  schema: {"a" => Polars::Int16}
)

# Cast an existing column
df.select(Polars.col("a").cast(Polars::Float64))
```

```

In []:
```
# Polars for Ruby

This document provides a comprehensive overview of the Polars for Ruby library, focusing on concise explanations and practical code examples.

## Getting Started

First, install the `polars-df` gem.

```sh
gem install polars-df
```

Then, you can create your first DataFrame:

```ruby
require "polars-df"

df = Polars::DataFrame.new(
  {
    "A" => [1, 2, 3, 4, 5],
    "fruits" => ["banana", "banana", "apple", "apple", "banana"],
    "B" => [5, 4, 3, 2, 1],
    "cars" => ["beetle", "audi", "beetle", "beetle", "beetle"]
  }
)

puts df
```
```text
shape: (5, 4)
┌─────┬────────┬─────┬────────┐
│ A   ┆ fruits ┆ B   ┆ cars   │
│ --- ┆ ---    ┆ --- ┆ ---    │
│ i64 ┆ str    ┆ i64 ┆ str    │
╞═════╪════════╪═════╪════════╡
│ 1   ┆ banana ┆ 5   ┆ beetle │
│ 2   ┆ banana ┆ 4   ┆ audi   │
│ 3   ┆ apple  ┆ 3   ┆ beetle │
│ 4   ┆ apple  ┆ 2   ┆ beetle │
│ 5   ┆ banana ┆ 1   ┆ beetle │
└─────┴────────┴─────┴────────┘
```

## Data Structures

### DataFrame

A `DataFrame` is a 2D data structure that is composed of `Series`.

#### Initialization

```ruby
# From a hash of arrays/ranges
df = Polars::DataFrame.new(
  {"a" => 1..3, "b" => ["one", "two", "three"]}
)

# From an array of hashes
df = Polars::DataFrame.new([
  {"a" => 1, "b" => "one"},
  {"a" => 2, "b" => "two"},
  {"a" => 3, "b" => "three"}
])

# From an array of Series
df = Polars::DataFrame.new([
  Polars::Series.new("a", [1, 2, 3]),
  Polars::Series.new("b", ["one", "two", "three"])
])

# With schema definition
df = Polars::DataFrame.new(
  {"a" => [DateTime.new(2022, 1, 1)]},
  schema: {"a" => Polars::Datetime.new("ms")}
)
```

#### Attributes

*   `df.shape` -> `[rows, columns]`
*   `df.height` -> Number of rows
*   `df.width` -> Number of columns
*   `df.columns` -> `["col1", "col2", ...]`
*   `df.dtypes` -> `[Polars::DataType, ...]`
*   `df.schema` -> `{"col1" => Polars::DataType, ...}`

```ruby
df = Polars::DataFrame.new({"a" => [1, 2], "b" => ["one", "two"]})

df.shape
# => [2, 2]

df.columns
# => ["a", "b"]

df.dtypes
# => [Polars::Int64, Polars::String]
```

#### Column Selection

```ruby
df = Polars::DataFrame.new(
  {
    "a" => [1, 2, 3],
    "b" => [4, 5, 6],
    "c" => [7, 8, 9]
  }
)

# Select a single column, returns a Series
df["a"]
# =>
# shape: (3,)
# Series: 'a' [i64]
# [
#         1
#         2
#         3
# ]

# Select multiple columns, returns a DataFrame
df[["a", "c"]]
# =>
# shape: (3, 2)
# ┌─────┬─────┐
# │ a   ┆ c   │
# │ --- ┆ --- │
# │ i64 ┆ i64 │
# ╞═════╪═════╡
# │ 1   ┆ 7   │
# │ 2   ┆ 8   │
# │ 3   ┆ 9   │
# └─────┴─────┘
```

#### Row Selection

```ruby
df = Polars::DataFrame.new({"a" => 0..4, "b" => 5..9})

# Select a single row by index
df[2]
# =>
# shape: (1, 2)
# ┌─────┬─────┐
# │ a   ┆ b   │
# │ --- ┆ --- │
# │ i64 ┆ i64 │
# ╞═════╪═════╡
# │ 2   ┆ 7   │
# └─────┴─────┘

# Select rows with a slice
df[1..3]
# =>
# shape: (3, 2)
# ┌─────┬─────┐
# │ a   ┆ b   │
# │ --- ┆ --- │
# │ i64 ┆ i64 │
# ╞═════╪═════╡
# │ 1   ┆ 6   │
# │ 2   ┆ 7   │
# │ 3   ┆ 8   │
# └─────┴─────┘

# Select rows with a boolean Series
df[df["a"].is_even]
# =>
# shape: (3, 2)
# ┌─────┬─────┐
# │ a   ┆ b   │
# │ --- ┆ --- │
# │ i64 ┆ i64 │
# ╞═════╪═════╡
# │ 0   ┆ 5   │
# │ 2   ┆ 7   │
# │ 4   ┆ 9   │
# └─────┴─────┘
```

#### Element Selection

```ruby
df = Polars::DataFrame.new({"a" => [1, 2, 3], "b" => [4, 5, 6]})

# Get element by row and column index
df[1, 1]
# => 5

# Get element by row index and column name
df[2, "a"]
# => 3
```

#### Methods

For a full list of methods, see the sections below. Key methods include:
*   `select`
*   `with_columns`
*   `filter`
*   `group_by`
*   `join`

### Series

A `Series` is a 1D data structure that is the building block of a `DataFrame`.

#### Initialization

```ruby
# From an array
s = Polars::Series.new("a", [1, 2, 3])

# With a specific dtype
s = Polars::Series.new("b", [1.0, 2.0], dtype: Polars::Float32)

# From a Range
s = Polars::Series.new("c", 1..3)
```

#### Attributes
*   `s.name` -> Name of the series
*   `s.dtype` -> `Polars::DataType` of the series
*   `s.len` -> Length of the series
*   `s.shape` -> `[length]`

#### Indexing

```ruby
s = Polars::Series.new("a", [10, 20, 30, 40])

s[1]
# => 20

s[-1]
# => 40

s[1..2]
# =>
# shape: (2,)
# Series: 'a' [i64]
# [
#         20
#         30
# ]
```

#### Methods

Many `Series` methods are also available as `Expr` methods, allowing them to be used inside `select`, `group_by`, etc. They can also be called directly on a `Series` object for eager execution.

*   **Arithmetic**: `+`, `-`, `*`, `/`, `%`
*   **Comparison**: `==`, `!=`, `>`, `<`, `>=`, `<=`
*   **Aggregation**: `sum`, `mean`, `min`, `max`, `std`, `var`, `median`, `quantile`
*   **Transformation**: `sort`, `filter`, `map_elements`, `round`, `clip`, `cast`

## I/O (Reading & Writing Data)

### CSV

*   `Polars.read_csv(source, **options)`
*   `Polars.scan_csv(source, **options)`
*   `df.write_csv(file, **options)`
*   `ldf.sink_csv(path, **options)`

```ruby
# Write a DataFrame to a CSV file
df = Polars::DataFrame.new({"a" => [1, 2, 3], "b" => ["one", "two", "three"]})
df.write_csv("data.csv")
File.read("data.csv")
# => "a,b\n1,one\n2,two\n3,three\n"

# Read from a CSV file
Polars.read_csv("data.csv")
# =>
# shape: (3, 2)
# ┌─────┬───────┐
# │ a   ┆ b     │
# │ --- ┆ ---   │
# │ i64 ┆ str   │
# ╞═════╪═══════╡
# │ 1   ┆ one   │
# │ 2   ┆ two   │
# │ 3   ┆ three │
# └─────┴───────┘

# Lazily scan a CSV for memory-efficient queries
Polars.scan_csv("data.csv").filter(Polars.col("a") > 2).collect
# =>
# shape: (1, 2)
# ┌─────┬───────┐
# │ a   ┆ b     │
# │ --- ┆ ---   │
# │ i64 ┆ str   │
# ╞═════╪═══════╡
# │ 3   ┆ three │
# └─────┴───────┘
```

### Parquet

*   `Polars.read_parquet(source, **options)`
*   `Polars.scan_parquet(source, **options)`
*   `df.write_parquet(file, **options)`
*   `ldf.sink_parquet(path, **options)`

```ruby
df = Polars::DataFrame.new({"a" => [1, 2, 3], "b" => ["one", "two", "three"]})
df.write_parquet("data.parquet")

Polars.read_parquet("data.parquet")
# =>
# shape: (3, 2)
# ┌─────┬───────┐
# │ a   ┆ b     │
# │ --- ┆ ---   │
# │ i64 ┆ str   │
# ╞═════╪═══════╡
# │ 1   ┆ one   │
# │ 2   ┆ two   │
# │ 3   ┆ three │
# └─────┴───────┘
```

### JSON / NDJSON

*   `Polars.read_json(source, **options)` (for JSON array of objects)
*   `Polars.read_ndjson(source, **options)` (for newline-delimited JSON)
*   `Polars.scan_ndjson(source, **options)`
*   `df.write_json(file)`
*   `df.write_ndjson(file)`
*   `ldf.sink_ndjson(path)`

```ruby
# JSON (array of objects)
File.write("data.json", %{[{"a":1,"b":"one"},{"a":2,"b":"two"}]})
Polars.read_json("data.json")
# =>
# shape: (2, 2)
# ┌─────┬─────┐
# │ a   ┆ b   │
# │ --- ┆ --- │
# │ i64 ┆ str │
# ╞═════╪═════╡
# │ 1   ┆ one │
# │ 2   ┆ two │
# └─────┴─────┘

# NDJSON (newline-delimited)
File.write("data.ndjson", %({"a":1,"b":"one"}\n{"a":2,"b":"two"}))
Polars.read_ndjson("data.ndjson")
# =>
# shape: (2, 2)
# ┌─────┬─────┐
# │ a   ┆ b   │
# │ --- ┆ --- │
# │ i64 ┆ str │
# ╞═════╪══════╡
# │ 1   ┆ one  │
# │ 2   ┆ two  │
# └─────┴──────┘
```

### Other Formats

*   **Arrow IPC / Feather**: `read_ipc`, `scan_ipc`, `write_ipc`, `sink_ipc`
*   **Avro**: `read_avro`, `write_avro`
*   **Delta Lake**: `read_delta`, `scan_delta`, `write_delta`
*   **Database (via ActiveRecord)**: `read_database`, `write_database`

```ruby
# Example with a database (ActiveRecord required)
# Assuming a 'users' table exists
Polars.read_database("SELECT * FROM users WHERE id > 10")
```

## The Expression API

Polars is built around a powerful expression API that allows for complex queries to be executed efficiently and in parallel. Expressions are the foundation of operations within `select`, `with_columns`, `filter`, and `group_by.agg`.

#### Core Functions

*   `Polars.col(name)`: Selects one or more columns to create an expression.
*   `Polars.lit(value)`: Creates an expression from a literal value.

```ruby
df = Polars::DataFrame.new({"a" => [1, 2, 3], "b" => [4, 5, 6]})

df.select(
  Polars.col("a"),                 # Select column "a"
  (Polars.col("a") * 2).alias("a_doubled"), # Create a new column
  (Polars.col("a") + Polars.col("b")).alias("a_plus_b")
)
# =>
# shape: (3, 3)
# ┌─────┬───────────┬──────────┐
# │ a   ┆ a_doubled ┆ a_plus_b │
# │ --- ┆ ---       ┆ ---      │
# │ i64 ┆ i64       ┆ i64      │
# ╞═════╪═══════════╪══════════╡
# │ 1   ┆ 2         ┆ 5        │
# │ 2   ┆ 4         ┆ 7        │
# │ 3   ┆ 6         ┆ 9        │
# └─────┴───────────┴──────────┘
```

#### Contexts

Expressions are evaluated within a specific context, most commonly `select`, `with_columns`, and `group_by.agg`.

*   **`select`**: Selects, renames, or creates new columns. The number of rows is preserved (unless using an aggregation without a `group_by`).
*   **`with_columns`**: Adds or replaces columns in the DataFrame.
*   **`filter`**: Filters rows based on a boolean expression.

```ruby
df = Polars::DataFrame.new(
  {
    "nrs" => [1, 2, 3, nil, 5],
    "groups" => ["A", "A", "B", "C", "B"]
  }
)

# with_columns: add a new column
df.with_columns(
  (Polars.col("nrs") * 2).alias("nrs_doubled")
)
# =>
# shape: (5, 3)
# ┌──────┬────────┬─────────────┐
# │ nrs  ┆ groups ┆ nrs_doubled │
# │ ---  ┆ ---    ┆ ---         │
# │ i64  ┆ str    ┆ i64         │
# ╞══════╪════════╪═════════════╡
# │ 1    ┆ A      ┆ 2           │
# │ 2    ┆ A      ┆ 4           │
# │ 3    ┆ B      ┆ 6           │
# │ null ┆ C      ┆ null        │
# │ 5    ┆ B      ┆ 10          │
# └──────┴────────┴─────────────┘

# filter: select rows
df.filter(Polars.col("nrs") > 2)
# =>
# shape: (2, 2)
# ┌─────┬────────┐
# │ nrs ┆ groups │
# │ --- ┆ ---    │
# │ i64 ┆ str    │
# ╞═════╪════════╡
# │ 3   ┆ B      │
# │ 5   ┆ B      │
# └─────┴────────┘
```

#### Chaining

Expressions can be chained together to form complex transformations.

```ruby
Polars.col("foo").sort.head(5) * Polars.col("bar").sum
```

## Namespaces

Expressions have special namespaces for operations specific to their data type.

### String Namespace (`.str`)

For `String` and `Categorical` data types.

*   `str.contains(pattern)`
*   `str.starts_with(prefix)` / `str.ends_with(suffix)`
*   `str.replace(pattern, value)`
*   `str.to_lowercase()` / `str.to_uppercase()`
*   `str.len_chars()` / `str.len_bytes()`
*   `str.split(by)`
*   `str.strptime(dtype, format)`

```ruby
df = Polars::DataFrame.new({"log": ["INFO:_foo", "WARN:_bar"]})

df.select(
  Polars.col("log").str.split(":_").struct[1].alias("message")
)
# =>
# shape: (2, 1)
# ┌─────────┐
# │ message │
# │ ---     │
# │ str     │
# ╞═════════╡
# │ foo     │
# │ bar     │
# └─────────┘
```

### Datetime Namespace (`.dt`)

For `Datetime`, `Date`, and `Time` data types.

*   `dt.year()`, `dt.month()`, `dt.day()`
*   `dt.hour()`, `dt.minute()`, `dt.second()`
*   `dt.weekday()`, `dt.ordinal_day()`
*   `dt.strftime(format)`
*   `dt.truncate(every)`
*   `dt.offset_by(duration_string)`

```ruby
df = Polars::DataFrame.new(
  {"datetime" => Polars.datetime_range(DateTime.new(2022,1,1), DateTime.new(2022,1,3), "1d", eager: true)}
)

df.with_columns(
  Polars.col("datetime").dt.strftime("%Y-%m-%d (%A)").alias("formatted")
)
# =>
# shape: (3, 2)
# ┌─────────────────────┬───────────────────────────┐
# │ datetime            ┆ formatted                 │
# │ ---                 ┆ ---                       │
# │ datetime[ns]        ┆ str                       │
# ╞═════════════════════╪═══════════════════════════╡
# │ 2022-01-01 00:00:00 ┆ 2022-01-01 (Saturday)     │
# │ 2022-01-02 00:00:00 ┆ 2022-01-02 (Sunday)       │
# │ 2022-01-03 00:00:00 ┆ 2022-01-03 (Monday)       │
# └─────────────────────┴───────────────────────────┘
```

### List & Array Namespaces (`.list`, `.arr`)

For `List` and `Array` data types. Array operations are similar but often preserve the fixed-size nature.

*   `list.len()`
*   `list.sum()`, `list.mean()`, `list.max()`, `list.min()`
*   `list.sort()`
*   `list.get(index)`
*   `list.join(separator)`
*   `list.explode()`
*   `list.eval(expression)`

```ruby
df = Polars::DataFrame.new({
  "grades" => [[10, 8, 9], [6, 7], [9, 8]]
})

df.select(
  Polars.col("grades").list.mean.alias("avg_grade")
)
# =>
# shape: (3, 1)
# ┌───────────┐
# │ avg_grade │
# │ ---       │
# │ f64       │
# ╞═══════════╡
# │ 9.0       │
# │ 6.5       │
# │ 8.5       │
# └───────────┘
```

### Other Namespaces

*   **`.struct`**: For `Struct` types (`field`, `rename_fields`, `unnest`).
*   **`.cat`**: For `Categorical` types (`get_categories`).
*   **`.bin`**: For `Binary` types (`contains`, `encode`, `decode`).
*   **`.meta`**: For expression metadata (`output_name`, `root_names`).
*   **`.name`**: For modifying expression output names (`prefix`, `suffix`).

## Lazy API (`LazyFrame`)

The Lazy API allows you to build a query plan (a `LazyFrame`) which Polars can optimize before execution. This is crucial for performance and for working with datasets larger than memory.

*   **`df.lazy`**: Convert a `DataFrame` to a `LazyFrame`.
*   **`Polars.scan_*`**: Start a lazy query directly from a file.
*   **`ldf.collect`**: Execute the query plan and return a `DataFrame`.
*   **`ldf.fetch(n)`**: Execute the query on the first `n` rows of the data, useful for debugging.
*   **`ldf.sink_*`**: Execute the query and write the result directly to a file without collecting it into memory.

```ruby
# An example of a lazy query
lf = Polars.scan_csv("iris.csv")
query = lf.filter(Polars.col("sepal_length") > 5)
           .group_by("species")
           .agg(Polars.all.sum)

# The query is only executed when .collect() is called
result = query.collect
```

## Grouping

Polars provides powerful grouping capabilities.

#### `group_by`

```ruby
df = Polars::DataFrame.new(
  {
    "category" => ["A", "A", "B", "B", "C"],
    "value" => [1, 2, 3, 4, 5]
  }
)

df.group_by("category", maintain_order: true).agg(
  Polars.col("value").sum.alias("sum_val"),
  Polars.col("value").mean.alias("mean_val")
)
# =>
# shape: (3, 3)
# ┌──────────┬─────────┬──────────┐
# │ category ┆ sum_val ┆ mean_val │
# │ ---      ┆ ---     ┆ ---      │
# │ str      ┆ i64     ┆ f64      │
# ╞══════════╪═════════╪══════════╡
# │ A        ┆ 3       ┆ 1.5      │
# │ B        ┆ 7       ┆ 3.5      │
# │ C        ┆ 5       ┆ 5.0      │
# └──────────┴─────────┴──────────┘
```

#### `group_by_dynamic` & `rolling`

For temporal or sequential data, you can group by dynamic windows.

```ruby
df = Polars::DataFrame.new({
  "ts" => Polars.datetime_range(DateTime.new(2020, 1, 1), DateTime.new(2020, 1, 5), "1d", eager: true),
  "value" => [10, 20, 15, 25, 30]
}).set_sorted("ts")

df.group_by_dynamic(
  "ts",
  every: "2d",
  period: "3d",
  include_boundaries: true
).agg(
  Polars.col("value").sum.alias("value_sum")
)
# =>
# shape: (3, 4)
# ┌─────────────────────┬─────────────────────┬─────────────────────┬───────────┐
# │ _lower_boundary     ┆ _upper_boundary     ┆ ts                  ┆ value_sum │
# │ ---                 ┆ ---                 ┆ ---                 ┆ ---       │
# │ datetime[ns]        ┆ datetime[ns]        ┆ datetime[ns]        ┆ i64       │
# ╞═════════════════════╪═════════════════════╪═════════════════════╪═══════════╡
# │ 2019-12-31 00:00:00 ┆ 2020-01-03 00:00:00 ┆ 2020-01-01 00:00:00 ┆ 45        │
# │ 2020-01-02 00:00:00 ┆ 2020-01-05 00:00:00 ┆ 2020-01-03 00:00:00 ┆ 70        │
# │ 2020-01-04 00:00:00 ┆ 2020-01-07 00:00:00 ┆ 2020-01-05 00:00:00 ┆ 30        │
# └─────────────────────┴─────────────────────┴─────────────────────┴───────────┘
```

## Joins & Concatenation

#### Joins

*   **`df.join(other_df, on:, how:)`**: Standard SQL-style joins.
*   **`df.join_asof(other_df, on:, by:, strategy:)`**: Joins on the nearest key.

```ruby
df_a = Polars::DataFrame.new({a: [1, 2, 3], b: ["one", "two", "three"]})
df_b = Polars::DataFrame.new({a: [1, 1, 2], c: ["c1", "c2", "c3"]})

df_a.join(df_b, on: "a", how: "inner")
# =>
# shape: (3, 3)
# ┌─────┬───────┬─────┐
# │ a   ┆ b     ┆ c   │
# │ --- ┆ ---   ┆ --- │
# │ i64 ┆ str   ┆ str │
# ╞═════╪═══════╪═════╡
# │ 1   ┆ one   ┆ c1  │
# │ 1   ┆ one   ┆ c2  │
# │ 2   ┆ two   ┆ c3  │
# └─────┴───────┴─────┘
```

#### Concatenation

*   **`Polars.concat(items, how:)`**: Concatenate a list of `DataFrames` or `Series`.

```ruby
df1 = Polars::DataFrame.new({a: [1], b: [3]})
df2 = Polars::DataFrame.new({a: [2], b: [4]})

# Vertical concatenation
Polars.concat([df1, df2], how: "vertical")
# =>
# shape: (2, 2)
# ┌─────┬─────┐
# │ a   ┆ b   │
# │ --- ┆ --- │
# │ i64 ┆ i64 │
# ╞═════╪═════╡
# │ 1   ┆ 3   │
# │ 2   ┆ 4   │
# └─────┴─────┘

# Horizontal concatenation
df3 = Polars::DataFrame.new({c: [5], d: [6]})
Polars.concat([df1, df3], how: "horizontal")
# =>
# shape: (1, 4)
# ┌─────┬─────┬─────┬─────┐
# │ a   ┆ b   ┆ c   ┆ d   │
# │ --- ┆ --- ┆ --- ┆ --- │
# │ i64 ┆ i64 ┆ i64 ┆ i64 │
# ╞═════╪═════╪═════╪═════╡
# │ 1   ┆ 3   ┆ 5   ┆ 6   │
# └─────┴─────┴─────┴─────┘
```

## Selectors (`cs`)

Selectors provide a concise way to select multiple columns based on their names, dtypes, or other properties. They are used within `select`, `with_columns`, etc.

*   `Polars.cs.all`
*   `Polars.cs.numeric`, `Polars.cs.string`, `Polars.cs.temporal`, etc.
*   `Polars.cs.by_name("a", "b")`
*   `Polars.cs.starts_with("prefix_")`, `Polars.cs.ends_with("_suffix")`
*   `Polars.cs.matches("regex")`

```ruby
df = Polars::DataFrame.new({
  "temp_c" => [10, 20],
  "temp_f" => [50, 68],
  "unit" => ["C", "F"]
})

# Select all numeric columns and multiply by 2
df.select(Polars.cs.numeric * 2)
# =>
# shape: (2, 2)
# ┌────────┬────────┐
# │ temp_c ┆ temp_f │
# │ ---    ┆ ---    │
# │ i64    ┆ i64    │
# ╞════════╪════════╡
# │ 20     ┆ 100    │
# │ 40     ┆ 136    │
# └────────┴────────┘
```

## SQL Interface

You can query `DataFrame` and `LazyFrame` objects using SQL.

*   `Polars::SQLContext.new(...)`
*   `ctx.register(name, frame)`
*   `ctx.execute(query)`

```ruby
lf = Polars::LazyFrame.new({"a" => [1, 2, 3], "b" => ["x", nil, "z"]})
ctx = Polars::SQLContext.new(frame: lf)

result_lf = ctx.execute(
  "SELECT b, a*2 AS two_a FROM frame WHERE b IS NOT NULL"
)

result_lf.collect
# =>
# shape: (2, 2)
# ┌─────┬───────┐
# │ b   ┆ two_a │
# │ --- ┆ ---   │
# │ str ┆ i64   │
# ╞═════╪═══════╡
# │ x   ┆ 2     │
# │ z   ┆ 6     │
# └─────┴───────┘
```

## Configuration

Customize Polars' behavior, especially for display formatting.

```ruby
# Temporarily set configuration options for a block of code
Polars.config(tbl_rows: 5, tbl_cols: 4) do
  # Code here will display DataFrames with at most 5 rows and 4 columns
  puts Polars::DataFrame.new(10.times.to_h { |i| [i.to_s, (1..10).to_a] })
end
```

## Data Types

Polars has a rich set of data types.

**Numeric:**
*   `Polars::Int8`, `Int16`, `Int32`, `Int64`
*   `Polars::UInt8`, `UInt16`, `UInt32`, `UInt64`
*   `Polars::Float32`, `Float64`
*   `Polars::Decimal`

**Other:**
*   `Polars::Boolean`
*   `Polars::String`
*   `Polars::Binary`
*   `Polars::Categorical`
*   `Polars::Enum`
*   `Polars::Object` (for arbitrary Ruby objects)

**Temporal:**
*   `Polars::Date`
*   `Polars::Time`
*   `Polars::Datetime`
*   `Polars::Duration`

**Nested:**
*   `Polars::List`
*   `Polars::Array`
*   `Polars::Struct`

You can specify dtypes during creation or cast later:

```ruby
# Specify on creation
df = Polars::DataFrame.new(
  {"a" => [1, 2]},
  schema: {"a" => Polars::Int16}
)

# Cast an existing column
df.select(Polars.col("a").cast(Polars::Float64))
```
