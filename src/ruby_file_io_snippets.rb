# ruby_file_io_snippets.rb
# Ruby snippets for reading from, writing to, and creating files.
# Standard library only unless noted.

require "csv"
require "json"
require "fileutils"
require "pathname"
require "tempfile"
require "stringio"
require "time"

# -----------------------------------------------------------------------------
# 1. Basic paths and existence checks
# -----------------------------------------------------------------------------

path = "example.txt"

puts File.exist?(path)          # true / false
puts File.file?(path)           # true if regular file
puts File.directory?("data")    # true if directory

file_path = Pathname.new("data/orders.txt")
puts file_path.dirname          # data
puts file_path.basename         # orders.txt
puts file_path.extname          # .txt


# -----------------------------------------------------------------------------
# 2. Create directories before writing files
# -----------------------------------------------------------------------------

FileUtils.mkdir_p("output/reports")
File.write("output/reports/readme.txt", "Reports will be written here.\n")


# -----------------------------------------------------------------------------
# 3. Full read: read the entire file into memory
# -----------------------------------------------------------------------------
# Best for small files.

text = File.read("output/reports/readme.txt")
puts text


# -----------------------------------------------------------------------------
# 4. Full write: overwrite a file
# -----------------------------------------------------------------------------
# Creates the file if it does not exist.
# Replaces the file contents if it already exists.

File.write("output/message.txt", "Hello from Ruby!\n")


# -----------------------------------------------------------------------------
# 5. Append to a file
# -----------------------------------------------------------------------------

File.open("output/message.txt", "a") do |file|
  file.puts "This line was appended."
end


# -----------------------------------------------------------------------------
# 6. Read line-by-line
# -----------------------------------------------------------------------------
# Better for large files than File.read.

File.foreach("output/message.txt") do |line|
  puts "LINE: #{line.chomp}"
end


# -----------------------------------------------------------------------------
# 7. Stream read in chunks
# -----------------------------------------------------------------------------
# Useful for large files, uploads, binary files, or processing without loading
# everything into memory.

File.open("output/message.txt", "r") do |file|
  while (chunk = file.read(1024))
    puts "Read #{chunk.bytesize} bytes"
  end
end


# -----------------------------------------------------------------------------
# 8. Stream copy from one file to another
# -----------------------------------------------------------------------------

source_path = "output/message.txt"
destination_path = "output/message_copy.txt"

File.open(source_path, "rb") do |source|
  File.open(destination_path, "wb") do |destination|
    while (chunk = source.read(16 * 1024))
      destination.write(chunk)
    end
  end
end


# -----------------------------------------------------------------------------
# 9. Read all lines into an array
# -----------------------------------------------------------------------------
# Fine for small files. Avoid for very large files.

lines = File.readlines("output/message.txt", chomp: true)
puts lines.inspect


# -----------------------------------------------------------------------------
# 10. Write an array of lines
# -----------------------------------------------------------------------------

names = ["Chris", "Felix", "Elizabeth", "Andre"]

File.open("output/names.txt", "w") do |file|
  names.each do |name|
    file.puts name
  end
end


# -----------------------------------------------------------------------------
# 11. Create a file only if it does not exist
# -----------------------------------------------------------------------------

new_file = "output/created_once.txt"

unless File.exist?(new_file)
  File.write(new_file, "Created at #{Time.now}\n")
end


# -----------------------------------------------------------------------------
# 12. Exclusive create mode
# -----------------------------------------------------------------------------
# "wx" creates a file for writing but raises Errno::EEXIST if it already exists.
# This helps prevent accidental overwrites.

begin
  File.open("output/exclusive_create.txt", "wx") do |file|
    file.puts "This file was created only if it did not already exist."
  end
rescue Errno::EEXIST
  puts "File already exists; not overwriting."
end


# -----------------------------------------------------------------------------
# 13. Safer writes with a temp file and rename
# -----------------------------------------------------------------------------
# This helps avoid leaving a partially-written file if something fails halfway.

# rubocop:disable Naming/MethodParameterName
def atomic_write(path, contents)
  directory = File.dirname(path)
  FileUtils.mkdir_p(directory)

  Tempfile.create(["atomic", ".tmp"], directory) do |tempfile|
    tempfile.write(contents)
    tempfile.flush
    tempfile.fsync
    tempfile.close

    File.rename(tempfile.path, path)
  end
end
# rubocop:enable Naming/MethodParameterName

atomic_write("output/atomic.txt", "Written safely.\n")


# -----------------------------------------------------------------------------
# 14. Read and write JSON
# -----------------------------------------------------------------------------

user = {
  id: 1,
  name: "Timothy",
  admin: true,
  tags: ["ruby", "rails", "shopify"]
}

File.write("output/user.json", JSON.pretty_generate(user))
loaded_user = JSON.parse(File.read("output/user.json"), symbolize_names: true)
puts loaded_user[:name]


# -----------------------------------------------------------------------------
# 15. Stream JSON Lines / NDJSON
# -----------------------------------------------------------------------------
# JSON Lines stores one JSON object per line.
# Useful for logs, exports, and large datasets.

events = [
  { type: "created", id: 1 },
  { type: "updated", id: 1 },
  { type: "deleted", id: 1 }
]

File.open("output/events.jsonl", "w") do |file|
  events.each do |event|
    file.puts JSON.generate(event)
  end
end

File.foreach("output/events.jsonl") do |line|
  event = JSON.parse(line, symbolize_names: true)
  puts "#{event[:type]} #{event[:id]}"
end


# -----------------------------------------------------------------------------
# 16. Read and write CSV
# -----------------------------------------------------------------------------

people = [
  { name: "Chris", email: "chris@example.com" },
  { name: "Felix", email: "felix@example.net" },
  { name: "Elizabeth", email: "lizzy1994@example.com" }
]

CSV.open("output/people.csv", "w", write_headers: true, headers: ["name", "email"]) do |csv|
  people.each do |person|
    csv << [person[:name], person[:email]]
  end
end

CSV.foreach("output/people.csv", headers: true) do |row|
  puts "#{row["name"]} <#{row["email"]}>"
end


# -----------------------------------------------------------------------------
# 17. Stream CSV from a large file
# -----------------------------------------------------------------------------
# CSV.foreach streams row-by-row instead of loading everything at once.

def count_csv_rows(path)
  count = 0

  CSV.foreach(path, headers: true) do |_row|
    count += 1
  end

  count
end

puts count_csv_rows("output/people.csv")


# -----------------------------------------------------------------------------
# 18. Read and write binary files
# -----------------------------------------------------------------------------
# Use "rb" and "wb" for binary mode.

binary_data = [137, 80, 78, 71].pack("C*") # PNG signature bytes, not a full PNG.

File.open("output/sample.bin", "wb") do |file|
  file.write(binary_data)
end

File.open("output/sample.bin", "rb") do |file|
  bytes = file.read.bytes
  puts bytes.inspect
end


# -----------------------------------------------------------------------------
# 19. File metadata
# -----------------------------------------------------------------------------

stat = File.stat("output/message.txt")

puts stat.size        # file size in bytes
puts stat.mtime       # last modified time
puts stat.ctime       # metadata change time
puts stat.readable?   # true / false
puts stat.writable?   # true / false


# -----------------------------------------------------------------------------
# 20. Rename, move, copy, and delete files
# -----------------------------------------------------------------------------

File.write("output/to_move.txt", "Move me.\n")

FileUtils.cp("output/to_move.txt", "output/copied.txt")
FileUtils.mv("output/to_move.txt", "output/moved.txt")

File.delete("output/copied.txt") if File.exist?("output/copied.txt")


# -----------------------------------------------------------------------------
# 21. List files in a directory
# -----------------------------------------------------------------------------

Dir.children("output").each do |entry|
  puts entry
end

Dir.glob("output/**/*.txt").each do |txt_file|
  puts "Text file: #{txt_file}"
end


# -----------------------------------------------------------------------------
# 22. Recursively process files
# -----------------------------------------------------------------------------

def total_bytes_under(directory)
  total = 0

  Dir.glob(File.join(directory, "**", "*")).each do |path|
    total += File.size(path) if File.file?(path)
  end

  total
end

puts total_bytes_under("output")


# -----------------------------------------------------------------------------
# 23. Working with Tempfile
# -----------------------------------------------------------------------------
# Useful for generated files, uploads, tests, and intermediate work.

Tempfile.create(["example", ".txt"]) do |file|
  file.puts "Temporary content"
  file.rewind

  puts file.read
end


# -----------------------------------------------------------------------------
# 24. Working with StringIO as a file-like object
# -----------------------------------------------------------------------------
# Helpful in tests when you do not want to touch the filesystem.

fake_file = StringIO.new
fake_file.puts "line one"
fake_file.puts "line two"
fake_file.rewind

fake_file.each_line do |line|
  puts "FAKE: #{line.chomp}"
end


# -----------------------------------------------------------------------------
# 25. Error handling around file operations
# -----------------------------------------------------------------------------

begin
  contents = File.read("missing_file.txt")
  puts contents
rescue Errno::ENOENT
  puts "File was not found."
rescue Errno::EACCES
  puts "Permission denied."
rescue StandardError => error
  puts "Unexpected file error: #{error.class}: #{error.message}"
end


# -----------------------------------------------------------------------------
# 26. Validate a file before processing
# -----------------------------------------------------------------------------

def read_required_file(path)
  raise ArgumentError, "Path is required" if path.nil? || path.strip.empty?
  raise ArgumentError, "File does not exist: #{path}" unless File.file?(path)
  raise ArgumentError, "File is empty: #{path}" if File.zero?(path)

  File.read(path)
end

puts read_required_file("output/message.txt")


# -----------------------------------------------------------------------------
# 27. Process a text file and write transformed output
# -----------------------------------------------------------------------------

def uppercase_file(input_path, output_path)
  FileUtils.mkdir_p(File.dirname(output_path))

  File.open(input_path, "r") do |input|
    File.open(output_path, "w") do |output|
      input.each_line do |line|
        output.puts line.upcase
      end
    end
  end
end

uppercase_file("output/message.txt", "output/message_uppercase.txt")


# -----------------------------------------------------------------------------
# 28. Read a config-like key=value file
# -----------------------------------------------------------------------------

File.write("output/app.env", <<~ENV_FILE)
  APP_NAME=FileDemo
  RAILS_ENV=development
  DEBUG=true
ENV_FILE

def read_key_value_file(path)
  values = {}

  File.foreach(path) do |line|
    line = line.strip

    next if line.empty?
    next if line.start_with?("#")

    key, value = line.split("=", 2)
    values[key] = value
  end

  values
end

puts read_key_value_file("output/app.env").inspect


# -----------------------------------------------------------------------------
# 29. Simple logger-style write
# -----------------------------------------------------------------------------

def log_line(path, message)
  FileUtils.mkdir_p(File.dirname(path))

  File.open(path, "a") do |file|
    file.puts "[#{Time.now.utc.iso8601}] #{message}"
  end
end

log_line("output/app.log", "Application started")


# -----------------------------------------------------------------------------
# 30. Common File.open modes
# -----------------------------------------------------------------------------
#
# "r"   Read-only, file must exist.
# "w"   Write-only, creates or truncates.
# "a"   Append-only, creates if missing.
# "r+"  Read/write, file must exist.
# "w+"  Read/write, creates or truncates.
# "a+"  Read/append, creates if missing.
# "rb"  Binary read.
# "wb"  Binary write.
# "ab"  Binary append.
# "wx"  Exclusive create/write; fails if file exists.
#
# Interview talking points:
#
# - Use full reads only for small files.
# - Use streaming for large files.
# - Use binary mode for non-text files.
# - Avoid overwriting important files accidentally.
# - Validate paths and handle missing files.
# - Prefer atomic writes for important generated outputs.
